terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}


provider "aws" {
  region     = "us-east-1"
  access_key = "ASIAZ3DCZEO2EZPJDXHM"
  secret_key = "aXwrP6RvuR/Jv8o5NrjHjQZUpj/czepKxDfCTuGZ"
  token      = "FwoGZXIvYXdzEBoaDIPjgZSN8hhEskto9CLJAQ9H7DUUzFgvE/b8S+RV65wR2dLbqqw5bBEcBTDdsYJhhe9845p+dQ+kDbKRtiExoTGcsgZbYqny1wROCzBRTbutNzZvGr+gsHjCZTin0sNgOvcPtwGI9PbN14UF037UC8VXkD4lstdp5pU8womtftvyRVz4KJy4dlLoZqA+0VMtbniR0m2cCvxY7HXlmFqJTBh/qdjfX0iFhCqJVyx6/Zy5f+UjymZNJdJp+bZh8CLgF3lNcl9MwK1E5Oith54iCCweNS98owbbNCjYmbmZBjIt6pjyEjoqjC2iKV+mILGX5qnNOfrObxgpizdzpDMPBbuD2mlkaNCVvnGg5tny"
}

resource "aws_instance" "instance1" {
  ami           = "ami-0149b2da6ceec4bb0"
  instance_type = "m4.large"
  subnet_id     = aws_subnet.public_1.id
  tags = {
    Name = "M4"
  }
}

resource "aws_instance" "instance2" {
  ami           = "ami-0149b2da6ceec4bb0"
  instance_type = "m4.large"
  subnet_id     = aws_subnet.public_1.id
  tags = {
    Name = "M4"
  }
}

resource "aws_instance" "instance3" {
  ami           = "ami-0149b2da6ceec4bb0"
  instance_type = "m4.large"
  subnet_id     = aws_subnet.public_1.id
  tags = {
    Name = "M4"
  }
}

resource "aws_instance" "instance4" {
  ami           = "ami-0149b2da6ceec4bb0"
  instance_type = "m4.large"
  subnet_id     = aws_subnet.public_1.id
  tags = {
    Name = "M4"
  }
}

resource "aws_instance" "instance5" {
  ami           = "ami-0149b2da6ceec4bb0"
  instance_type = "m4.large"
  subnet_id     = aws_subnet.public_1.id
  tags = {
    Name = "M4"
  }
}

resource "aws_instance" "instance6" {
  ami           = "ami-0149b2da6ceec4bb0"
  instance_type = "t2.large"
  subnet_id     = aws_subnet.public_1.id
  tags = {
    Name = "T2"
  }
}

resource "aws_instance" "instance7" {
  ami           = "ami-0149b2da6ceec4bb0"
  instance_type = "t2.large"
  subnet_id     = aws_subnet.public_1.id
  tags = {
    Name = "T2"
  }
}

resource "aws_instance" "instance8" {
  ami           = "ami-0149b2da6ceec4bb0"
  instance_type = "t2.large"
  subnet_id     = aws_subnet.public_1.id
  tags = {
    Name = "T2"
  }
}

resource "aws_instance" "instance9" {
  ami           = "ami-0149b2da6ceec4bb0"
  instance_type = "t2.large"
  subnet_id     = aws_subnet.public_1.id
  tags = {
    Name = "T2"
  }
}

resource "aws_instance" "instance10" {
  ami           = "ami-0149b2da6ceec4bb0"
  instance_type = "t2.large"
  subnet_id     = aws_subnet.public_1.id
  tags = {
    Name = "T2"
  }
}


#Network
resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"
}

# Create an Internet Gateway.
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.my_vpc.id
}

resource "aws_subnet" "public_1" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
}

# Create the second public subnet in the VPC for external traffic.
resource "aws_subnet" "public_2" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "us-east-1c"
  map_public_ip_on_launch = true
}



resource "aws_lb" "load_balancer" {
  name               = "load-balancer"
  internal           = false
  load_balancer_type = "application"
  subnets            = [aws_subnet.public_1.id, aws_subnet.public_2.id]

  enable_deletion_protection = true

  tags = {
    Environment = "production"
  }
}

resource "aws_lb_target_group" "M4" {
  name     = "M4-instances"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.my_vpc.id
}

resource "aws_lb_target_group" "T2" {
  name     = "T2-instances"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.my_vpc.id
}


resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.load_balancer.arn
  port              = "443"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.M4.arn
  }
}

resource "aws_lb_listener_rule" "M4_rule" {
  listener_arn = aws_lb_listener.listener.arn

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.M4.arn
  }

  condition {
    path_pattern {
      values = ["*/cluster1"]
    }
  }
}

resource "aws_lb_listener_rule" "T2_rule" {
  listener_arn = aws_lb_listener.listener.arn

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.T2.arn
  }

  condition {
    path_pattern {
      values = ["*/cluster2"]
    }
  }
}

resource "aws_alb_target_group_attachment" "M4_attachment_1" {
  target_group_arn = aws_lb_target_group.M4.arn
  target_id        = aws_instance.instance1.id
}

resource "aws_alb_target_group_attachment" "M4_attachment_2" {
  target_group_arn = aws_lb_target_group.M4.arn
  target_id        = aws_instance.instance2.id
}

resource "aws_alb_target_group_attachment" "M4_attachment_3" {
  target_group_arn = aws_lb_target_group.M4.arn
  target_id        = aws_instance.instance3.id
}

resource "aws_alb_target_group_attachment" "M4_attachment_4" {
  target_group_arn = aws_lb_target_group.M4.arn
  target_id        = aws_instance.instance4.id
}

resource "aws_alb_target_group_attachment" "M4_attachment_5" {
  target_group_arn = aws_lb_target_group.M4.arn
  target_id        = aws_instance.instance5.id
}

resource "aws_alb_target_group_attachment" "T2_attachment_1" {
  target_group_arn = aws_lb_target_group.T2.arn
  target_id        = aws_instance.instance6.id
}

resource "aws_alb_target_group_attachment" "T2_attachment_2" {
  target_group_arn = aws_lb_target_group.T2.arn
  target_id        = aws_instance.instance7.id
}

resource "aws_alb_target_group_attachment" "T2_attachment_3" {
  target_group_arn = aws_lb_target_group.T2.arn
  target_id        = aws_instance.instance8.id
}

resource "aws_alb_target_group_attachment" "T2_attachment_4" {
  target_group_arn = aws_lb_target_group.T2.arn
  target_id        = aws_instance.instance9.id
}

resource "aws_alb_target_group_attachment" "T2_attachment_5" {
  target_group_arn = aws_lb_target_group.T2.arn
  target_id        = aws_instance.instance10.id
}

output "alb_dns_name" {
  description = "The Application Load Balancer DNS name"
  value       = aws_lb.load_balancer.*.dns_name[0]
}