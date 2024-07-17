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

  wget -O ruby-install-0.8.3.tar.gz https://github.com/postmodern/ruby-install/archive/v0.8.3.tar.gz
  tar -xzvf ruby-install-0.8.3.tar.gz
  pushd ruby-install-0.8.3/
    make install
  popd
  RUBY_CONFIGURE_OPTS=--disable-install-doc ruby-install ruby-3.3.0

  wget -O chruby-0.3.9.tar.gz https://github.com/postmodern/chruby/archive/v0.3.9.tar.gz
  tar -xzvf chruby-0.3.9.tar.gz
  pushd chruby-0.3.9/
    make install
  popd
exit

sed -i '1s/^/source \/usr\/local\/share\/chruby\/chruby.sh\nchruby 3.3.0\n/' ~/.bashrc
sed -i '1s/^/EXERCISM_ENV=production\n/' ~/.bashrc
sed -i '1s/^/RAILS_ENV=production\n/' ~/.bashrc
source /usr/local/share/chruby/chruby.sh
chruby ruby-3.3.0

gem install bundler:2.3.7

###################
# Install website #
###################
sudo su -
  DIR="/opt/website"
  mkdir $DIR

  # TODO: Pull this from AWS's Git thing
  cd $DIR/..
  git clone https://github.com/exercism/website.git website

  chown -R ubuntu:ubuntu $DIR
  chmod 700 $DIR
exit

cd /opt/website
bundle config set deployment 'true'
bundle config set without 'development test'
gem install propshaft
bundle install

#################
# Setup aliases #
#################
echo "alias rails-c='cd /opt/website/ && git pull && RAILS_LOG_LEVEL=debug bundle exec rails c -e production -- --noreadline'" >> ~/.bash_aliases
echo "alias rails-db='cd /opt/website/ && git pull && RAILS_LOG_LEVEL=debug bundle exec rails dbconsole -p -e production'" >> ~/.bash_aliases 
echo "alias grpc-cleanup='cd /opt/website && grpc_path=$(bundle show --paths grpc)/src/ruby/ext/grpc && make -C $grpc_path clean && rm -rf $grpc_path/{libs,objs}'" >> ~/.bash_aliases
source ~/.bashrc

#################
# Setup crontab #
#################
echo '0 0 * * * grpc-cleanup' | sudo crontab -u root -

