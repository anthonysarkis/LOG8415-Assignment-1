resource "aws_cloudwatch_dashboard" "alb_dashboard" {
  dashboard_name = "ALB-Dashboard"

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
                    [ "AWS/ApplicationELB", "RequestCount", "LoadBalancer", "${aws_alb.load_balancer.arn_suffix}", { "period": 300, "stat": "Sum" } ]
                ],
                "legend": {
                    "position": "bottom"
                },
                "title": "RequestCount: Sum",
                "region": "us-east-1",
                "liveData": false
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
                    [ "AWS/ApplicationELB", "HTTPCode_ELB_5XX_Count", "LoadBalancer", "${aws_alb.load_balancer.arn_suffix}", { "period": 300, "stat": "Sum" } ]
                ],
                "legend": {
                    "position": "bottom"
                },
                "title": "HTTPCode_ELB_5XX_Count: Sum",
                "region": "us-east-1",
                "liveData": false
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
                    [ "AWS/ApplicationELB", "ActiveConnectionCount", "LoadBalancer", "${aws_alb.load_balancer.arn_suffix}", { "period": 300, "stat": "Sum" } ]
                ],
                "legend": {
                    "position": "bottom"
                },
                "title": "ActiveConnectionCount: Sum",
                "region": "us-east-1",
                "liveData": false
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
                    [ "AWS/ApplicationELB", "ClientTLSNegotiationErrorCount", "LoadBalancer", "${aws_alb.load_balancer.arn_suffix}", { "period": 300, "stat": "Sum" } ]
                ],
                "legend": {
                    "position": "bottom"
                },
                "title": "ClientTLSNegotiationErrorCount: Sum",
                "region": "us-east-1",
                "liveData": false
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
                    [ "AWS/ApplicationELB", "ConsumedLCUs", "LoadBalancer", "${aws_alb.load_balancer.arn_suffix}", { "period": 300, "stat": "Average" } ]
                ],
                "legend": {
                    "position": "right"
                },
                "region": "us-east-1",
                "liveData": false,
                "title": "ConsumedLCUs: Average"
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
                    [ "AWS/ApplicationELB", "HTTP_Fixed_Response_Count", "LoadBalancer", "${aws_alb.load_balancer.arn_suffix}", { "period": 300, "stat": "Sum" } ]
                ],
                "legend": {
                    "position": "bottom"
                },
                "title": "HTTP_Fixed_Response_Count: Sum",
                "region": "us-east-1",
                "liveData": false
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
                    [ "AWS/ApplicationELB", "HTTP_Redirect_Count", "LoadBalancer", "${aws_alb.load_balancer.arn_suffix}", { "period": 300, "stat": "Sum" } ]
                ],
                "legend": {
                    "position": "bottom"
                },
                "title": "HTTP_Redirect_Count: Sum",
                "region": "us-east-1",
                "liveData": false
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
                    [ "AWS/ApplicationELB", "HTTP_Redirect_Url_Limit_Exceeded_Count", "LoadBalancer", "${aws_alb.load_balancer.arn_suffix}", { "period": 300, "stat": "Sum" } ]
                ],
                "legend": {
                    "position": "bottom"
                },
                "title": "HTTP_Redirect_Url_Limit_Exceeded_Count: Sum",
                "region": "us-east-1",
                "liveData": false
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
                    [ "AWS/ApplicationELB", "HTTPCode_ELB_3XX_Count", "LoadBalancer", "${aws_alb.load_balancer.arn_suffix}", { "period": 300, "stat": "Sum" } ]
                ],
                "legend": {
                    "position": "bottom"
                },
                "title": "HTTPCode_ELB_3XX_Count: Sum",
                "region": "us-east-1",
                "liveData": false
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
                    [ "AWS/ApplicationELB", "HTTPCode_ELB_4XX_Count", "LoadBalancer", "${aws_alb.load_balancer.arn_suffix}", { "period": 300, "stat": "Sum" } ]
                ],
                "legend": {
                    "position": "bottom"
                },
                "title": "HTTPCode_ELB_4XX_Count: Sum",
                "region": "us-east-1",
                "liveData": false
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
                    [ "AWS/ApplicationELB", "IPv6ProcessedBytes", "LoadBalancer", "${aws_alb.load_balancer.arn_suffix}", { "period": 300, "stat": "Sum" } ]
                ],
                "legend": {
                    "position": "bottom"
                },
                "title": "IPv6ProcessedBytes: Sum",
                "region": "us-east-1",
                "liveData": false
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
                    [ "AWS/ApplicationELB", "IPv6RequestCount", "LoadBalancer", "${aws_alb.load_balancer.arn_suffix}", { "period": 300, "stat": "Sum" } ]
                ],
                "legend": {
                    "position": "bottom"
                },
                "title": "IPv6RequestCount: Sum",
                "region": "us-east-1",
                "liveData": false
            }
        },
        {
            "type": "metric",
            "x": 0,
            "y": 16,
            "width": 8,
            "height": 4,
            "properties": {
                "metrics": [
                    [ "AWS/ApplicationELB", "NewConnectionCount", "LoadBalancer", "${aws_alb.load_balancer.arn_suffix}", { "period": 300, "stat": "Sum" } ]
                ],
                "legend": {
                    "position": "bottom"
                },
                "title": "NewConnectionCount: Sum",
                "region": "us-east-1",
                "liveData": false
            }
        },
        {
            "type": "metric",
            "x": 8,
            "y": 16,
            "width": 8,
            "height": 4,
            "properties": {
                "metrics": [
                    [ "AWS/ApplicationELB", "ProcessedBytes", "LoadBalancer", "${aws_alb.load_balancer.arn_suffix}", { "period": 300, "stat": "Sum" } ]
                ],
                "legend": {
                    "position": "bottom"
                },
                "title": "ProcessedBytes: Sum",
                "region": "us-east-1",
                "liveData": false
            }
        },
        {
            "type": "metric",
            "x": 16,
            "y": 16,
            "width": 8,
            "height": 4,
            "properties": {
                "metrics": [
                    [ "AWS/ApplicationELB", "RejectedConnectionCount", "LoadBalancer", "${aws_alb.load_balancer.arn_suffix}", { "period": 300, "stat": "Sum" } ]
                ],
                "legend": {
                    "position": "bottom"
                },
                "title": "RejectedConnectionCount: Sum",
                "region": "us-east-1",
                "liveData": false
            }
        },
        {
            "type": "metric",
            "x": 0,
            "y": 20,
            "width": 24,
            "height": 4,
            "properties": {
                "metrics": [
                    [ "AWS/ApplicationELB", "RuleEvaluations", "LoadBalancer", "${aws_alb.load_balancer.arn_suffix}", { "period": 300, "stat": "Sum" } ]
                ],
                "legend": {
                    "position": "bottom"
                },
                "title": "RuleEvaluations: Sum",
                "region": "us-east-1",
                "liveData": false
            }
        }
    ]
}
EOF
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
