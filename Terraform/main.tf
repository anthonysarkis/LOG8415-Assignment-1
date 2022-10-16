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
  region = "us-east-1"
}

// Creation of a security group. Input and output traffic to and from our instances is anywhere
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

// Get the default AWS Virtual Private Cloud
data "aws_vpc" "default" {
  default = true
}

// Creation of 5 instances of type M4 large
resource "aws_instance" "instances_m4" {
  ami                    = "ami-0149b2da6ceec4bb0"
  instance_type          = "m4.large"
  vpc_security_group_ids = [aws_security_group.security_gp.id]
  availability_zone      = "us-east-1c"
  user_data              = file("userdata.sh")
  count                  = 5
  tags = {
    Name = "M4"
  }
}

// Creation of 4 instances of type T2 large
resource "aws_instance" "instances_t2" {
  ami                    = "ami-0149b2da6ceec4bb0"
  instance_type          = "t2.large"
  vpc_security_group_ids = [aws_security_group.security_gp.id]
  availability_zone      = "us-east-1d"
  user_data              = file("userdata.sh")
  count                  = 4
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

// Creation of the application load balancer (ALB)
resource "aws_alb" "load_balancer" {
  name            = "load-balancer"
  security_groups = [aws_security_group.security_gp.id]
  subnets         = data.aws_subnets.all.ids
}

// Creation of target group for M4 instances
resource "aws_alb_target_group" "M4" {
  name     = "M4-instances"
  port     = 80
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.default.id
}

// Creation of target group for T2 instances
resource "aws_alb_target_group" "T2" {
  name     = "T2-instances"
  port     = 80
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.default.id
}

// Creation of a listener. Will default to forwarding request to M4 target group. 
resource "aws_alb_listener" "listener" {
  load_balancer_arn = aws_alb.load_balancer.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.M4.arn
  }
}

// Creation of rule that will forward requests received on /cluster1 path to M4 target group
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

// Creation of rule that will forward requests received on /cluster2 path to T2 target group
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

// Creation of target group attachment, used to attach the M4 instances to the M4 target group using its ARN
resource "aws_alb_target_group_attachment" "M4_attachments" {
  count            = length(aws_instance.instances_m4)
  target_group_arn = aws_alb_target_group.M4.arn
  target_id        = aws_instance.instances_m4[count.index].id
  port             = 80
}

// Creation of target group attachment, used to attach the T2 instances to the T2 target group using its ARN
resource "aws_alb_target_group_attachment" "T2_attachments" {
  count            = length(aws_instance.instances_t2)
  target_group_arn = aws_alb_target_group.T2.arn
  target_id        = aws_instance.instances_t2[count.index].id
  port             = 80
}

// The following outputs are used by the script.sh file and given as parameters to the corresponding docker images that are run

// The DNS Name is necessary to form the url where the requests are sent
output "alb_dns_name" {
  description = "The Application Load Balancer DNS name"
  value       = aws_alb.load_balancer.*.dns_name[0]
}

// The ARNs of the load balancer and M4 and T2 target groups are used with the script that gets the benchmarks
output "load_balancer_arn_suffix" {
  description = "The Application Load Balancer ARN"
  value       = aws_alb.load_balancer.arn_suffix
}

output "M4_group_arn_suffix" {
  description = "M4 group arn suffix"
  value       = aws_alb_target_group.M4.arn_suffix
}

output "T2_group_arn_suffix" {
  description = "T2 group arn suffix"
  value       = aws_alb_target_group.T2.arn_suffix
}
