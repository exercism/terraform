# Install docker
sudo apt-get remove docker docker-engine docker.io containerd runc
sudo apt-get update
sudo apt-get install unzip apt-transport-https ca-certificates curl gnupg-agent software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt-get install docker-ce docker-ce-cli containerd.io

sudo groupadd docker
sudo usermod -aG docker $USER
newgrp docker 
docker run hello-world

sudo systemctl enable docker

echo '0 0 * * * docker system prune --all --force --filter until="48h"' | sudo crontab -u root -

mkdir aws-setup && cd aws-setup
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
cd ~



# Create a folder
mkdir actions-runner && cd actions-runner

# Download the latest runner package
curl -O -L https://github.com/actions/runner/releases/download/v2.274.2/actions-runner-linux-x64-2.274.2.tar.gz

# Extract the installer
tar xzf ./actions-runner-linux-x64-2.274.2.tar.gz

# Create the runner and start the configuration experience
./config.sh --url https://github.com/exercism/website-deployer --token AACF6DA7L5JOT5DFLBQXJ3C7ZLQSU

# Install as a service
sudo ./svc.sh install

# Last step, run it!
./run.sh

