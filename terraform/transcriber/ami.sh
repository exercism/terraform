###################
# System packages #
###################
sudo apt update
sudo apt install -y ffmpeg nvidia-cuda-toolkit nvidia-driver-510

##########################
# Install OpenAI whisper #
##########################
sudo su -
  pip install git+https://github.com/openai/whisper.git  
  pip uninstall torch
  pip cache purge
  pip3 install torch torchvision torchaudio --extra-index-url https://download.pytorch.org/whl/cu116
  pip3 install tensorflow=2.9.2

  echo 'export PATH="/home/ubuntu/.local/bin:$PATH"' >> ~/.bashrc
  source ~/.bashrc
exit
