# Install docker
sudo apt-get remove docker docker-engine docker.io containerd runc
sudo apt-get update
sudo apt-get install apt-transport-https ca-certificates curl gnupg-agent software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt-get install docker-ce docker-ce-cli containerd.io

sudo groupadd docker
sudo usermod -aG docker $USER
newgrp docker 
docker run hello-world

sudo systemctl enable docker




# Create a folder
mkdir actions-runner && cd actions-runner

# Download the latest runner package
curl -O -L https://github.com/actions/runner/releases/download/v2.274.2/actions-runner-linux-x64-2.274.2.tar.gz

# Extract the installer
tar xzf ./actions-runner-linux-x64-2.274.2.tar.gz

# Create the runner and start the configuration experience
./config.sh --url https://github.com/exercism/v3-website --token AACF6DF67BZ3COX6LOL42LS7W3DVQ

# Install as a service
sudo ./svc.sh install

# Last step, run it!
./run.sh
