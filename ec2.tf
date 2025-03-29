data "aws_subnet" "default" {
  filter {
    name   = "vpc-id"
    values = [aws_default_vpc.default.id]
  }
}


# key pair (login)

resource "aws_key_pair" "my_key" {
  key_name = "terra-key-ec2"
  public_key = file("terra-key-ec2.pub")
}

# VPC & Security Group

resource "aws_default_vpc" "default" {
  
}

resource "aws_security_group" "my_security_group" {
  name = "auromate-sg"
  description = "this will add a TF generated Security group"
  vpc_id = aws_default_vpc.default.id #interpolation
  #inbound rules
  ingress {
    from_port   = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "SSH Open"
  }
  ingress {
    from_port   = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTP Open"
  }
  #outbound rules
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "all access open outbound"
  }
  tags = {
    name = "automate-sg"
  }
}
#ec2 Instance
resource "aws_instance" "my_instance" {
  key_name = aws_key_pair.my_key.key_name
  vpc_security_group_ids = [aws_security_group.my_security_group.id]
  instance_type = "t2.micro"
  ami = "ami-0e35ddab05955cf57" #ubuntu
  subnet_id = data.aws_subnet.default.id  # Fetching default subnet

  root_block_device {
    volume_size = 15
    volume_type = "gp3"
    }
  tags = {
    Name = "TWS-Junoon-automate"
  }

}

