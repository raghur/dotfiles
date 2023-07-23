#!/bin/bash
source /home/raghu/.local/cf.secrets
ipv6=$(ip -6 a |grep inet6|grep -i global| grep -Pio '2[0-9a-f:]+'| head -n1)
payload=$(cat <<EOF
{"type":"AAAA","name":"wg","content":"$ipv6","ttl":1,"priority":10,"proxied":false}
EOF
)

# read ipv6 from file; falling back to API if needed
current=$(cat /tmp/ipv6 || curl -s "https://api.cloudflare.com/client/v4/zones/$CF_ZONE/dns_records/$CF_RECID" \
     -H "X-Auth-Email: $CF_USER" \
     -H "X-Auth-Key: $CF_KEY" \
     -H "Content-Type: application/json"\
     | grep -Pio '"content":".*?"' \
     | grep -Pio '2[0-9a-f:]+'\
     | tee /tmp/ipv6)
# logger -t CFDDNS "CF: $current; Machine: $ipv6"

if [ x$current != x$ipv6 ]; then
         curl -X PUT "https://api.cloudflare.com/client/v4/zones/$CF_ZONE/dns_records/$CF_RECID" \
             -H "X-Auth-Email: $CF_USER" \
             -H "X-Auth-Key: $CF_KEY" \
             -H "Content-Type: application/json" \
             --data "$payload"
        logger -t CFDDNS "Updated cloudflare IP: $ipv6 - status $?"
else
        logger -t CFDDNS "Skipping CF update - IP $ipv6 is current"
fi

