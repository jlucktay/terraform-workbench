#!/usr/bin/env bash
# Thank you: https://github.com/anordal/shellharden/blob/master/how_to_do_things_safely_in_bash.md#how-to-begin-a-bash-script
if test "$BASH" = "" || "$BASH" -uc "a=();true \"\${a[@]}\"" 2>/dev/null; then
    # Bash 4.4, Zsh
    set -euo pipefail
else
    # Bash 4.3 and older chokes on empty arrays with set -u.
    set -eo pipefail
fi
shopt -s nullglob globstar
IFS=$'\n\t'

docker run \
    --env XC_OS=darwin \
    --env XC_ARCH=amd64 \
    --rm \
    --volume "$(go list -f '{{.Dir}}' "github.com/hashicorp/terraform"):/go/src/github.com/hashicorp/terraform" \
    --workdir /go/src/github.com/hashicorp/terraform \
    golang:latest \
    bash -c "apt-get update && apt-get install -y zip && make bin"
