#!/usr/bin/env bash

# Test if PHP is installed
php -v > /dev/null 2>&1
PHP_IS_INSTALLED=$?

# Test if HHVM is installed
hhvm --version > /dev/null 2>&1
HHVM_IS_INSTALLED=$?

# If HHVM is installed, assume PHP is *not*
[[ $HHVM_IS_INSTALLED -eq 0 ]] && { PHP_IS_INSTALLED=-1; }

echo ">>> Installing Apache Server"

[[ -z $1 ]] && { echo "!!! IP address not set. Check the Vagrant file."; exit 1; }

if [[ -z $2 ]]; then
    public_folder="/vagrant"
else
    public_folder="$2"
fi

if [[ -z $4 ]]; then
    github_url="https://raw.githubusercontent.com/fideloper/Vaprobash/master"
else
    github_url="$4"
fi

# Update Again
sudo apt-get update

# Install Apache
sudo apt-get install -y --force-yes apache2

echo ">>> Configuring Apache"


# Apache Config
sudo a2enmod rewrite actions ssl
curl --silent -L $github_url/helpers/vhost.sh > vhost
sudo chmod guo+x vhost
sudo mv vhost /usr/local/bin

# Create a virtualhost to start, with SSL certificate
sudo vhost -s $1.xip.io -d $public_folder -p /etc/ssl/xip.io -c xip.io -a $3
sudo a2dissite 000-default

# If PHP is installed or HHVM is installed, proxy PHP requests to it
if [[ $PHP_IS_INSTALLED -eq 0 || $HHVM_IS_INSTALLED -eq 0 ]]; then

    # PHP Config for Apache
    sudo a2enmod proxy_fcgi

    # Add ProxyPassMatch to pass to php in document root
    sudo sed -i "s@#ProxyPassMatch.*@ProxyPassMatch ^/(.*\\\.php(/.*)?)$ fcgi://127.0.0.1:9000"$public_folder"/\$1@" /etc/apache2/sites-available/$1.xip.io.conf

fi

sudo service apache2 restart
