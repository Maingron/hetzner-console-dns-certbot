#!/bin/bash

token=$(cat /etc/hetzner-dns-token)
domain_name=$( echo $CERTBOT_DOMAIN | rev | cut -d'.' -f 1,2 | rev)
rr_name=_acme-challenge.${CERTBOT_DOMAIN%$domain_name}
rr_type=TXT
# Remove dot for non wildcard requests
rr_name=${rr_name%.}

curl -X "DELETE" "https://api.hetzner.cloud/v1/zones/${domain_name}/rrsets/${rr_name}/${rr_type}" \
     -H "Authorization: Bearer ${token}" >/dev/null 2>/dev/null
