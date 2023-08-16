resource "aws_key_pair" "ansible_ec2" {
  key_name   = "ansible_ec2"
  public_key = file("~/.ssh/ansible.pub")

}

resource "aws_instance" "master_node" {
  ami                         = "ami-053b0d53c279acc90"
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.public_1.id
  security_groups             = [aws_security_group.postgresql_sg.id] 
  associate_public_ip_address = true


  key_name = "ansible_ec2"

  tags = {
    Name = "master_node"
  }
}


resource "aws_instance" "slave_node_1" {
  ami                         = "ami-053b0d53c279acc90"
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.public_1.id
  security_groups             = [aws_security_group.postgresql_sg.id] 
  associate_public_ip_address = true


  key_name = "ansible_ec2"

  tags = {
    Name = "slave_node_1"
  }
}

resource "aws_instance" "slave_node_2" {
  ami                         = "ami-053b0d53c279acc90"
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.public_2.id
  security_groups             = [aws_security_group.postgresql_sg.id] 
  associate_public_ip_address = true


  key_name = "ansible_ec2"

  tags = {
    Name = "slave_node_2"
  }
}

