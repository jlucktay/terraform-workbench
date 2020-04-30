#!/usr/bin/env bash
set -euxo pipefail
shopt -s globstar nullglob
IFS=$'\n\t'

# Boilerplate - update/upgrade
apt-get update && apt-get upgrade --assume-yes && apt-get autoremove --assume-yes

# https://docs.docker.com/engine/install/ubuntu/

## Installation methods

### Install using the repository

#### SET UP THE REPOSITORY

##### Update the apt package index and install packages to allow apt to use a repository over HTTPS
apt-get update
apt-get install --assume-yes --no-install-recommends \
  apt-transport-https \
  ca-certificates \
  curl \
  gnupg-agent \
  software-properties-common

##### Add Docker’s official GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -

# Verify that you now have the key with the fingerprint 9DC8 5822 9FC7 DD38 854A  E2D8 8D81 803C 0EBF CD88,
# by searching for the last 8 characters of the fingerprint
export APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=1

if ! verify_key=$(apt-key fingerprint 0EBFCD88 \
  | grep --count "9DC8 5822 9FC7 DD38 854A  E2D8 8D81 803C 0EBF CD88"); then
  exit 1
fi

if [ "$verify_key" != "1" ]; then
  exit 1
fi

##### Use the following command to set up the stable repository
add-apt-repository \
  "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

#### INSTALL DOCKER ENGINE

##### Update the apt package index, and install the latest version of Docker Engine and containerd
apt-get update
apt-get install --assume-yes --no-install-recommends \
  containerd.io \
  docker-ce \
  docker-ce-cli

##### Verify that Docker Engine is installed correctly by running the hello-world image
docker run hello-world

# https://docs.docker.com/engine/install/linux-postinstall/

## Manage Docker as a non-root user

### Create the docker group
groupadd docker || true

# +++ Users already present
while IFS= read -r line; do
  user_id=$(cut --delimiter=":" --fields=3 <<< "$line")

  if ((user_id >= 1000)) && ((user_id < 65534)); then
    user_name=$(cut --delimiter=":" --fields=1 <<< "$line")
    usermod --append --groups docker "$user_name"
  fi
done < /etc/passwd

# +++ Users added via conventional adduser
echo 'EXTRA_GROUPS="docker"' | tee --append /etc/adduser.conf
echo 'ADD_EXTRA_GROUPS=1' | tee --append /etc/adduser.conf

## Configure Docker to start on boot

### systemd
systemctl enable docker

# https://rancher.com/quick-start/
docker run -d --restart=unless-stopped -p 80:80 -p 443:443 rancher/rancher

reboot
