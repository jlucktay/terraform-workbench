#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

CurlTimeS3=$(terraform output awesome-s3)
CurlTimeCdn=$(terraform output awesome-cdn)

echo "S3:"

for i in {01..10}; do
    curl --silent --write-out "[$i] %{time_total}\\n" --output /dev/null "$CurlTimeS3"
done

echo
echo "CloudFront:"

for i in {01..10}; do
    curl --silent --write-out "[$i] %{time_total}\\n" --output /dev/null "$CurlTimeCdn"
done
