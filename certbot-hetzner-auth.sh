#!/bin/bash

token=$(cat /etc/hetzner-dns-token)
domain_name=$( echo $CERTBOT_DOMAIN | rev | cut -d'.' -f 1,2 | rev)
rr_name=_acme-challenge.${CERTBOT_DOMAIN%$domain_name}
ttl=60 # As of Dec 2025, 60 is the minimum TTL for Hetzner Zones
rr_type=TXT
# Remove dot for non wildcard requests
rr_name=${rr_name%.}

curl -X "POST" "https://api.hetzner.cloud/v1/zones/${domain_name}/rrsets" \
     -H "Content-Type: application/json" \
     -H "Authorization: Bearer ${token}" \
     -d "{ \"name\":\"${rr_name}\", \"type\":\"${rr_type}\", \"ttl\":${ttl}, \"records\":[{\"value\":\"\\\"${CERTBOT_VALIDATION}\\\"\"}] }" > /dev/null 2>/dev/null

# just make sure we sleep for a while (this should be a dig poll loop)
sleep 30
