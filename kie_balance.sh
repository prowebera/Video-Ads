#!/usr/bin/env bash
# Prints the kie.ai balance in credits and dollars (200 credits ~= $1).
set -u; . "$(dirname "$0")/_kie_env.sh"
c=$(curl -s -H "Authorization: Bearer $KIE_API_KEY" https://api.kie.ai/api/v1/chat/credit | jq -r .data)
echo "balance: $c credits (~\$$(echo "$c/200" | bc -l | xargs printf '%.2f'))"
