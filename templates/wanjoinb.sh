#!/bin/bash

consul join -wan ${public_ipv4a}
consul members -wan
consul config write /tmp/resolver.hcl
consul config write /tmp/gateway.hcl
