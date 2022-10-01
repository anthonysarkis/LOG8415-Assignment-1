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
  access_key = "ASIAT3EXCLIVMYZPIQ4O"
  secret_key = "Kk52kb9bKFBDRfF4gpxDzbAjS0HWKE4TdsZj1jw0"
  token      = "FwoGZXIvYXdzEL///////////wEaDHFCjcUGPfsma+GzsSLCAQdC7scI2yz1ntwVREH+59I565L980Jhb5xpdASCFzgCzE3QFJN8Hr78Mmmg6o0vi3pPNYpRg9+izHyibtNXMhRsAEUfExnCWZ2+G+8juNy7tkahtnsrYwto2ctNk7Fyvr6kGaw6xJkOjbYQ15jVbtKtVKNAynaK672Nq4ESzPu5ltmJMRvD6cXT3HUnS5zWLyuXpni5UPvcIYo8nbmuQcv2RVGKs0EMPUAimVmXy3Yf3cxQ2QvnPD/TMkHCvS5XjPnCKMrN3ZkGMi0tTxuAX+ZRP6AiHnoDyZZZHnmBDJOYicwLhzEppxTbo8Z/yczIUIOM3vKRI/M="
}

resource "aws_security_group" "security_gp" {
  vpc_id = "vpc-0c6fdbc545563b869"

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
    values = ["vpc-0c6fdbc545563b869"]
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
  vpc_id   = "vpc-0c6fdbc545563b869"
}

resource "aws_alb_target_group" "T2" {
  name     = "T2-instances"
  port     = 80
  protocol = "HTTP"
  vpc_id   = "vpc-0c6fdbc545563b869"
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
