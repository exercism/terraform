#####################
# Run setup as root #
#####################
sudo su -

###################
# System packages #
###################
apt-get -y update
apt-get install -y wget git make unzip uidmap

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
  make install
popd
RUBY_CONFIGURE_OPTS=--disable-install-doc ruby-install ruby 2.6.6

wget -O chruby-0.3.9.tar.gz https://github.com/postmodern/chruby/archive/v0.3.9.tar.gz
tar -xzvf chruby-0.3.9.tar.gz
pushd chruby-0.3.9/
  make install
popd
sed -i '1s/^/source \/usr\/local\/share\/chruby\/chruby.sh\nchruby 2.6.6\n/' ~/.bashrc
source /usr/local/share/chruby/chruby.sh
chruby ruby-2.6.6

gem install bundler:2.1.4

###############
# Install AWS #
###############
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
./aws/install

#######################
# Add the worker user #
#######################
groupadd exercism

useradd -g exercism -m -s /bin/bash exercism_worker
echo "exercism_worker    ALL=NOPASSWD: ALL" >/etc/sudoers.d/exercism_worker
su exercism_worker
  sed -i '1s/^/source \/usr\/local\/share\/chruby\/chruby.sh\nchruby 2.6.6\n/' ~/.bashrc
  sed -i '1s/^/PATH=\/opt\/container_tools:$PATH\n/' ~/.bashrc
  sed -i '1s/^/EXERCISM_ENV=production\n/' ~/.bashrc
  source /usr/local/share/chruby/chruby.sh
  chruby ruby-2.6.6
exit

########################
# Add the manager user #
########################
useradd -g exercism -m -s /bin/bash exercism_manager
echo "exercism_manager    ALL=NOPASSWD: ALL" >/etc/sudoers.d/exercism_manager
su exercism_manager
  sed -i '1s/^/source \/usr\/local\/share\/chruby\/chruby.sh\nchruby 2.6.6\n/' ~/.bashrc
  sed -i '1s/^/PATH=\/opt\/container_tools:$PATH\n/' ~/.bashrc
  source /usr/local/share/chruby/chruby.sh
  chruby ruby-2.6.6
exit

#############################
# Setup container tools dir #
#############################
DIR="/opt/container_tools"
mkdir $DIR
chown exercism_manager:exercism $DIR
chmod 770 $DIR

########################
# Install worker tools #
########################
RUNC="/opt/container_tools/runc"
wget https://exercism-ops.s3-eu-west-1.amazonaws.com/binaries/runc -O $RUNC
chown exercism_worker:exercism $RUNC
chmod 500 $RUNC
unset RUNC

#####################
# Install img tools #
#####################
IMG="/opt/container_tools/img"
wget https://exercism-ops.s3-eu-west-1.amazonaws.com/binaries/img -O $IMG
chown exercism_manager:exercism $IMG
chmod 500 $IMG
unset IMG

########################
# Setup Jobs Directory #
########################
DIR="/opt/jobs"
mkdir $DIR
chown exercism_worker:exercism $DIR
chmod 700 $DIR
unset DIR

##############################
# Setup containers directory #
##############################
DIR="/opt/containers"
mkdir $DIR
chown exercism_manager:exercism $DIR
chmod 750 $DIR
unset DIR

###########################
# Install tooling invoker #
###########################
DIR="/opt/tooling-invoker"
mkdir $DIR

# TODO: Pull this from AWS'Git thing
cd $DIR/..
git clone https://github.com/exercism/tooling-invoker.git
su -l exercism_worker
  pushd /opt/tooling-invoker
    bundle install
  popd
exit

chown -R exercism_worker:exercism $DIR
chmod 700 $DIR

unset DIR

###########################
# Install tooling manager #
###########################

DIR="/opt/tooling-manager"
mkdir $DIR

# TODO: Pull this from AWS's Git thing
cd $DIR/..
git clone https://github.com/exercism/tooling-manager.git
su -l exercism_manager
  pushd /opt/tooling-manager
    bundle install
  popd
exit

chown -R exercism_manager:exercism $DIR
chmod 700 $DIR

unset DIR

#####################################
# Setup Systemd for tooling manager #
#####################################
cat >/etc/systemd/system/exercism_manager.service << EOM
[Unit]
Description=Exercism Tooling Manager
After=network.target

# Keep restarting the service forever
StartLimitIntervalSec=0
StartLimitBurst=0

[Service]
Restart=always

# Sleep for 30s before restarting the service
RestartSec=30
User=exercism_manager
ExecStart=/usr/local/bin/chruby-exec ruby-2.6.6 -- ruby /opt/tooling-manager/bin/start
SyslogIdentifier=tooling-manager

[Install]
WantedBy=multi-user.target
EOM
chmod 544 /etc/systemd/system/exercism_manager.service

mkdir /etc/systemd/system/exercism_manager.service.d
cat >/etc/systemd/system/exercism_manager.service.d/env.conf << EOM
[Service]
Environment="EXERCISM_ENV=production"
EOM
chmod 544 /etc/systemd/system/exercism_manager.service.d/env.conf

#####################################
# Setup Systemd for tooling worker #
#####################################
cat >/etc/systemd/system/exercism_invoker.service << EOM
[Unit]
Description=Exercism Tooling Invoker Worker
After=network.target

# Keep restarting the service forever
StartLimitIntervalSec=0
StartLimitBurst=0

[Service]
Restart=always

# Sleep for 30s before restarting the service
RestartSec=30
User=exercism_worker
ExecStart=/usr/local/bin/chruby-exec ruby-2.6.6 -- ruby /opt/tooling-invoker/bin/start
SyslogIdentifier=tooling-invoker

[Install]
WantedBy=multi-user.target
EOM
chmod 544 /etc/systemd/system/exercism_invoker.service

mkdir /etc/systemd/system/exercism_invoker.service.d
cat >/etc/systemd/system/exercism_invoker.service.d/env.conf << EOM
[Service]
Environment="EXERCISM_ENV=production"
EOM
chmod 544 /etc/systemd/system/exercism_invoker.service.d/env.conf


#########################################
## TEMPORARY: Download Ruby Test Runner #
#########################################

#CONTAINER_DIR="/opt/containers/ruby-test-runner/releases/latest"
#echo $CONTAINER_DIR
#mkdir -p $CONTAINER_DIR

#pushd $CONTAINER_DIR
#  /opt/container_tools/img logout

#  aws ecr get-login-password --region eu-west-2 | /opt/container_tools/img login -u AWS --password-stdin 591712695352.dkr.ecr.eu-west-2.amazonaws.com

#  /opt/container_tools/img pull -state /tmp/state-img 591712695352.dkr.ecr.eu-west-2.amazonaws.com/ruby-test-runner:latest
#  /opt/container_tools/img unpack -state /tmp/state-img 591712695352.dkr.ecr.eu-west-2.amazonaws.com/ruby-test-runner:latest
#  chmod -R a-w rootfs
#  chmod -R go-rwx rootfs
#popd

#ln -s $CONTAINER_DIR /opt/containers/ruby-test-runner/current

##############################
## TEMPORARY: Run the worker #
##############################
#su -l exercism_worker
#  cd /opt/tooling-invoker
#  git fetch && git reset --hard origin/master && EXERCISM_ENV=production bundle exec bin/worker
#exit

##############################
## TEMPORARY: Run the manager #
##############################
#su -l exercism_manager
#  cd /opt/tooling-manager
#  git fetch && git reset --hard origin/main && EXERCISM_ENV=production bundle exec bin/manager
#exit

