# Install Chrome Stable
cd /tmp
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -O chrome.deb
sudo gdebi -n chrome.deb

# add fonts
cd /tmp
wget https://googledrive.com/host/0BwrjfAd1aTwVaTJVSDBXRGRCekE -O fonts.deb
sudo gdebi -n fonts.deb

# Configure desktop
gsettings set org.gnome.desktop.interface document-font-name "Source Sans Pro 12"
gsettings set org.gnome.desktop.interface font-name "Source Sans Pro 12"
gsettings set org.gnome.desktop.interface monospace-font-name "Source Code Pro 12"
gsettings set org.gnome.desktop.media-handling automount-open false
gsettings set org.gnome.desktop.media-handling autorun-never true
gsettings set org.gnome.desktop.privacy old-files-age 60
gsettings set org.gnome.desktop.privacy remove-old-trash-files true
gsettings set org.gnome.desktop.privacy remove-old-temp-files true
gsettings set org.gnome.desktop.wm.preferences titlebar-font "Source Sans Pro Bold 11"
gsettings set org.mate.caja.desktop font "Source Sans Pro 11"
gsettings set org.mate.applications-browser "exec" "google-chrome"
gsettings set org.mate.interface document-font-name "Source Sans Pro 11"
gsettings set org.mate.interface font-name "Source Sans Pro 11"
gsettings set org.mate.interface monospace-font-name "Source Code Pro 12"
gsettings set org.mate.media-handling automount-open false
gsettings set org.mate.media-handling autorun-never true
gsettings set org.mate.peripherals-keyboard numlock-state on
gsettings set org.mate.peripherals-touchpad scroll-method 2
gsettings set org.mate.peripherals-touchpad disable-while-typing true
gsettings set org.mate.dictionary print-font "Source Sans Pro 12"
gsettings set org.mate.Marco.general mouse-button-modifier ""
gsettings set org.mate.Marco.general num-workspaces 1
gsettings set org.mate.Marco.general titlebar-font "Source Sans Pro Bold 11"
gsettings set org.mate.screensaver themes "['screensavers-cosmos-slideshow']"
gsettings set org.mate.screensaver mode "single"
gsettings set com.ubuntu.update-manager first-run false
gsettings set org.mate.session idle-delay 300
gsettings set org.gnome.desktop.session idle-delay 300
gsettings set org.mate.Marco.global-keybindings switch-to-workspace-down ""
gsettings set org.mate.Marco.global-keybindings switch-to-workspace-up ""
gsettings set org.mate.Marco.global-keybindings switch-to-workspace-left ""
gsettings set org.mate.Marco.global-keybindings switch-to-workspace-right ""
gsettings set org.mate.Marco.window-keybindings move-to-workspace-down ""
gsettings set org.mate.Marco.window-keybindings move-to-workspace-up ""
gsettings set org.mate.Marco.window-keybindings move-to-workspace-left ""
gsettings set org.mate.Marco.window-keybindings move-to-workspace-right ""

# Upgrade system
cd ~
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
postgresql-contrib-9.4 \
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
vlc \
jpegoptim

# Set new settings after software is installed
gsettings set org.mate.applications-terminal "exec" "terminator"

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

# Setup zsh
curl -L http://install.ohmyz.sh | sh
mv ~/.zshrc ~/.zshrc-backup
ln -s ~/.dotfiles/zshrc ~/.zshrc
sudo chsh -s /bin/zsh jonathan

# Configure php some
echo 'umask 002' | sudo tee -a /etc/init/php5-fpm.conf
sudo sed -i 's/memory_limit=128M/memory_limit=512M/g' /etc/php5/fpm/php.ini

# setup hosts
echo "127.0.0.1    uw.dev www.uw.dev beanstalk.local" | sudo tee -a /etc/hosts
