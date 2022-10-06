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

resource "aws_alb_target_group_attachment" "M4_attachments" {
  count            = length(aws_instance.instances_m4)
  target_group_arn = aws_alb_target_group.M4.arn
  target_id        = aws_instance.instances_m4[count.index].id
  port             = 80
}

resource "aws_alb_target_group_attachment" "T2_attachments" {
  count            = length(aws_instance.instances_t2)
  target_group_arn = aws_alb_target_group.T2.arn
  target_id        = aws_instance.instances_t2[count.index].id
  port             = 80
}

resource "aws_cloudwatch_dashboard" "ec2_dashboard" {
  dashboard_name = "ec2_dashboard"

  dashboard_body = <<EOF
{
    "widgets": [
        {
            "type": "metric",
            "x": 0,
            "y": 0,
            "width": 8,
            "height": 4,
            "properties": {
                "metrics": [
                    [ "AWS/EC2", "CPUUtilization", "InstanceId", "${aws_instance.instances_m4[0].id}", { "period": 300, "stat": "Average" } ],
                    [ "...", "${aws_instance.instances_m4[1].id}", { "period": 300, "stat": "Average" } ],
                    [ "...", "${aws_instance.instances_m4[2].id}", { "period": 300, "stat": "Average" } ],
                    [ "...", "${aws_instance.instances_m4[3].id}", { "period": 300, "stat": "Average" } ],
                    [ "...", "${aws_instance.instances_m4[4].id}", { "period": 300, "stat": "Average" } ],
                    [ "...", "${aws_instance.instances_t2[0].id}", { "period": 300, "stat": "Average" } ],
                    [ "...", "${aws_instance.instances_t2[1].id}", { "period": 300, "stat": "Average" } ],
                    [ "...", "${aws_instance.instances_t2[2].id}", { "period": 300, "stat": "Average" } ],
                    [ "...", "${aws_instance.instances_t2[3].id}", { "period": 300, "stat": "Average" } ]
                ],
                "legend": {
                    "position": "right"
                },
                "region": "us-east-1",
                "liveData": false,
                "title": "CPU Utilization: Average"
            }
        },
        {
            "type": "metric",
            "x": 8,
            "y": 0,
            "width": 8,
            "height": 4,
            "properties": {
                "metrics": [
                    [ "AWS/EC2", "DiskReadBytes", "InstanceId", "${aws_instance.instances_m4[0].id}", { "period": 300, "stat": "Average" } ],
                    [ "...", "${aws_instance.instances_m4[1].id}", { "period": 300, "stat": "Average" } ],
                    [ "...", "${aws_instance.instances_m4[2].id}", { "period": 300, "stat": "Average" } ],
                    [ "...", "${aws_instance.instances_m4[3].id}", { "period": 300, "stat": "Average" } ],
                    [ "...", "${aws_instance.instances_m4[4].id}", { "period": 300, "stat": "Average" } ],
                    [ "...", "${aws_instance.instances_t2[0].id}", { "period": 300, "stat": "Average" } ],
                    [ "...", "${aws_instance.instances_t2[1].id}", { "period": 300, "stat": "Average" } ],
                    [ "...", "${aws_instance.instances_t2[2].id}", { "period": 300, "stat": "Average" } ],
                    [ "...", "${aws_instance.instances_t2[3].id}", { "period": 300, "stat": "Average" } ]
                ],
                "legend": {
                    "position": "right"
                },
                "region": "us-east-1",
                "liveData": false,
                "title": "DiskReadBytes: Average"
            }
        },
        {
            "type": "metric",
            "x": 16,
            "y": 0,
            "width": 8,
            "height": 4,
            "properties": {
                "metrics": [
                    [ "AWS/EC2", "DiskReadOps", "InstanceId", "${aws_instance.instances_m4[0].id}", { "period": 300, "stat": "Average" } ],
                    [ "...", "${aws_instance.instances_m4[1].id}", { "period": 300, "stat": "Average" } ],
                    [ "...", "${aws_instance.instances_m4[2].id}", { "period": 300, "stat": "Average" } ],
                    [ "...", "${aws_instance.instances_m4[3].id}", { "period": 300, "stat": "Average" } ],
                    [ "...", "${aws_instance.instances_m4[4].id}", { "period": 300, "stat": "Average" } ],
                    [ "...", "${aws_instance.instances_t2[0].id}", { "period": 300, "stat": "Average" } ],
                    [ "...", "${aws_instance.instances_t2[1].id}", { "period": 300, "stat": "Average" } ],
                    [ "...", "${aws_instance.instances_t2[2].id}", { "period": 300, "stat": "Average" } ],
                    [ "...", "${aws_instance.instances_t2[3].id}", { "period": 300, "stat": "Average" } ]
                ],
                "legend": {
                    "position": "right"
                },
                "region": "us-east-1",
                "liveData": false,
                "title": "DiskReadOps: Average"
            }
        },
        {
            "type": "metric",
            "x": 0,
            "y": 4,
            "width": 8,
            "height": 4,
            "properties": {
                "metrics": [
                    [ "AWS/EC2", "DiskWriteBytes", "InstanceId", "${aws_instance.instances_m4[0].id}", { "period": 300, "stat": "Average" } ],
                    [ "...", "${aws_instance.instances_m4[1].id}", { "period": 300, "stat": "Average" } ],
                    [ "...", "${aws_instance.instances_m4[2].id}", { "period": 300, "stat": "Average" } ],
                    [ "...", "${aws_instance.instances_m4[3].id}", { "period": 300, "stat": "Average" } ],
                    [ "...", "${aws_instance.instances_m4[4].id}", { "period": 300, "stat": "Average" } ],
                    [ "...", "${aws_instance.instances_t2[0].id}", { "period": 300, "stat": "Average" } ],
                    [ "...", "${aws_instance.instances_t2[1].id}", { "period": 300, "stat": "Average" } ],
                    [ "...", "${aws_instance.instances_t2[2].id}", { "period": 300, "stat": "Average" } ],
                    [ "...", "${aws_instance.instances_t2[3].id}", { "period": 300, "stat": "Average" } ]
                ],
                "legend": {
                    "position": "right"
                },
                "region": "us-east-1",
                "liveData": false,
                "title": "DiskWriteBytes: Average"
            }
        },
        {
            "type": "metric",
            "x": 8,
            "y": 4,
            "width": 8,
            "height": 4,
            "properties": {
                "metrics": [
                    [ "AWS/EC2", "DiskWriteOps", "InstanceId", "${aws_instance.instances_m4[0].id}", { "period": 300, "stat": "Average" } ],
                    [ "...", "${aws_instance.instances_m4[1].id}", { "period": 300, "stat": "Average" } ],
                    [ "...", "${aws_instance.instances_m4[2].id}", { "period": 300, "stat": "Average" } ],
                    [ "...", "${aws_instance.instances_m4[3].id}", { "period": 300, "stat": "Average" } ],
                    [ "...", "${aws_instance.instances_m4[4].id}", { "period": 300, "stat": "Average" } ],
                    [ "...", "${aws_instance.instances_t2[0].id}", { "period": 300, "stat": "Average" } ],
                    [ "...", "${aws_instance.instances_t2[1].id}", { "period": 300, "stat": "Average" } ],
                    [ "...", "${aws_instance.instances_t2[2].id}", { "period": 300, "stat": "Average" } ],
                    [ "...", "${aws_instance.instances_t2[3].id}", { "period": 300, "stat": "Average" } ]
                ],
                "legend": {
                    "position": "right"
                },
                "region": "us-east-1",
                "liveData": false,
                "title": "DiskWriteOps: Average"
            }
        },
        {
            "type": "metric",
            "x": 16,
            "y": 4,
            "width": 8,
            "height": 4,
            "properties": {
                "metrics": [
                    [ "AWS/EC2", "NetworkIn", "InstanceId", "${aws_instance.instances_m4[0].id}", { "period": 300, "stat": "Average" } ],
                    [ "...", "${aws_instance.instances_m4[1].id}", { "period": 300, "stat": "Average" } ],
                    [ "...", "${aws_instance.instances_m4[2].id}", { "period": 300, "stat": "Average" } ],
                    [ "...", "${aws_instance.instances_m4[3].id}", { "period": 300, "stat": "Average" } ],
                    [ "...", "${aws_instance.instances_m4[4].id}", { "period": 300, "stat": "Average" } ],
                    [ "...", "${aws_instance.instances_t2[0].id}", { "period": 300, "stat": "Average" } ],
                    [ "...", "${aws_instance.instances_t2[1].id}", { "period": 300, "stat": "Average" } ],
                    [ "...", "${aws_instance.instances_t2[2].id}", { "period": 300, "stat": "Average" } ],
                    [ "...", "${aws_instance.instances_t2[3].id}", { "period": 300, "stat": "Average" } ]
                ],
                "legend": {
                    "position": "right"
                },
                "region": "us-east-1",
                "liveData": false,
                "title": "NetworkIn: Average"
            }
        },
        {
            "type": "metric",
            "x": 0,
            "y": 8,
            "width": 8,
            "height": 4,
            "properties": {
                "metrics": [
                    [ "AWS/EC2", "NetworkOut", "InstanceId", "${aws_instance.instances_m4[0].id}", { "period": 300, "stat": "Average" } ],
                    [ "...", "${aws_instance.instances_m4[1].id}", { "period": 300, "stat": "Average" } ],
                    [ "...", "${aws_instance.instances_m4[2].id}", { "period": 300, "stat": "Average" } ],
                    [ "...", "${aws_instance.instances_m4[3].id}", { "period": 300, "stat": "Average" } ],
                    [ "...", "${aws_instance.instances_m4[4].id}", { "period": 300, "stat": "Average" } ],
                    [ "...", "${aws_instance.instances_t2[0].id}", { "period": 300, "stat": "Average" } ],
                    [ "...", "${aws_instance.instances_t2[1].id}", { "period": 300, "stat": "Average" } ],
                    [ "...", "${aws_instance.instances_t2[2].id}", { "period": 300, "stat": "Average" } ],
                    [ "...", "${aws_instance.instances_t2[3].id}", { "period": 300, "stat": "Average" } ]
                ],
                "legend": {
                    "position": "right"
                },
                "region": "us-east-1",
                "liveData": false,
                "title": "NetworkOut: Average"
            }
        },
        {
            "type": "metric",
            "x": 8,
            "y": 8,
            "width": 8,
            "height": 4,
            "properties": {
                "metrics": [
                    [ "AWS/EC2", "NetworkPacketsIn", "InstanceId", "${aws_instance.instances_m4[0].id}", { "period": 300, "stat": "Average" } ],
                    [ "...", "${aws_instance.instances_m4[1].id}", { "period": 300, "stat": "Average" } ],
                    [ "...", "${aws_instance.instances_m4[2].id}", { "period": 300, "stat": "Average" } ],
                    [ "...", "${aws_instance.instances_m4[3].id}", { "period": 300, "stat": "Average" } ],
                    [ "...", "${aws_instance.instances_m4[4].id}", { "period": 300, "stat": "Average" } ],
                    [ "...", "${aws_instance.instances_t2[0].id}", { "period": 300, "stat": "Average" } ],
                    [ "...", "${aws_instance.instances_t2[1].id}", { "period": 300, "stat": "Average" } ],
                    [ "...", "${aws_instance.instances_t2[2].id}", { "period": 300, "stat": "Average" } ],
                    [ "...", "${aws_instance.instances_t2[3].id}", { "period": 300, "stat": "Average" } ]
                ],
                "legend": {
                    "position": "right"
                },
                "region": "us-east-1",
                "liveData": false,
                "title": "NetworkPacketsIn: Average"
            }
        },
        {
            "type": "metric",
            "x": 16,
            "y": 8,
            "width": 8,
            "height": 4,
            "properties": {
                "metrics": [
                    [ "AWS/EC2", "NetworkPacketsOut", "InstanceId", "${aws_instance.instances_m4[0].id}", { "period": 300, "stat": "Average" } ],
                    [ "...", "${aws_instance.instances_m4[1].id}", { "period": 300, "stat": "Average" } ],
                    [ "...", "${aws_instance.instances_m4[2].id}", { "period": 300, "stat": "Average" } ],
                    [ "...", "${aws_instance.instances_m4[3].id}", { "period": 300, "stat": "Average" } ],
                    [ "...", "${aws_instance.instances_m4[4].id}", { "period": 300, "stat": "Average" } ],
                    [ "...", "${aws_instance.instances_t2[0].id}", { "period": 300, "stat": "Average" } ],
                    [ "...", "${aws_instance.instances_t2[1].id}", { "period": 300, "stat": "Average" } ],
                    [ "...", "${aws_instance.instances_t2[2].id}", { "period": 300, "stat": "Average" } ],
                    [ "...", "${aws_instance.instances_t2[3].id}", { "period": 300, "stat": "Average" } ]
                ],
                "legend": {
                    "position": "right"
                },
                "region": "us-east-1",
                "liveData": false,
                "title": "NetworkPacketsOut: Average"
            }
        },
        {
            "type": "metric",
            "x": 0,
            "y": 12,
            "width": 8,
            "height": 4,
            "properties": {
                "metrics": [
                    [ "AWS/EC2", "StatusCheckFailed", "InstanceId", "${aws_instance.instances_m4[0].id}", { "period": 300, "stat": "Sum" } ],
                    [ "...", "${aws_instance.instances_m4[1].id}", { "period": 300, "stat": "Sum" } ],
                    [ "...", "${aws_instance.instances_m4[2].id}", { "period": 300, "stat": "Sum" } ],
                    [ "...", "${aws_instance.instances_m4[3].id}", { "period": 300, "stat": "Sum" } ],
                    [ "...", "${aws_instance.instances_m4[4].id}", { "period": 300, "stat": "Sum" } ],
                    [ "...", "${aws_instance.instances_t2[0].id}", { "period": 300, "stat": "Sum" } ],
                    [ "...", "${aws_instance.instances_t2[1].id}", { "period": 300, "stat": "Sum" } ],
                    [ "...", "${aws_instance.instances_t2[2].id}", { "period": 300, "stat": "Sum" } ],
                    [ "...", "${aws_instance.instances_t2[3].id}", { "period": 300, "stat": "Sum" } ]
                ],
                "legend": {
                    "position": "right"
                },
                "region": "us-east-1",
                "liveData": false,
                "title": "StatusCheckFailed: Sum"
            }
        },
        {
            "type": "metric",
            "x": 8,
            "y": 12,
            "width": 8,
            "height": 4,
            "properties": {
                "metrics": [
                    [ "AWS/EC2", "StatusCheckFailed_Instance", "InstanceId", "${aws_instance.instances_m4[0].id}", { "period": 300, "stat": "Sum" } ],
                    [ "...", "${aws_instance.instances_m4[1].id}", { "period": 300, "stat": "Sum" } ],
                    [ "...", "${aws_instance.instances_m4[2].id}", { "period": 300, "stat": "Sum" } ],
                    [ "...", "${aws_instance.instances_m4[3].id}", { "period": 300, "stat": "Sum" } ],
                    [ "...", "${aws_instance.instances_m4[4].id}", { "period": 300, "stat": "Sum" } ],
                    [ "...", "${aws_instance.instances_t2[0].id}", { "period": 300, "stat": "Sum" } ],
                    [ "...", "${aws_instance.instances_t2[1].id}", { "period": 300, "stat": "Sum" } ],
                    [ "...", "${aws_instance.instances_t2[2].id}", { "period": 300, "stat": "Sum" } ],
                    [ "...", "${aws_instance.instances_t2[3].id}", { "period": 300, "stat": "Sum" } ]
                ],
                "legend": {
                    "position": "right"
                },
                "region": "us-east-1",
                "liveData": false,
                "title": "StatusCheckFailed_Instance: Sum"
            }
        },
        {
            "type": "metric",
            "x": 16,
            "y": 12,
            "width": 8,
            "height": 4,
            "properties": {
                "metrics": [
                    [ "AWS/EC2", "StatusCheckFailed_System", "InstanceId", "${aws_instance.instances_m4[0].id}", { "period": 300, "stat": "Sum" } ],
                    [ "...", "${aws_instance.instances_m4[1].id}", { "period": 300, "stat": "Sum" } ],
                    [ "...", "${aws_instance.instances_m4[2].id}", { "period": 300, "stat": "Sum" } ],
                    [ "...", "${aws_instance.instances_m4[3].id}", { "period": 300, "stat": "Sum" } ],
                    [ "...", "${aws_instance.instances_m4[4].id}", { "period": 300, "stat": "Sum" } ],
                    [ "...", "${aws_instance.instances_t2[0].id}", { "period": 300, "stat": "Sum" } ],
                    [ "...", "${aws_instance.instances_t2[1].id}", { "period": 300, "stat": "Sum" } ],
                    [ "...", "${aws_instance.instances_t2[2].id}", { "period": 300, "stat": "Sum" } ],
                    [ "...", "${aws_instance.instances_t2[3].id}", { "period": 300, "stat": "Sum" } ]
                ],
                "legend": {
                    "position": "right"
                },
                "region": "us-east-1",
                "liveData": false,
                "title": "StatusCheckFailed_System: Sum"
            }
        }
    ]
}
EOF
}

output "alb_dns_name" {
  description = "The Application Load Balancer DNS name"
  value       = aws_alb.load_balancer.*.dns_name[0]
}

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
