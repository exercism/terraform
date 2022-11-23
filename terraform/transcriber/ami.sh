###################
# System packages #
###################
sudo apt update
sudo apt install -y ffmpeg

##################
# Update profile #
##################
echo 'export PATH="/home/ubuntu/.local/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc

###########################
# Install python packages #
###########################
sudo su -
  python3 -m pip install --upgrade pip  
  pip install git+https://github.com/openai/whisper.git  
  pip uninstall torch
  pip cache purge
  pip install tensort  
  pip install torch torchvision torchaudio torchtext --extra-index-url https://download.pytorch.org/whl/cu116
  pip install tensorflow==2.9.2
  pip install pyannote.audio
  pip install speechbrain
exit
