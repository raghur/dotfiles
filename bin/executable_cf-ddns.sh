#!/bin/bash

set -euo pipefail

prereqs=(curl jq getopt )
function check_prereqs() {
    for dep in "${prereqs[@]}"; do
    if ! command -v "$dep" &> /dev/null; then
        echo "Error: $dep is not installed." >&2
        return 1
    fi
    done
    
}
MYDOMAIN=rraghur.in
function printHelp() {
    cat <<EOF
Cloudflare DDNS update script

SYNTAX: cf-ddns.sh [-a existing | -c target] -n name [names...]
Looks for record with name=existing.rraghur.in and updates the content to current ipv6.

OPTIONS:
    -a|--aaaa  - Update AAAA record existing.$MYDOMAIN. 
    -n|--name  - Rename existing AAAA record to name.$MYDOMAIN
    -c|--cname - Upsert CNAME records [names...] to point to target.$MYDOMAIN

AAAA record update
    On success, points either \$existing.rraghur.in or \$new.rraghur.in to the current ipv6

CNAME records
    * Existing records content is modified.
    * Other CNAME records on the DNS are left untouched

LOGGING:
Writes to system log with tag = CFDDNS; Can be queried with journalctl with journalctl -ft CFDDNS

EOF
    exit 0;
}

OPTIONS=$(getopt -o vha:c:n: --long verbose,help,aaaa:,cname:,name: -n 'cf-ddns' -- "$@")
if [ $? != 0 ] ; then echo "Terminating..." >&2 ; exit 1 ; fi
eval set -- "$OPTIONS"
echo $OPTIONS
# Now use a standard while/case loop to process the options
cnameTarget=""
aaaa=""
name=""
while true; do
  case "$1" in
    -h | --help ) printHelp; shift ;;
    -v | --verbose ) verbose_flag=1; shift ;;
    -a | --aaaa )    aaaa="$2"; shift 2 ;; # Shift 2: option + arg
    -n | --name )    name="$2"; shift 2 ;; # Shift 2: option + arg
    -c | --cname )    cnameTarget="$2"; shift 2 ;; # Shift 2: option + arg
    -- ) shift; break ;; # End of options
    * ) break ;;
  esac
done
if [ -n "$cnameTarget" ] && [ $# -eq 0 ]; then
    echo "CNAME update requires one or more domain names"
    exit 1
fi
if [ -z $aaaa ] && [ -z $cnameTarget ]; then
    echo "Either -a|-aaaa or -c|-cname is required"
    exit 1
fi


function updateAAAA() {

    check_prereqs
    existingName=$aaaa
    newName=${name:-$existingName}
    existingDnsName="$existingName.rraghur.in"
    dnsName="$newName.rraghur.in"
    echo $existingDnsName $dnsName

    ipv6=$(ip -6 a |grep inet6|grep -i global| grep -Pio '2[0-9a-f:]+'| head -n1)
    payload=$(cat <<EOF
{"type":"AAAA","name":"$newName","content":"$ipv6","ttl":1,"priority":10,"proxied":false}
EOF
)
    read CF_RECID currentIpAddr <<< $(curl -s "https://api.cloudflare.com/client/v4/zones/$CF_ZONE/dns_records?name=$existingDnsName" \
        -H "Authorization: Bearer $CF_KEY" \
        -H "Content-Type: application/json" | jq -r '.result[0] | [.id,.content]|@tsv')
    # logger -t CFDDNS "CF: $current; Machine: $ipv6"
    if [ -z $CF_RECID ]; then
        echo "Failed to locate existing DNS record with name=$existingDnsName"
        exit 2;
    fi

    if [[ x$currentIpAddr != x$ipv6 || x$existingName != x$newName ]]; then
        res=$(curl -s -X PUT "https://api.cloudflare.com/client/v4/zones/$CF_ZONE/dns_records/$CF_RECID" \
                 -H "Authorization: Bearer $CF_KEY" \
                 -H "Content-Type: application/json" \
                 --data "$payload")

        responseStatus=$(echo $res | jq ".success")
        if [ x$responseStatus == x"true" ]; then
            logger -t CFDDNS "Updated cloudflare DDNS: $dnsName -> $ipv6: $responseStatus"
        else
            logger -t CFDDNS "Failed to update DDNS record for $dnsName. Error $res"
            exit 1
        fi
    else
        logger -t CFDDNS "Skipping CF update - IP $dnsName -> $ipv6 is current"
    fi
}

cf_upsert_cname() {

  if [ -z "$CF_KEY" ] || [ -z "$CF_ZONE" ]; then
    echo "Error: CF_KEY and CF_ZONE environment variables must be set." >&2
    return 1
  fi

  local record_name="$1.$MYDOMAIN"
  local target_cname="$2.$MYDOMAIN"
  local zone_id="$CF_ZONE"
  local api_token="$CF_KEY"

  local api_url="https://api.cloudflare.com/client/v4/zones/$zone_id/dns_records"
  local headers=(
    -H "Authorization: Bearer $api_token"
    -H "Content-Type: application/json"
  )

  echo "Searching for existing CNAME record for: $record_name..."

  # 2. Find Existing Record ID
  # We query the API specifically for the CNAME record by name and type.
  local query_url="$api_url?type=CNAME&name=$record_name"
  local response=$(curl -s -X GET "$query_url" "${headers[@]}")

  # Check if the API call was successful
  local success=$(echo "$response" | jq -r '.success')
  if [ "$success" != "true" ]; then
    echo "Error checking existing record:" >&2
    echo "$response" | jq '.errors' >&2
    return 1
  fi

  local record_id=$(echo "$response" | jq -r '.result[] | select(.name == "'"$record_name"'") | .id')

  # 3. Construct the JSON Payload
  local json_payload=$(cat <<EOF
{
  "type": "CNAME",
  "name": "$record_name",
  "content": "$target_cname",
  "ttl": 1,
  "proxied": false
}
EOF
)
  local http_method
  local endpoint_url
  local action_desc

  # 4. Determine Action (Update or Create)
  if [ -n "$record_id" ]; then
    # UPDATE existing record
    http_method="PUT"
    endpoint_url="$api_url/$record_id"
    action_desc="Updated"
    echo "Found existing record (ID: $record_id). Preparing to update..."
  else
    # CREATE new record
    http_method="POST"
    endpoint_url="$api_url"
    action_desc="Created"
    echo "Record not found. Preparing to create new CNAME record..."
  fi

  # 5. Execute API Call (Upsert)
  local upsert_response=$(curl -s -X "$http_method" "$endpoint_url" \
    "${headers[@]}" \
    -d "$json_payload")

  local upsert_success=$(echo "$upsert_response" | jq -r '.success')

  if [ "$upsert_success" = "true" ]; then
    echo "--------------------------------------------------------"
    echo "SUCCESS: CNAME record $record_name $action_desc successfully."
    echo "Target: $target_cname"
    echo "--------------------------------------------------------"
    return 0
  else
    echo "--------------------------------------------------------" >&2
    echo "FAILURE: Failed to $action_desc CNAME record." >&2
    echo "API Errors:" >&2
    echo "$upsert_response" | jq '.errors' >&2
    echo "--------------------------------------------------------" >&2
    return 1
  fi
}
if [ -r "~/.local/cf-ddns.secrets" ]; then
    echo "Failed to find secrets"
    exit 1
fi
source ~/.local/cf-ddns.secrets
[ -n "$aaaa" ] && updateAAAA
if [ -n "$cnameTarget" ]; then
    check_prereqs
    for name in "$@"
    do
        cf_upsert_cname $name $cnameTarget
    done
fi
