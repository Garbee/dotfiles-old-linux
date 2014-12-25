sudo apt-get update
sudo apt-get dist-upgrade -y

# add extra repositories
sudo apt-add-repository -y ppa:ondrej/php5-5.6
sudo apt-add-repository -y ppa:webupd8team/sublime-text-2
sudo apt-add-repository -y ppa:webupd8team/java
sudo apt-add-repository -y ppa:nginx/stable
cd /etc/apt/sources.list.d
sudo touch pgdg.list
echo "deb http://apt.postgresql.org/pub/repos/apt/ trusty-pgdg main 9.4" | sudo tee -a pgdg.list
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | \
sudo apt-key add -

# accept terms for auto install
echo debconf shared/accepted-oracle-license-v1-1 select true | \
sudo debconf-set-selections
echo debconf shared/accepted-oracle-license-v1-1 seen true | \
sudo debconf-set-selections
echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | \
sudo debconf-set-selections

sudo apt-get update

sudo apt-get install -y php5-cli \
php5-curl \
php5-fpm \
php5-gd \
php5-imagick \
php5-json \
php5-mcrypt \
php5-pgsql \
php5-readline \
ubuntu-restricted-extras \
nginx-extras \
postgresql-9.4 \
oracle-java8-installer \
vim \
curl \
git \
git-flow \
terminator \
gdebi \
zsh \
shutter \
kazam \
gimp \
gimp-plugin-registry \
inkscape \
beanstalkd \
terminator \
sublime-text \
supervisor \
pgadmin3 \
audacity \
vlc

# Install composer
cd /tmp
curl -sS https://getcomposer.org/installer | php
sudo mv composer.phar /usr/local/bin/composer

# install postgres
sudo -u postgres psql -c "CREATE ROLE jonathan WITH SUPERUSER LOGIN"
sudo -u postgres psql -c "ALTER ROLE postgres WITH PASSWORD 'postgres'"
sudo -u postgres psql -c "CREATE DATABASE homestead"
sudo -u postgres psql -c "CREATE USER homestead WITH PASSWORD 'homestead'"
sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE homestead TO homestead"

# configure git
git config --global user.name "Jonathan Garbee"
git config --global user.email "jonathan@garbee.me"
git config --global push.default simple
git config --global core.excludesfile '~/.dotfiles/gitignore'

# setup vim
git clone --recursive https://github.com/Garbee/dotvim.git ~/.vim
ln -s ~/.vim/vimrc ~/.vimrc

# add fonts
cd /tmp
wget https://googledrive.com/host/0BwrjfAd1aTwVaTJVSDBXRGRCekE -O fonts.deb
sudo gdebi -n fonts.deb

# Install Chrome Stable
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -O chrome.deb
sudo gdebi -n chrome.deb

# Add my user to www-data
sudo usermod -a -G www-data jonathan

# setup srv area
sudo mkdir -p /srv/web/etc
sudo chown -R www-data:www-data /srv/web
sudo chmod g+s /srv/web
sudo find /srv -type d -exec chmod 775 {} ";"
sudo find /srv -type f -exec chmod 664 {} ";"

# setup ssh config
cd ~
mkdir .ssh
cd .ssh
ln -s ~/.dotfiles/ssh/config config