###################
# System packages #
###################
sudo apt-get -y update
sudo apt-get install -y wget git make unzip uidmap

################
# Add the user #
################
sudo su -
groupadd exercism

# TODO: Can we avoid giving this sudo
useradd -G sudo -m -s /bin/bash worker
echo "worker    ALL=NOPASSWD: ALL" >/etc/sudoers.d/worker
chmod 440 /etc/sudoers.d/worker

sudo su -l worker

#################
# Initial Setup #
#################
mkdir ~/install
pushd ~/install/

################
# Install Ruby #
################
wget -O ruby-install-0.7.0.tar.gz https://github.com/postmodern/ruby-install/archive/v0.7.0.tar.gz
tar -xzvf ruby-install-0.7.0.tar.gz
pushd ruby-install-0.7.0/
  sudo make install
popd
RUBY_CONFIGURE_OPTS=--disable-install-doc ruby-install ruby 2.6.6

wget -O chruby-0.3.9.tar.gz https://github.com/postmodern/chruby/archive/v0.3.9.tar.gz
tar -xzvf chruby-0.3.9.tar.gz
pushd chruby-0.3.9/
  sudo make install
popd
sed -i '1s/^/source \/usr\/local\/share\/chruby\/chruby.sh\nchruby 2.6.6\n/' ~/.profile
source /usr/local/share/chruby/chruby.sh
chruby ruby-2.6.6

gem install bundler:2.1.4

###############
# Install AWS #
###############
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

#############################
# Setup container tools dir #
#############################
sudo mkdir /opt/container_tools
sudo chown worker:exercism /opt/container_tools

sed -i '1s/^/PATH=\/opt\/container_tools:$PATH\n/' ~/.profile
source ~/.profile

########################
# Install worker tools #
########################

# TODO: Check the tools are owned by the correct 
# user/group and think about permissions
wget https://exercism-ops.s3-eu-west-1.amazonaws.com/binaries/runc -O  /opt/container_tools/runc
chmod 755 /opt/container_tools/runc

#####################
# Install img tools #
#####################

# TODO: Check the tools are owned by the correct 
# user/group and think about permissions
wget https://exercism-ops.s3-eu-west-1.amazonaws.com/binaries/img -O  /opt/container_tools/img
chmod 755 /opt/container_tools/img

########################
# Setup Jobs Directory #
########################
sudo mkdir /opt/jobs/
sudo chown worker:exercism /opt/jobs/

##############################
# Setup containers Directory #
##############################
sudo mkdir /opt/containers/
sudo chown worker:exercism /opt/containers/
CONTAINER_DIR="/opt/containers/ruby-test-runner/releases/8913b2edc9665b8c764fea37423009164bb841d5"
echo $CONTAINER_DIR
mkdir -p $CONTAINER_DIR

########################################
# TEMPORARY: Download Ruby Test Runner #
########################################
pushd $CONTAINER_DIR
  /opt/container_tools/img logout

  aws ecr get-login-password --region eu-west-2 | /opt/container_tools/img login -u AWS --password-stdin 591712695352.dkr.ecr.eu-west-2.amazonaws.com

  /opt/container_tools/img pull -state /tmp/state-img 591712695352.dkr.ecr.eu-west-2.amazonaws.com/ruby-test-runner:8913b2edc9665b8c764fea37423009164bb841d5
  /opt/container_tools/img unpack -state /tmp/state-img 591712695352.dkr.ecr.eu-west-2.amazonaws.com/ruby-test-runner:8913b2edc9665b8c764fea37423009164bb841d5
  chmod -R a-w rootfs
  chmod -R go-rwx rootfs
popd

ln -s $CONTAINER_DIR /opt/containers/ruby-test-runner/current

#############################
# TEMPORARY: Run the worker #
#############################
cd /opt/tooling-invoker
EXERCISM_ENV=production bundle exec bin/worker 
