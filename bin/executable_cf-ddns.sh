#!/bin/bash
source ~/.local/cf-ddns.secrets
ipv6=$(ip -6 a |grep inet6|grep -i global| grep -Pio '2[0-9a-f:]+'| head -n1)
existingName=${1:-home}
newName=${2:-$existingName}
existingDnsName="$existingName.rraghur.in"
dnsName="$newName.rraghur.in"
# echo $dnsName
payload=$(cat <<EOF
{"type":"AAAA","name":"$newName","content":"$ipv6","ttl":1,"priority":10,"proxied":false}
EOF
)
read CF_RECID currentIpAddr <<< $(curl -s "https://api.cloudflare.com/client/v4/zones/$CF_ZONE/dns_records?name=$existingDnsName" \
    -H "Authorization: Bearer $CF_KEY" \
    -H "Content-Type: application/json" | jq -r '.result[0] | [.id,.content]|@tsv')

if [ -z $CF_RECID ]; then
    echo "Failed to locate existing DNS record with name=$existingDnsName"
    exit 2;
fi

# logger -t CFDDNS "CF: $current; Machine: $ipv6"
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

