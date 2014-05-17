#!/usr/bin/env bash

# The usual updates
sudo apt-get update

# We'll need some packages
sudo apt-get install mysql-client unixodbc libpq5

wget --quiet http://sphinxsearch.com/files/sphinxsearch_2.1.8-release-1~wheezy_amd64.deb
sudo dpkg -i sphinxsearch_2.1.8-release-1~wheezy_amd64.deb
rm elasticsearch-$ELASTICSEARCH_VERSION.deb

# Create a base conf file (Altho we can't make any assumptions about its use)
