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
  wget https://gist.githubusercontent.com/ErikSchierboom/9c8f53525e650c15a10c72c0b9c6aefb/raw/23411a7f0104aa0577ef68f5e030ed92fce27a19/transcribe.py
exit
