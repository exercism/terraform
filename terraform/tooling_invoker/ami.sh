###################
# System packages #
###################
sudo apt-get -y update
sudo apt-get install -y wget git make unzip uidmap nfs-common cmake pkg-config

#########################
# Mount EFS Submissions #
#########################
sudo su -
  # TODO: Add correct fs-xxxx filesystem
  FILE_SYSTEM_ID="fs-11f0c5e0"
  EFS_MOUNT_POINT="/mnt/efs/submissions"
  mkdir -p "${EFS_MOUNT_POINT}"
  test -f "/sbin/mount.efs" && printf "\n${FILE_SYSTEM_ID}:/ ${EFS_MOUNT_POINT} efs iam,tls,_netdev\n" >> /etc/fstab || printf "\n${FILE_SYSTEM_ID}.efs.eu-west-2.amazonaws.com:/ ${EFS_MOUNT_POINT} nfs4 nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport,_netdev,ro 0 0\n" >> /etc/fstab
  retryCnt=15; waitTime=30; while true; do mount -r -a -t efs,nfs4 defaults; if [ $? = 0 ] || [ $retryCnt -lt 1 ]; then echo File system mounted successfully; break; fi; echo File system not available, retrying to mount.; ((retryCnt--)); sleep $waitTime; done;
exit

#################
# Mount EFS Git #
#################
sudo su -
  FILE_SYSTEM_ID="fs-064a13f7"
  EFS_MOUNT_POINT="/mnt/efs/repos"
  mkdir -p "${EFS_MOUNT_POINT}"
  test -f "/sbin/mount.efs" && printf "\n${FILE_SYSTEM_ID}:/ ${EFS_MOUNT_POINT} efs iam,tls,_netdev\n" >> /etc/fstab || printf "\n${FILE_SYSTEM_ID}.efs.eu-west-2.amazonaws.com:/ ${EFS_MOUNT_POINT} nfs4 nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport,_netdev 0 0\n" >> /etc/fstab
  retryCnt=15; waitTime=30; while true; do mount -r -a -t efs,nfs4 defaults; if [ $? = 0 ] || [ $retryCnt -lt 1 ]; then echo File system mounted successfully; break; fi; echo File system not available, retrying to mount.; ((retryCnt--)); sleep $waitTime; done;
exit

#######################
# Add the worker user #
#######################
sudo groupadd exercism
sudo useradd -g exercism -m -s /bin/bash exercism

###################################
# Install Docker as non-root user #
###################################
sudo su exercism
  mkdir ~/install
  cd ~/install/

  curl -fsSL https://get.docker.com/rootless | sh

  sed -i '1s/^/export XDG_RUNTIME_DIR=\/home\/exercism\/.docker\/run\n/' ~/.bashrc
  sed -i '1s/^/export PATH=\/home\/exercism\/bin:$PATH\n/' ~/.bashrc
  sed -i '1s/^/export DOCKER_HOST=unix:\/\/\/home\/exercism\/.docker\/run\/docker.sock\n/' ~/.bashrc
exit

############################
# Setup Systemd for Docker #
############################
sudo su -
  cat >/etc/systemd/system/docker.service << EOM
[Unit]
Description=Docker Application Container Engine (Rootless)
Documentation=https://docs.docker.com

