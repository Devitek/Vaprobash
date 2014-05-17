#!/usr/bin/env bash

echo ">>> Installing MariaDB"

[[ -z $1 ]] && { echo "!!! MariaDB root password not set. Check the Vagrant file."; exit 1; }

# default version
MARIADB_VERSION='10.0'

# We'll need some packages
sudo apt-get install python-software-properties

# Import repo key
sudo apt-key adv --recv-keys --keyserver keyserver.ubuntu.com 0xcbcb082a1bb943db

# Add repo for MariaDB
echo deb http://mirrors.linsrv.net/mariadb/repo/10.0/debian wheezy main | sudo tee /etc/apt/sources.list.d/mariadb.list

# Update
sudo apt-get update

# Install MariaDB without password prompt
# Set username to 'root' and password to 'mariadb_root_password' (see Vagrantfile)
sudo debconf-set-selections <<< "maria-db-$MARIADB_VERSION mysql-server/root_password password $1"
sudo debconf-set-selections <<< "maria-db-$MARIADB_VERSION mysql-server/root_password_again password $1"

# Install MariaDB
sudo apt-get install -y mariadb-server
