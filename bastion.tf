resource "aws_instance" "bastion" {
  ami           = "ami-017c001a88dd93847"
  instance_type = "t2.micro"
  #vpc_id = aws_vpc.my_vpc.id  
  subnet_id              = aws_subnet.my_public[0].id
  vpc_security_group_ids = [aws_security_group.bastion.id]
  key_name               = "ownkey"

  tags = {
    Name = "bastion"
  }
}