[Service]
Environment=PATH=/home/exercism/bin/:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
Environment=XDG_RUNTIME_DIR=/home/exercism/.docker/run
Environment=DOCKER_HOST=unix:///home/exercism/.docker/run/docker.sock
ExecStartPre=rm -rf \${XDG_RUNTIME_DIR}/*
ExecStart=/home/exercism/bin/dockerd-rootless.sh --experimental
ExecReload=/bin/kill -s HUP \$MAINPID
TimeoutSec=0
RestartSec=2
Restart=always
StartLimitBurst=3
StartLimitInterval=60s
LimitNOFILE=infinity########
LimitNPROC=infinity
LimitCORE=infinity
TasksMax=infinity
Delegate=yes
Type=simple
User=exercism
Group=exercism

[Install]
WantedBy=default.target
EOM

  chmod 400 /etc/systemd/system/docker.service
  systemctl daemon-reload
  systemctl enable docker.service

  systemctl start docker
  systemctl enable docker
exit

################
# Install Ruby #
################
sudo su -
  mkdir ~/install
  cd ~/install

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
exit

sudo su exercism
  sed -i '1s/^/source \/usr\/local\/share\/chruby\/chruby.sh\nchruby 2.6.6\n/' ~/.bashrc
  sed -i '1s/^/EXERCISM_ENV=production\n/' ~/.bashrc
  source /usr/local/share/chruby/chruby.sh
  chruby ruby-2.6.6

  gem install bundler:2.1.4
exit

###############
# Install AWS #
###############
sudo su -
  curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
  unzip awscliv2.zip
  sudo ./aws/install
exit

########################
# Setup Jobs Directory #
########################
sudo su -
  DIR="/opt/jobs"
  mkdir $DIR
  chown exercism:exercism $DIR
  chmod 700 $DIR
exit

###########################
# Install tooling invoker #
###########################
sudo su -
  DIR="/opt/tooling-invoker"
  mkdir $DIR

  # TODO: Pull this from AWS'Git thing
  cd $DIR/..
  git clone https://github.com/exercism/tooling-invoker.git

  chown -R exercism:exercism $DIR
  chmod 700 $DIR

  su exercism
    cd /opt/tooling-invoker
    bundle install
  exit
exit

###########################
# Install tooling manager #
###########################
sudo su -
  DIR="/opt/tooling-manager"
  mkdir $DIR

  # TODO: Pull this from AWS's Git thing
  cd $DIR/..
  git clone https://github.com/exercism/tooling-manager.git

  chown -R exercism:exercism $DIR
  chmod 700 $DIR

  su exercism
    cd /opt/tooling-manager
    bundle install
  exit
exit

#####################################
# Setup Systemd for tooling manager #
#####################################
sudo su -
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
User=exercism
WorkingDirectory=/opt/tooling-manager
ExecStartPre=/usr/local/bin/chruby-exec ruby-2.6.6 -- ./bin/update
ExecStart=/usr/local/bin/chruby-exec ruby-2.6.6 -- bundle exec ruby bin/start
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
  systemctl enable exercism_manager.service
exit

#####################################
# Setup Systemd for tooling worker #
#####################################
sudo su -
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
User=exercism
WorkingDirectory=/opt/tooling-invoker
ExecStartPre=/usr/local/bin/chruby-exec ruby-2.6.6 -- ./bin/update
ExecStart=/usr/local/bin/chruby-exec ruby-2.6.6 -- bundle exec ruby bin/start
SyslogIdentifier=tooling-invoker

[Install]
WantedBy=multi-user.target
EOM
chmod 544 /etc/systemd/system/exercism_invoker.service

mkdir /etc/systemd/system/exercism_invoker.service.d
cat >/etc/systemd/system/exercism_invoker.service.d/env.conf << EOM
[Service]
Environment="EXERCISM_ENV=production"
Environment="JOB_POLLING_DELAY=0.1"
EOM
  chmod 544 /etc/systemd/system/exercism_invoker.service.d/env.conf
  systemctl enable exercism_invoker.service
exit

#########################################
## TEMPORARY: Download Ruby Test Runner #
#########################################

docker logout
aws ecr get-login-password --region eu-west-2 | docker login -u AWS --password-stdin 591712695352.dkr.ecr.eu-west-2.amazonaws.com

docker pull exercism/elixir-test-runner:production

#ln -s $CONTAINER_DIR /opt/containers/ruby-test-runner/current

##############################
## TEMPORARY: Run the worker #
##############################
#su -l exercism
#  cd /opt/tooling-invoker
#  git fetch && git reset --hard origin/master && EXERCISM_ENV=production bundle exec bin/worker
#exit

##############################
## TEMPORARY: Run the manager #
##############################
#su -l exercism
#  cd /opt/tooling-manager
#  git fetch && git reset --hard origin/main && EXERCISM_ENV=production bundle exec bin/manager
#exit

