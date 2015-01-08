sudo apt-get update
sudo apt-get dist-upgrade -y
sudo apt-add-repository -y ppa:ondrej/php5-5.6
sudo apt-add-repository -y ppa:nginx/stable
cd /etc/apt/sources.list.d
sudo touch pgdg.list
echo "deb http://apt.postgresql.org/pub/repos/apt/ trusty-pgdg main 9.4" | sudo tee -a pgdg.list
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | \
sudo apt-key add -

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
nginx-extras \
postgresql-9.4 \
postgresql-contrib-9.4 \
vim \
curl \
git \
git-flow \
gdebi \
zsh \
beanstalkd \
supervisor \
jpegoptim

# Install composer
cd /tmp
curl -sS https://getcomposer.org/installer | php
sudo mv composer.phar /usr/local/bin/composer

# configure git
git config --global user.name "Jonathan Garbee"
git config --global user.email "jonathan@garbee.me"
git config --global push.default simple
git config --global core.excludesfile '~/.dotfiles/gitignore'

# setup vim
git clone --recursive https://github.com/Garbee/dotvim.git ~/.vim
ln -s ~/.vim/vimrc ~/.vimrc

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

# Setup zsh
curl -L http://install.ohmyz.sh | sh
mv ~/.zshrc ~/.zshrc-backup
ln -s ~/.dotfiles/zshrc ~/.zshrc
sudo chsh -s /bin/zsh jonathan

# Configure php some
echo 'umask 002' | sudo tee -a /etc/init/php5-fpm.conf
sudo sed -i 's/memory_limit=128M/memory_limit=512M/g' /etc/php5/fpm/php.ini
