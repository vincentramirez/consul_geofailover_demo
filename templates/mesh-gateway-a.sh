#!/bin/bash

consul connect envoy -mesh-gateway -register -service "gateway-${facility}" -address "${private_ipv4}:8555" -wan-address "${access_public_ipv4}:8555" -admin-bind 127.0.0.1:19005
