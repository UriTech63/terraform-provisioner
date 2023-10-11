variable "ami" {
  default = "ami-04cb4ca688797756f"
}


resource "aws_instance" "server" {
  ami           = var.ami
  instance_type = "t2.micro"
  key_name      = "terrafrom-key"


  provisioner "local-exec" {
    command = "echo the ip address is ${self.public_ip} > output.txt"
  }


  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ec2-user"
    private_key = file("~/Downloads/terrafrom-key.pem")
  }


  provisioner "file" {
    source      = "output.txt"
    destination = "/home/ec2-user/provisioner-output.txt"
  }

  provisioner "remote-exec" {

    inline = [
      "sudo yum update -y",
      "mkdir provisioner-test",
      "touch build.txt",
      "cp build.txt provisioner-test/utom.txt"]

      // script = file("script.sh")
  }

  tags = {
    Name = "Provisioner-1"
  }

}
