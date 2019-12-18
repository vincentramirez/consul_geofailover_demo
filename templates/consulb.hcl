{
  "advertise_addr": "${private_ipv4}",
  "advertise_addr_wan": "${access_public_ipv4}",
  "bind_addr": "${access_public_ipv4}",
  "client_addr": "0.0.0.0",
  "datacenter": "${facility}",
  "primary_datacenter": "${facilityprime}",
  "data_dir": "/opt/consul",
  "log_level": "INFO",
  "server": true,
  "ui": true,
  "bootstrap_expect": 1,
  "node_name": "${node_name}",
  "performance": {
    "raft_multiplier": 1
  },
  "addresses": {
    "http": "0.0.0.0"
  },
  "connect": {
    "enabled": true
  },
  "ports": {
    "grpc": 8502
  },
} 

