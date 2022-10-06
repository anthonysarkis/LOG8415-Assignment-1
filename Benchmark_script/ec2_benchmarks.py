# docker image build -f Dockerfile_benchmarks -t ec2_benchmarks .
# docker run -e M4="i-1,i-2,i-3" -e T2="i-1,i-2,i-3" -e load_balancer="app/load-balancer/dfd7de50da537297" -e cluster1="targetgroup/M4-instances/d9cca333fc82aa43" -e cluster2="targetgroup/T2-instances/1c4d5351a9b4c048" ec2_benchmarks
# docker run -e M4="i-085dd8a17d3dc4e23" -e T2="i-01d73f88f64dc235f" -e load_balancer="app/load-balancer/dfd7de50da537297" -e cluster1="targetgroup/M4-instances/d9cca333fc82aa43" -e cluster2="targetgroup/T2-instances/1c4d5351a9b4c048" ec2_benchmarks
# docker run \
# -e M4="i-085dd8a17d3dc4e23,i-07e7e50b21e71fa00,i-02bc697b26af185b6,i-0b25584b9b392d6b6,i-0fcadd0991e694051" \
# -e T2="i-01d73f88f64dc235f,i-027d5a4e5aa29d276,i-04a41a2b1d8e253a0,i-063353a2865953686" \ 
# -e load_balancer="app/load-balancer/dfd7de50da537297" \
# -e cluster1="targetgroup/M4-instances/d9cca333fc82aa43" \
# -e cluster2="targetgroup/T2-instances/1c4d5351a9b4c048" \
# ec2_benchmarks
import boto3
import os
from datetime import timedelta, datetime
from tabulate import tabulate

client = boto3.client('cloudwatch', 
    region_name="us-east-1",
    aws_access_key_id=os.environ['AWS_ACCESS_KEY_ID'],
    aws_secret_access_key=os.environ['AWS_SECRET_ACCESS_KEY'],
    aws_session_token=os.environ['AWS_SESSION_TOKEN']
)

def get_metric_data(metric, targetGroup1ARN, targetGroup2ARN, loadBalancer):

    average = metric == 'TargetResponseTime'

    response = client.get_metric_data(
        MetricDataQueries=[
            {
                'Id': 'benchmark_' + metric.replace(" ", "_") + "_M4",
                'MetricStat': {
                    'Metric': {
                        'Namespace': 'AWS/ApplicationELB',
                        'MetricName': metric,
                        'Dimensions': [
                            {
                                'Name': 'TargetGroup',
                                'Value': targetGroup1ARN
                            },
                            {
                                'Name': 'LoadBalancer',
                                'Value': loadBalancer
                            },
                        ]
                    },
                    'Period': 60,
                    'Stat': 'Average' if average else 'Sum',
                    'Unit': 'Seconds' if metric == 'TargetResponseTime' else 'Count'
                }
            },
            {
                'Id': 'benchmark_' + metric.replace(" ", "_") + "_T2",
                'MetricStat': {
                    'Metric': {
                        'Namespace': 'AWS/ApplicationELB',
                        'MetricName': metric,
                        'Dimensions': [
                            {
                                'Name': 'TargetGroup',
                                'Value': targetGroup2ARN
                            },
                            {
                                'Name': 'LoadBalancer',
                                'Value': loadBalancer
                            },
                        ]
                    },
                    'Period': 60,
                    'Stat': 'Average' if metric == 'TargetResponseTime' or metric == 'HealthyHostCount' or metric == 'UnHealthyHostCount' else 'Sum',
                    'Unit': 'Seconds' if metric == 'TargetResponseTime' else 'Count'
                }
            },
        ],
        StartTime=datetime.utcnow() - timedelta(minutes=115),
        EndTime=datetime.utcnow() + timedelta(minutes=15)
    )

    return (response, average)


def get_req_count(lb_name):
    count = 0
    response = client.get_metric_statistics(
        Namespace="AWS/ApplicationELB",
        MetricName="RequestCount",
        Dimensions=[
            {
                "Name": "LoadBalancer",
                "Value": lb_name
            },
        ],
        StartTime=datetime.utcnow() - timedelta(minutes=1005),
        EndTime=datetime.utcnow() + timedelta(minutes=15),
        Period=86460,
        Statistics=[
            "Sum",
        ]
    )
    print(response)

    #print(response2)
    for r in response['Datapoints']:
        count = (r['Sum'])

    print("Count: ", count)
    return count

# def get_widget():
#     response = client.get_metric_statistics(
        
#     )

#     return response
#     {
#         "width": 600,
#         "height": 395,
#         "metrics": [
#             ["AWS/EC2", "CPUUtilization", "InstanceId",
#                 "i-01234567890123456", {"stat": "Average"}]
#         ],
#         "period": 300,
#         "stacked": false,
#         "yAxis": {
#             "left": {
#                 "min": 0.1,
#                 "max": 1
#             },
#             "right": {
#                 "min": 0
#             }
#         },
#         "title": "CPU",
#         "annotations": {
#             "horizontal": [
#                 {
#                     "color": "#ff6961",
#                     "label": "Troublethresholdstart",
#                     "fill": "above",
#                     "value": 0.5
#                 }
#             ],
#             "vertical": [
#                 {
#                     "visible": true,
#                     "color": "#9467bd",
#                     "label": "Bugfixdeployed",
#                     "value": "2018-11-19T07:25:26Z",
#                     "fill": "after"
#                 }
#             ]
#         },
#         "view": "timeSeries"
#     }

