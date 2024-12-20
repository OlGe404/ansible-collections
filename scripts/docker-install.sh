#!/bin/bash

help() {
    cat <<EOF
Usage: ./$(basename "$0")

Description:
  Installs the docker daemon and its utilities on ubuntu-based systems as described at "https://docs.docker.com/engine/install/ubuntu/", if it's not already installed.
  It also performs the post-installation steps for linux as described at "https://docs.docker.com/engine/install/linux-postinstall/".
  
  If you want to install docker on a machine that is not ubuntu-based, see "https://docs.docker.com/engine/install/".

Options:
  -h, --help    Show this help message and exit.

EOF
}

if [ "$1" == "--help" ] || [ "$1" == "-h" ]; then
    help
    exit 0
fi

if ! grep -i -q "ubuntu" /etc/os-release; then
    echo -e "🚨 ERROR: This is not an ubuntu-based machine. This script won't work here. \n"
    help
    exit 1
fi

if docker ps > /dev/null; then
  echo -e "🚨 ERROR: Docker is already installed. \n"
  help
  exit 1
fi

sudo apt update
sudo apt install -y ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$UBUNTU_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt update

sudo apt install -y \
    docker-ce \
    docker-ce-cli \
    containerd.io \
    docker-buildx-plugin \
    docker-compose-plugin

sudo groupadd docker
sudo usermod -aG docker "$USER"
newgrp docker
docker run hello-world

sudo chown "$USER:$USER" "/home/$USER/.docker" -R
sudo chmod g+rwx "$HOME/.docker" -R

sudo systemctl enable docker.service
sudo systemctl enable containerd.service
