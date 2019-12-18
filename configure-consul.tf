data "template_file" "consul_download" {
  template = file("templates/consul-download.sh")

  vars = {
    version = var.consul-version
  }
}

data "template_file" "consula_hcl" {
  template = file("templates/consula.hcl")

  vars = {
    facility           = var.facilitya
    facilityprime      = var.facilitya
    access_public_ipv4 = packet_device.servera.network[0].address
    private_ipv4       = packet_device.servera.network[1].address
    node_name          = var.hostnamea
  }
}

data "template_file" "consulb_hcl" {
  template = file("templates/consulb.hcl")

  vars = {
    facility           = var.facilityb
    facilityprime      = var.facilitya
    access_public_ipv4 = packet_device.serverb.network[0].address
    private_ipv4       = packet_device.serverb.network[1].address
    node_name          = var.hostnameb
  }
}

data "template_file" "consul-wan-join-a" {
  template = file("templates/wanjoina.sh")

  vars = {
    facilityb    = var.facilityb
    public_ipv4a = packet_device.servera.network[0].address
    public_ipv4b = packet_device.serverb.network[0].address
  }
}

data "template_file" "consul-wan-join-b" {
  template = file("templates/wanjoinb.sh")

  vars = {
    facilitya    = var.facilitya
    public_ipv4a = packet_device.servera.network[0].address
    public_ipv4b = packet_device.serverb.network[0].address
  }
}

data "template_file" "mesh-gateway-a" {
  template = file("templates/mesh-gateway-a.sh")

  vars = {
    facility    = var.facilitya
    private_ipv4       = packet_device.servera.network[1].address
    access_public_ipv4 = packet_device.servera.network[0].address  
  }
}

data "template_file" "mesh-gateway-b" {
  template = file("templates/mesh-gateway-b.sh")

  vars = {
    facility    = var.facilityb
    private_ipv4       = packet_device.serverb.network[1].address
    access_public_ipv4 = packet_device.serverb.network[0].address
  }
}

data "template_file" "resolver-a" {
  template = file("templates/resolvera.hcl")

  vars = {
    facility    = var.facilityb
  }
}

data "template_file" "resolver-b" {
  template = file("templates/resolverb.hcl")

  vars = {
    facility    = var.facilitya
  }
}



# install & configure Consul in first datacenter

resource "null_resource" "configure_consula" {
  connection {
    type        = "ssh"
    user        = "root"
    private_key = file("~/.ssh/id_rsa")
    host        = packet_device.servera.access_public_ipv4
  }

  provisioner "file" {
    content     = data.template_file.consul_download.rendered
    destination = "/tmp/consul-download.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum install -y yum-utils",
      "sudo chown +x /tmp/consul-download.sh",
      "bash /tmp/consul-download.sh",
      "consul -autocomplete-install",
      "complete -C /usr/local/bin/consul consul",
      "sudo useradd --system --home /etc/consul.d --shell /bin/false consul",
      "sudo mkdir --parents /opt/consul",
      "sudo chown --recursive consul:consul /opt/consul",
      "sudo mkdir --parents /etc/consul.d",
      "sudo yum-config-manager --add-repo https://getenvoy.io/linux/centos/tetrate-getenvoy.repo",
      "sudo yum install -y getenvoy-envoy",
      "envoy --version",
    ]
  }

  provisioner "file" {
    source      = "templates/consul.service"
    destination = "/etc/systemd/system/consul.service"
  }
  provisioner "file" {
    content     = data.template_file.consula_hcl.rendered
    destination = "/etc/consul.d/consul.hcl"
  }

  provisioner "file" {
    source      = "templates/counting-connect.json"
    destination = "/etc/consul.d/counting-connect.json"
  }

  provisioner "file" {
    source      = "templates/dashboard-connect.json"
    destination = "/etc/consul.d/dashboard-connect.json"
  }

  provisioner "file" {
    content     = data.template_file.consul-wan-join-a.rendered
    destination = "/tmp/wanjoin.sh"
  }

  provisioner "file" {
    content     = data.template_file.mesh-gateway-a.rendered
    destination = "/tmp/mesh-gateway.sh"
  }

  provisioner "file" {
    content     = data.template_file.resolver-a.rendered
    destination = "/tmp/resolver.hcl"
  }

  provisioner "file" {
    source      = "templates/gateway.hcl"
    destination = "/tmp/gateway.hcl"
  }


  provisioner "remote-exec" {
    inline = [
      "sudo chown --recursive consul:consul /etc/consul.d",
      "sudo chmod 640 /etc/consul.d/consul.hcl",
      "sudo chown --recursive consul:consul /etc/consul.d",
      "sudo chmod +x /tmp/wanjoina.sh",
      "sudo chmod +x /tmp/mesh-gateway.sh",
      "sudo systemctl start consul",
      "sudo systemctl enable consul",
      "sudo systemctl status consul",
    ]
  }
}

# insall & configure Consul in second datacenter

resource "null_resource" "configure_consulb" {
  connection {
    type        = "ssh"
    user        = "root"
    private_key = file("~/.ssh/id_rsa")
    host        = packet_device.serverb.access_public_ipv4
  }

  provisioner "file" {
    content     = data.template_file.consul_download.rendered
    destination = "/tmp/consul-download.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum install -y yum-utils",
      "sudo chown +x /tmp/consul-download.sh",
      "bash /tmp/consul-download.sh",
      "consul -autocomplete-install",
      "complete -C /usr/local/bin/consul consul",
      "sudo useradd --system --home /etc/consul.d --shell /bin/false consul",
      "sudo mkdir --parents /opt/consul",
      "sudo chown --recursive consul:consul /opt/consul",
      "sudo mkdir --parents /etc/consul.d",
      "sudo yum-config-manager --add-repo https://getenvoy.io/linux/centos/tetrate-getenvoy.repo",
      "sudo yum install -y getenvoy-envoy",
      "envoy --version",
   ]
  }

  provisioner "file" {
    source      = "templates/consul.service"
    destination = "/etc/systemd/system/consul.service"
  }
  provisioner "file" {
    content     = data.template_file.consulb_hcl.rendered
    destination = "/etc/consul.d/consul.hcl"
  }

  provisioner "file" {
    source      = "templates/counting-connect.json"
    destination = "/etc/consul.d/counting-connect.json"
  }

  provisioner "file" {
    source      = "templates/dashboard-connect.json"
    destination = "/etc/consul.d/dashboard-connect.json"
  }
  provisioner "file" {
    content     = data.template_file.consul-wan-join-b.rendered
    destination = "/tmp/wanjoin.sh"
  }

  provisioner "file" {
    content     = data.template_file.mesh-gateway-b.rendered
    destination = "/tmp/mesh-gateway.sh"
  }

  provisioner "file" {
    content     = data.template_file.resolver-b.rendered
    destination = "/tmp/resolver.hcl"
  }

  provisioner "file" {
    source      = "templates/gateway.hcl"
    destination = "/tmp/gateway.hcl"
  }


  provisioner "remote-exec" {
    inline = [
      "sudo chown --recursive consul:consul /etc/consul.d",
      "sudo chmod 640 /etc/consul.d/consul.hcl",
      "sudo chown --recursive consul:consul /etc/consul.d",
      "sudo chmod +x /tmp/wanjoinb.sh",
      "sudo chmod +x /tmp/mesh-gateway.sh",
      "sudo systemctl start consul",
      "sudo systemctl enable consul",
      "sudo systemctl status consul",
    ]
  }
}
