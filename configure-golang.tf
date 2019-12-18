resource "null_resource" "configure_golanga" {
  connection {
    type        = "ssh"
    user        = "root"
    private_key = file("~/.ssh/id_rsa")
    host        = packet_device.servera.access_public_ipv4
  }

  provisioner "remote-exec" {
    inline = [
      "sudo wget https://dl.google.com/go/go1.13.linux-amd64.tar.gz",
      "sudo tar -C /usr/local -xzf go1.13.linux-amd64.tar.gz",
    ]
  }

  provisioner "file" {
    source      = "templates/path.sh"
    destination = "/tmp/path.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/path.sh",
      "bash /tmp/path.sh",
      "source ~/.bashrc",
      "sudo yum install -y git",
      "go get -v -u github.com/gorilla/mux",
      "go get -v -u github.com/GeertJohan/go.rice",
      "go get -v -u github.com/graarh/golang-socketio",
      "git clone https://github.com/hashicorp/demo-consul-101.git",
      "cp -avr ./demo-consul-101/services/counting-service $HOME/go/src/",
      "cp -avr ./demo-consul-101/services/dashboard-service $HOME/go/src/",
      "cd $HOME/go/src/counting-service",
      "go build",
      "cd $HOME/go/src/dashboard-service",
      "go build",
    ]
  }
}

resource "null_resource" "configure_golangb" {
  connection {
    type        = "ssh"
    user        = "root"
    private_key = file("~/.ssh/id_rsa")
    host        = packet_device.serverb.access_public_ipv4
  }

  provisioner "remote-exec" {
    inline = [
      "sudo wget https://dl.google.com/go/go1.13.linux-amd64.tar.gz",
      "sudo tar -C /usr/local -xzf go1.13.linux-amd64.tar.gz",
    ]
  }

  provisioner "file" {
    source      = "templates/path.sh"
    destination = "/tmp/path.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/path.sh",
      "bash /tmp/path.sh",
      "source ~/.bashrc",
      "sudo yum install -y git",
      "go get -v -u github.com/gorilla/mux",
      "go get -v -u github.com/GeertJohan/go.rice",
      "go get -v -u github.com/graarh/golang-socketio",
      "git clone https://github.com/hashicorp/demo-consul-101.git",
      "cp -avr ./demo-consul-101/services/counting-service $HOME/go/src/",
      "cp -avr ./demo-consul-101/services/dashboard-service $HOME/go/src/",
      "cd $HOME/go/src/counting-service",
      "go build",
      "cd $HOME/go/src/dashboard-service",
      "go build",
    ]
  }
}

