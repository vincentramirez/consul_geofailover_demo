data "template_file" "dnsmasq_configa" {
  template = file("templates/dnsmasqa.sh")

  vars = {
    private_ipv4 = packet_device.servera.network[1].address
    hostname     = var.hostnamea
    public_ipv4  = packet_device.servera.network[0].address
  }
}

data "template_file" "dnsmasq_configb" {
  template = file("templates/dnsmasqb.sh")

  vars = {
    private_ipv4 = packet_device.serverb.network[1].address
    hostname     = var.hostnameb
    public_ipv4  = packet_device.serverb.network[0].address
  }
}

resource "null_resource" "configure_dnsmasqa" {
  connection {
    type        = "ssh"
    user        = "root"
    private_key = file("~/.ssh/id_rsa")
    host        = packet_device.servera.access_public_ipv4
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum install -y bind-utils",
      "sudo yum makecache",
      "sudo yum install -y dnsmasq",
      "sudo systemctl start dnsmasq",
      "sudo systemctl enable dnsmasq",
    ]
  }

  provisioner "file" {
    content     = data.template_file.dnsmasq_configa.rendered
    destination = "/tmp/dnsmasqa.sh"
  }

  provisioner "file" {
    source      = "templates/10-consul"
    destination = "/etc/dnsmasq.d/10-consul"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo chmod +x /tmp/dnsmasqa.sh",
      "bash /tmp/dnsmasqa.sh",
      "sudo systemctl restart dnsmasq",
    ]
  }
}

resource "null_resource" "configure_dnsmasqb" {
  connection {
    type        = "ssh"
    user        = "root"
    private_key = file("~/.ssh/id_rsa")
    host        = packet_device.serverb.access_public_ipv4
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum install -y bind-utils",
      "sudo yum makecache",
      "sudo yum install -y dnsmasq",
      "sudo systemctl start dnsmasq",
      "sudo systemctl enable dnsmasq",
    ]
  }

  provisioner "file" {
    content     = data.template_file.dnsmasq_configb.rendered
    destination = "/tmp/dnsmasqb.sh"
  }

  provisioner "file" {
    source      = "templates/10-consul"
    destination = "/etc/dnsmasq.d/10-consul"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo chmod +x /tmp/dnsmasqb.sh",
      "bash /tmp/dnsmasqb.sh",
      "sudo systemctl restart dnsmasq",
    ]
  }
}

