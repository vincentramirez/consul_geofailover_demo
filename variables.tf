variable "auth_token" {
  description = "Packet org API key w/ R/W privileges"
}

variable "project_name" {
  description = "UUID of the newly created Packet project to deploy resources into"
}

variable "hostnamea" {
  description = "server host name"
}

variable "hostnameb" {
  description = "server host name"
}

variable "facilitya" {
  description = "Packet datacenter location"
}

variable "facilityb" {
  description = "Packet datacetner location"
}

variable "consul-version" {
  description = "version of HashiCorp Consul, example: 1.6.2"
  default     = "1.6.2"
}

