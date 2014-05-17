#!/usr/bin/env bash

echo ">>> Installing RethinkDB"

# cf http://www.rethinkdb.com/docs/install/debian/ > need to add support
# of ppa package
wget http://blog.anantshri.info/content/uploads/2010/09/add-apt-repository.sh.txt
sudo mv add-apt-repository.sh.txt /usr/sbin/add-apt-repository
sudo chmod o+x /usr/sbin/add-apt-repository
sudo chown root:root /usr/sbin/add-apt-repository

# Add PPA to server
sudo add-apt-repository -y ppa:rethinkdb/ppa

# Update
sudo apt-get update

# Install
sudo apt-get install rethinkdb -y --force-yes
