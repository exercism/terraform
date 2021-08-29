###################
# System packages #
###################
sudo apt-get -y update
sudo apt-get install -y wget git make unzip uidmap nfs-common libmysqlclient-dev cmake pkg-config
sudo apt install mysql-client-core-8.0

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

sed -i '1s/^/source \/usr\/local\/share\/chruby\/chruby.sh\nchruby 2.6.6\n/' ~/.bashrc
sed -i '1s/^/EXERCISM_ENV=production\n/' ~/.bashrc
sed -i '1s/^/RAILS_ENV=production\n/' ~/.bashrc
source /usr/local/share/chruby/chruby.sh
chruby ruby-2.6.6

gem install bundler:2.1.4

#########################
# Mount EFS Submissions #
#########################
sudo su -
  FILE_SYSTEM_ID="fs-36ba41c6"
  EFS_MOUNT_POINT="/mnt/efs/submissions"
  mkdir -p "${EFS_MOUNT_POINT}"
  test -f "/sbin/mount.efs" && printf "\n${FILE_SYSTEM_ID}:/ ${EFS_MOUNT_POINT} efs iam,tls,_netdev\n" >> /etc/fstab || printf "\n${FILE_SYSTEM_ID}.efs.eu-west-2.amazonaws.com:/ ${EFS_MOUNT_POINT} nfs4 nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport,_netdev 0 0\n" >> /etc/fstab
  retryCnt=15; waitTime=30; while true; do mount -r -a -t efs,nfs4 defaults; if [ $? = 0 ] || [ $retryCnt -lt 1 ]; then echo File system mounted successfully; break; fi; echo File system not available, retrying to mount.; ((retryCnt--)); sleep $waitTime; done;
  chmod a+w /mnt/efs/submissions
exit

#################
# Mount EFS Git #
#################
sudo su -
  FILE_SYSTEM_ID="fs-37ba41c7"
  EFS_MOUNT_POINT="/mnt/efs/repos"
  mkdir -p "${EFS_MOUNT_POINT}"
  test -f "/sbin/mount.efs" && printf "\n${FILE_SYSTEM_ID}:/ ${EFS_MOUNT_POINT} efs iam,tls,_netdev\n" >> /etc/fstab || printf "\n${FILE_SYSTEM_ID}.efs.eu-west-2.amazonaws.com:/ ${EFS_MOUNT_POINT} nfs4 nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport,_netdev 0 0\n" >> /etc/fstab
  retryCnt=15; waitTime=30; while true; do mount -r -a -t efs,nfs4 defaults; if [ $? = 0 ] || [ $retryCnt -lt 1 ]; then echo File system mounted successfully; break; fi; echo File system not available, retrying to mount.; ((retryCnt--)); sleep $waitTime; done;
  chmod a+w /mnt/efs/repos
exit

###################
# Install website #
###################
sudo su -
  DIR="/opt/website"
  mkdir $DIR

  # TODO: Pull this from AWS's Git thing
  cd $DIR/..
  git clone https://github.com/exercism/v3-website.git website

  chown -R ubuntu:ubuntu $DIR
  chmod 700 $DIR
exit

cd /opt/website
bundle config set deployment 'true'
bundle config set without 'development test'
bundle install

