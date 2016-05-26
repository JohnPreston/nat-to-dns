#!/usr/bin/env bash

#
# Installs all the requirements on the machine - requires EL 6/7
#

# Install EPEL
sudo yum install http://dl.fedoraproject.org/pub/epel/epel-release-latest-6.noarch.rpm -y || sudo yum install epel-release -y

# Install Ansible
sudo yum install ansible -y

# Install pip
sudo yum install pip
# Upgrade pip
sudo pip install pip --upgrade
# Install awscli
sudo pip install awscli
# Install s3cmd
git clone https://github.com/eucalyptus/s3cmd /var/tmp/s3cmd
cd /var/tmp/s3cmd
sudo python setup.py install
cd