def get_widgets():

    metrics = dict()

    metrics['AWS/EC2'] = [
        "CPUUtilization",
        "NetworkPacketsIn",
        "NetworkPacketsOut"
    ]
    metrics['AWS/ApplicationELB'] = [
        "RequestCount",
    ]

    instanceIdsDict = dict()
    instanceIdsDict['M4'] = os.environ['M4'].split(',')
    instanceIdsDict['T2'] = os.environ['T2'].split(',')
    # instanceIdsDict['M4'] = [
    #     "i-085dd8a17d3dc4e23",
    #     "i-07e7e50b21e71fa00",
    #     "i-02bc697b26af185b6",
    #     "i-0b25584b9b392d6b6",
    #     "i-0fcadd0991e694051"
    # ]
    # "i-085dd8a17d3dc4e23", "i-07e7e50b21e71fa00", "i-02bc697b26af185b6", "i-0b25584b9b392d6b6","i-0fcadd0991e694051"
    # instanceIdsDict['T2'] = [
    #     "i-01d73f88f64dc235f", "i-027d5a4e5aa29d276", "i-04a41a2b1d8e253a0", "i-063353a2865953686"
    # ]

    colors = ['#0000FF', '#FF0000']

    for metric in metrics['AWS/EC2']:
        json = '{"metrics": ['

        for instanceGroupNumber, (instanceGroup, instanceIds) in enumerate(instanceIdsDict.items()):
            for index, instanceId in enumerate(instanceIds):
                json += f'[ \
                    "AWS/EC2", \
                    "{metric}", \
                    "InstanceId", "{instanceId}", \
                    {{ "stat": "Average", "label": "{instanceGroup}_{index}", "period": 300, "color": "{colors[instanceGroupNumber]}"}}]'
                json += ','

        json = json[:-1]
        json += ']}'

        response = client.get_metric_widget_image(MetricWidget=json)

        with open(f'{metric}.png', 'wb') as f:
            f.write(response["MetricWidgetImage"])

    for metric in metrics['AWS/ApplicationELB']:
        json = '{"metrics": ['

        for instanceGroupNumber, (instanceGroup, instanceIds) in enumerate(instanceIdsDict.items()):
            for index, instanceId in enumerate(instanceIds):
                json += f'[ \
                    "AWS/ApplicationELB", \
                    "{metric}", \
                    "TargetGroup", "targetgroup/M4-instances/eef1ea1f0cde16ce", \
                    "LoadBalancer", "app/load-balancer/d5bda477a4d5bc67", \
                    {{ "stat": "SampleCount", "label": "{instanceGroup}_{index}", "period": 300, "color": "{colors[instanceGroupNumber]}"}}]'
                json += ','

        json = json[:-1]
        json += ']}'

        response = client.get_metric_widget_image(MetricWidget=json)

        with open(f'{metric}.png', 'wb') as f:
            f.write(response["MetricWidgetImage"])

if __name__ == '__main__':
    # load_balancer = os.popen('terraform output --raw load_balancer_arn_suffix').read()
    # cluster1 = os.popen('terraform output --raw M4_group_arn_suffix').read()
    # cluster2 = os.popen('terraform output --raw T2_group_arn_suffix').read()

    # load_balancer = "app/load-balancer/dfd7de50da537297"
    # cluster1 = "targetgroup/M4-instances/d9cca333fc82aa43"
    # cluster2 = "targetgroup/T2-instances/1c4d5351a9b4c048"

    load_balancer = os.environ['load_balancer']
    cluster1 = os.environ['cluster1']
    cluster2 = os.environ['cluster2']

    metrics = [
        'RequestCount',
        'TargetResponseTime',
        'HTTPCode_Target_2XX_Count',
        'HTTPCode_Target_4XX_Count',
        'HTTPCode_Target_5XX_Count'
        'Connection Error Count',
        'HealthyHostCount',
        'UnHealthyHostCount'
    ]
    headers = [
        'Target',
        'Request count',
        'Average response time (s)',
        'Status 2XX',
        'Status 4XX',
        'Status 5xx'
        'TargetConnectionErrorCount',
        'HealthyHostCount',
        'UnHealthyHostCount'
    ]
    cluster1_data = ['Cluster1 (M4)']
    cluster2_data = ['Cluster2 (T2)']
    total_data = ['Total']

    for i, metric in enumerate(metrics):
        response, average = get_metric_data(metric, cluster1, cluster2, load_balancer)
        cluster1_values = sum(response['MetricDataResults'][0]['Values'])
        cluster2_values = sum(response['MetricDataResults'][1]['Values'])
        total_values = (cluster1_values + cluster2_values) / 2 if average else cluster1_values + cluster2_values

        cluster1_data.append(cluster1_values)
        cluster2_data.append(cluster2_values)
        total_data.append(total_values)

    benchmark = tabulate([cluster1_data, cluster2_data, total_data], headers=headers)
    print(benchmark)

    # get_widgets()
