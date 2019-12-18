#!/bin/bash

sudo cat >> /etc/dnsmasq.conf <<EOF
listen-address=::1,127.0.0.1,${private_ipv4}
EOF

sudo touch /etc/dnsmasq.d/10-consul
sudo cat > /etc/dnsmasq.d/10-consul <<EOF
server=/consul/127.0.0.1#8600
no-poll
server=8.8.8.8
server=8.8.4.4
cache-size=0
EOF

sudo cat >> /etc/hosts <<EOF
# For local resolution
${private_ipv4}  ${hostname}.node.consul
EOF

sudo cat > /etc/resolv.conf <<EOF
nameserver  127.0.0.1
EOF
sudo chattr +i /etc/resolv.conf


