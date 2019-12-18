#!/bin/bash

sudo cat >> /etc/profile <<EOF
PATH=$PATH:/usr/local/go/bin 
EOF

sudo cat >> ~/.bashrc <<EOF
PATH=$PATH:/usr/local/go/bin:/root/go/src/counting-service:/root/go/src/dashboard-service
export GOPATH=$HOME/go
EOF
