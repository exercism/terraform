###################
# System packages #
###################
sudo apt update
sudo apt install -y ffmpeg software-properties-common
sudo add-apt-repository -y ppa:deadsnakes/ppa
sudo apt update
sudo apt install -y python3.8 python3-pip

##########################
# Install OpenAI whisper #
##########################
sudo su -
  pip install git+https://github.com/openai/whisper.git  
  echo 'export PATH="/home/ubuntu/.local/bin:$PATH"' >> ~/.bashrc
  source ~/.bashrc
exit
