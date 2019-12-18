provider "packet" {
  auth_token = var.auth_token
}

resource "packet_project" "demo-project" {
  name           = var.project_name
}

resource "packet_device" "servera" {
  hostname         = var.hostnamea
  plan             = "t1.small.x86"
  facilities       = [var.facilitya]
  operating_system = "centos_7"
  billing_cycle    = "hourly"
  project_id       = packet_project.demo-project.id
  ip_address_types = ["private_ipv4", "public_ipv4"]
}


resource "packet_device" "serverb" {
  hostname         = var.hostnameb
  plan             = "t1.small.x86"
  facilities       = [var.facilityb]
  operating_system = "centos_7"
  billing_cycle    = "hourly"
  project_id       = packet_project.demo-project.id
  ip_address_types = ["private_ipv4", "public_ipv4"]
}

