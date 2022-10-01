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
  access_key = "ASIAT3EXCLIVAZFMAYYL"
  secret_key = "h1DJDuTypqd28Eb7SlgOw8CYEIQ0NCJEQGnri2tN"
  token      = "FwoGZXIvYXdzEMb//////////wEaDDEL6l2cs6Ar0Df1tiLCASiD0o8H9Oz6bZBuCS0aUgMIGvwDsl/qCuJ8ieKfnnT/n9cF9weHkOWwZ7TZiemAG4PtGA4fIXtMgcxi9m4haiLRZKevBwock64tbdfoHUtqgOJLJhbXccDXpzierWiqf0yliZzHZnPAndvVwmY0uSjdMkCAbk3LvAsEg0SsRxxsfN5VLL12XeEA/rWgx4hWPpST7fgyrYdm14O//Yiw8JZxJ7Nsa48uRgVUx85zEt7We5wQ5hgArr4T9L6G7xUQ4ZD1KOD93pkGMi3LgTPKduaCSm6MrDuNgsJd6px8iWgUuQjpXrU+2pi0r+iyWFTa6A7KI7rM8Cs="
}

resource "aws_security_group" "security_gp" {
  vpc_id = data.aws_vpc.default.id

  ingress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

data "aws_vpc" "default" {
  default = true
}

resource "aws_instance" "instance1" {
  ami                    = "ami-0149b2da6ceec4bb0"
  instance_type          = "m4.large"
  vpc_security_group_ids = [aws_security_group.security_gp.id]
  availability_zone      = "us-east-1c"
  user_data              = file("userdata.sh")
  tags = {
    Name = "M4"
  }
}

resource "aws_instance" "instance2" {
  ami                    = "ami-0149b2da6ceec4bb0"
  instance_type          = "m4.large"
  vpc_security_group_ids = [aws_security_group.security_gp.id]
  availability_zone      = "us-east-1d"
  user_data              = file("userdata.sh")
  tags = {
    Name = "M4"
  }
}

resource "aws_instance" "instance3" {
  ami                    = "ami-0149b2da6ceec4bb0"
  instance_type          = "m4.large"
  vpc_security_group_ids = [aws_security_group.security_gp.id]
  availability_zone      = "us-east-1c"
  user_data              = file("userdata.sh")
  tags = {
    Name = "M4"
  }
}

resource "aws_instance" "instance4" {
  ami                    = "ami-0149b2da6ceec4bb0"
  instance_type          = "m4.large"
  vpc_security_group_ids = [aws_security_group.security_gp.id]
  availability_zone      = "us-east-1d"
  user_data              = file("userdata.sh")
  tags = {
    Name = "M4"
  }
}

resource "aws_instance" "instance5" {
  ami                    = "ami-0149b2da6ceec4bb0"
  instance_type          = "m4.large"
  vpc_security_group_ids = [aws_security_group.security_gp.id]
  availability_zone      = "us-east-1c"
  user_data              = file("userdata.sh")
  tags = {
    Name = "M4"
  }
}

resource "aws_instance" "instance6" {
  ami                    = "ami-0149b2da6ceec4bb0"
  instance_type          = "t2.large"
  vpc_security_group_ids = [aws_security_group.security_gp.id]
  availability_zone      = "us-east-1d"
  user_data              = file("userdata.sh")
  tags = {
    Name = "T2"
  }
}

resource "aws_instance" "instance7" {
  ami                    = "ami-0149b2da6ceec4bb0"
  instance_type          = "t2.large"
  vpc_security_group_ids = [aws_security_group.security_gp.id]
  availability_zone      = "us-east-1d"
  user_data              = file("userdata.sh")
  tags = {
    Name = "T2"
  }
}

resource "aws_instance" "instance8" {
  ami                    = "ami-0149b2da6ceec4bb0"
  instance_type          = "t2.large"
  vpc_security_group_ids = [aws_security_group.security_gp.id]
  availability_zone      = "us-east-1c"
  user_data              = file("userdata.sh")
  tags = {
    Name = "T2"
  }
}

resource "aws_instance" "instance9" {
  ami                    = "ami-0149b2da6ceec4bb0"
  instance_type          = "t2.large"
  vpc_security_group_ids = [aws_security_group.security_gp.id]
  availability_zone      = "us-east-1d"
  user_data              = file("userdata.sh")
  tags = {
    Name = "T2"
  }
}

data "aws_subnets" "all" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

resource "aws_alb" "load_balancer" {
  name            = "load-balancer"
  security_groups = [aws_security_group.security_gp.id]
  subnets         = data.aws_subnets.all.ids
}

resource "aws_alb_target_group" "M4" {
  name     = "M4-instances"
  port     = 80
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.default.id
}

resource "aws_alb_target_group" "T2" {
  name     = "T2-instances"
  port     = 80
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.default.id
}


resource "aws_alb_listener" "listener" {
  load_balancer_arn = aws_alb.load_balancer.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.M4.arn
  }
}

resource "aws_alb_listener_rule" "M4_rule" {
  listener_arn = aws_alb_listener.listener.arn

  action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.M4.arn
  }

  condition {
    path_pattern {
      values = ["/cluster1"]
    }
  }
}

resource "aws_alb_listener_rule" "T2_rule" {
  listener_arn = aws_alb_listener.listener.arn

  action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.T2.arn
  }

  condition {
    path_pattern {
      values = ["/cluster2"]
    }
  }
}

resource "aws_alb_target_group_attachment" "M4_attachment_1" {
  target_group_arn = aws_alb_target_group.M4.arn
  target_id        = aws_instance.instance1.id
  port             = 80
}

resource "aws_alb_target_group_attachment" "M4_attachment_2" {
  target_group_arn = aws_alb_target_group.M4.arn
  target_id        = aws_instance.instance2.id
  port             = 80
}

resource "aws_alb_target_group_attachment" "M4_attachment_3" {
  target_group_arn = aws_alb_target_group.M4.arn
  target_id        = aws_instance.instance3.id
  port             = 80

}

resource "aws_alb_target_group_attachment" "M4_attachment_4" {
  target_group_arn = aws_alb_target_group.M4.arn
  target_id        = aws_instance.instance4.id
  port             = 80

}

resource "aws_alb_target_group_attachment" "M4_attachment_5" {
  target_group_arn = aws_alb_target_group.M4.arn
  target_id        = aws_instance.instance5.id
  port             = 80
}

resource "aws_alb_target_group_attachment" "T2_attachment_1" {
  target_group_arn = aws_alb_target_group.T2.arn
  target_id        = aws_instance.instance6.id
  port             = 80
}

resource "aws_alb_target_group_attachment" "T2_attachment_2" {
  target_group_arn = aws_alb_target_group.T2.arn
  target_id        = aws_instance.instance7.id
  port             = 80
}

resource "aws_alb_target_group_attachment" "T2_attachment_3" {
  target_group_arn = aws_alb_target_group.T2.arn
  target_id        = aws_instance.instance8.id
  port             = 80
}

resource "aws_alb_target_group_attachment" "T2_attachment_4" {
  target_group_arn = aws_alb_target_group.T2.arn
  target_id        = aws_instance.instance9.id
  port             = 80
}

output "alb_dns_name" {
  description = "The Application Load Balancer DNS name"
  value       = aws_alb.load_balancer.*.dns_name[0]
}
