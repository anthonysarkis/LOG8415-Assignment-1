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