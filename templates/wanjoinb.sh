#!/bin/bash

consul join -wan ${public_ipv4a}
consul config write /tmp/resolver.hcl
consul config write /tmp/gateway.hcl
consul members -wan
