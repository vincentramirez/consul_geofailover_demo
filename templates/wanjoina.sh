#!/bin/bash

consul join -wan ${public_ipv4b}
consul members -wan
consul config write /tmp/resolver.hcl
consul config write /tmp/gateway.hcl

