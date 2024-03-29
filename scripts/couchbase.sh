#!/usr/bin/env bash

echo ">>> Installing Couchbase Server"

# Set some variables
COUCHBASE_EDITION=community
COUCHBASE_VERSION=2.2.0 # Check http://http://www.couchbase.com/download/ for latest version
COUCHBASE_ARCH=x86_64

# We'll need some packages
sudo apt-get install -y --force-yes libc6 libc6-dev libc6-dbg

wget --quiet http://packages.couchbase.com/releases/${COUCHBASE_VERSION}/couchbase-server-${COUCHBASE_EDITION}_${COUCHBASE_VERSION}_${COUCHBASE_ARCH}.deb
sudo dpkg -i couchbase-server-${COUCHBASE_EDITION}_${COUCHBASE_VERSION}_${COUCHBASE_ARCH}.deb
rm couchbase-server-${COUCHBASE_EDITION}_${COUCHBASE_VERSION}_${COUCHBASE_ARCH}.deb

php -v > /dev/null 2>&1
PHP_IS_INSTALLED=$?

dpkg -s php-pear
PEAR_IS_INSTALLED=$?

dpkg -s php5-dev
PHPDEV_IS_INSTALLED=$?

if [ ${PHP_IS_INSTALLED} -eq 0 ]; then

    if [ ${PEAR_IS_INSTALLED} -eq 1 ]; then
        sudo apt-get -y install php-pear
    fi

    if [ ${PHPDEV_IS_INSTALLED} -eq 1 ]; then
        sudo apt-get -y install php5-dev
    fi

    sudo wget --quiet -O/etc/apt/sources.list.d/couchbase.list http://packages.couchbase.com/ubuntu/couchbase-ubuntu1004.list
    wget --quiet -O- http://packages.couchbase.com/ubuntu/couchbase.key | sudo apt-key add -
    sudo apt-get update
    sudo apt-get -y install libcouchbase2-libevent libcouchbase-dev

    sudo pecl install couchbase
    sudo echo "extension=couchbase.so" >> /etc/php5/fpm/php.ini
    sudo echo "extension=couchbase.so" >> /etc/php5/cli/php.ini
    sudo service php5-fpm restart
fi