provider "aws" {
  region     = "us-east-1"
  access_key = ""
  secret_key = ""
  token      = ""
}

data "aws_vpc" "default" {
  default = true
}

resource "aws_security_group" "LOG8415E_TP3_Security_Group" {
  vpc_id      = data.aws_vpc.default.id
  name        = "LOG8415E_TP3_Security_Group"
  description = "Security group for TP3"

  #SSH use
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  #HTTP use
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  #HTTPS use
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    from_port        = 1186
    to_port          = 1186
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  ingress {
    from_port        = 3306
    to_port          = 3306
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

resource "aws_instance" "Standalone" {
  ami                    = "ami-0fc5d935ebf8bc3bc"  # Ubuntu 20.04 LTS image ID in us-east-1 region
  instance_type          = "t2.micro"
  key_name               = "TP3_Key"
  vpc_security_group_ids = [aws_security_group.LOG8415E_TP3_Security_Group.id]
  subnet_id              = "subnet-06d5fa4be7931f5f0"
  count                  = 1
  private_ip             = "172.31.16.100"
  tags                   = {
    Name = "standalone"
  }
}

resource "aws_instance" "Manager" {
  ami                    = "ami-0fc5d935ebf8bc3bc"  # Ubuntu 20.04 LTS image ID in us-east-1 region
  instance_type          = "t2.micro"
  key_name               = "TP3_Key"
  vpc_security_group_ids = [aws_security_group.LOG8415E_TP3_Security_Group.id]
  subnet_id              = "subnet-06d5fa4be7931f5f0"
  private_ip             = "172.31.16.10"
  count                  = 1
  tags = {
    Name = "manager"
  }
}

resource "aws_instance" "Worker" {
  ami                    = "ami-0fc5d935ebf8bc3bc"  # Ubuntu 20.04 LTS image ID in us-est-2 region
  instance_type          = "t2.micro"
  key_name               = "TP3_Key"
  vpc_security_group_ids = [aws_security_group.LOG8415E_TP3_Security_Group.id]
  subnet_id              = "subnet-06d5fa4be7931f5f0"
  private_ip             = "172.31.16.${count.index + 11}"
  count                  = 3
  tags = {
    Name = "worker-${count.index + 1}"
  }
}

resource "aws_instance" "Proxy" {
  ami                    = "ami-0fc5d935ebf8bc3bc"  # Ubuntu 20.04 LTS image ID in us-east-1 region
  instance_type          = "t2.large"
  key_name               = "TP3_Key"
  vpc_security_group_ids = [aws_security_group.LOG8415E_TP3_Security_Group.id]
  subnet_id              = "subnet-06d5fa4be7931f5f0"
  private_ip             = "172.31.16.20"
  count                  = 1
  tags = {
    Name = "proxy"
  }
}

resource "aws_instance" "Gatekeeper" {
  ami                    = "ami-0fc5d935ebf8bc3bc"  # Ubuntu 20.04 LTS image ID in us-east-1 region
  instance_type          = "t2.large"
  key_name               = "TP3_Key"
  vpc_security_group_ids = [aws_security_group.LOG8415E_TP3_Security_Group.id]
  subnet_id              = "subnet-06d5fa4be7931f5f0"
  private_ip             = "172.31.16.21"
  count                  = 1
  tags = {
    Name = "gatekeeper"
  }
}