output "consul_servera_public-IP" {
  value = packet_device.servera.access_public_ipv4
}

output "consul_serverb_public-IP" {
  value = packet_device.serverb.access_public_ipv4
}

