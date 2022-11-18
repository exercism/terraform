###################
# System packages #
###################
sudo apt update

sudo apt install -y ffmpeg software-properties-common
sudo add-apt-repository -y ppa:deadsnakes/ppa
sudo apt update
sudo apt install -y python3.8 python3-pip

wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/cuda-keyring_1.0-1_all.deb
sudo dpkg -i cuda-keyring_1.0-1_all.deb
sudo apt-get update
sudo apt-get -y install cuda

##########################
# Install OpenAI whisper #
##########################
sudo su -
  pip install git+https://github.com/openai/whisper.git  
  pip uninstall torch
  pip cache purge
  pip3 install torch torchvision torchaudio --extra-index-url https://download.pytorch.org/whl/cu116

  echo 'export PATH="/home/ubuntu/.local/bin:$PATH"' >> ~/.bashrc
  source ~/.bashrc
exit
