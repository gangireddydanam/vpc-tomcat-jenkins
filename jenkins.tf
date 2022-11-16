#jenkins with userdata
resource "aws_instance" "my_jenkins" {
  ami           = "ami-017c001a88dd93847"
  instance_type = "t2.micro"
  #vpc_id = aws_vpc.my_vpc.id
  subnet_id              = aws_subnet.my_private[0].id
  vpc_security_group_ids = [aws_security_group.my_jenkins.id]
  key_name               = "ownkey"
  #user_data       = file("jenkins.sh")
  user_data = data.template_file.jenkins.rendered

  tags = {
    Name = "jenkins"
  }
}


data "template_file" "jenkins" {
  template = file("jenkins.sh")
}


