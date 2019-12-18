#!/bin/bash

sudo yum install -y unzip
cd /tmp
wget https://releases.hashicorp.com/consul/${version}/consul_${version}_linux_amd64.zip
unzip consul_${version}_linux_amd64.zip
sudo chown root:root /tmp/consul
sudo mv /tmp/consul /usr/local/bin/consul

