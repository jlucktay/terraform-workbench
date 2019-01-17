#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

IP=$(curl --silent httpbin.org/ip | jq -r .origin)

jq -n --arg ip "$IP" '{"ip":$ip}'
