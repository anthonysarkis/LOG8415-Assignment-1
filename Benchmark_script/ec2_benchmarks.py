import time
import boto3
import os
from datetime import timedelta, datetime
from tabulate import tabulate

# Define the boto3.client with environment variables to access our data on CloudWatch
client = boto3.client('cloudwatch', 
    region_name="us-east-1",
    aws_access_key_id=os.environ['AWS_ACCESS_KEY_ID'],
    aws_secret_access_key=os.environ['AWS_SECRET_ACCESS_KEY'],
    aws_session_token=os.environ['AWS_SESSION_TOKEN']
)

def get_metric_data(metric, targetGroup1ARN, targetGroup2ARN, loadBalancer):
    """
    get_metric_data             gets the metric data on AWS CloudWatch

    :param metric:              the metric on which we get the data
    :param targetGroup1ARN:     the ARN of M4 target group
    :param targetGroup2ARN:     the ARN of T2 target group
    :param loadBalancer:        the ARN of the Application load balancer
    :return:                    the data from AWS CloudWatch for the corresponding metric for cluster 1 and cluster2
                                and the corresponding statistic of that metric for each cluster
    """
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
        StartTime=datetime.utcnow() - timedelta(minutes=15),
        EndTime=datetime.utcnow() + timedelta(minutes=15)
    )

    return (response, average)



if __name__ == '__main__':
    time.sleep(60)
    # Get environment variables values
    load_balancer = os.environ['load_balancer']
    cluster1 = os.environ['cluster1']
    cluster2 = os.environ['cluster2']

    # All the metrics for which we will fetch the data from CloudWatch
    metrics = [
        'RequestCount',
        'TargetResponseTime',
        'HTTPCode_Target_2XX_Count',
        'HTTPCode_Target_4XX_Count',
        'HTTPCode_Target_5XX_Count'
        'TargetConnectionErrorCount',
        'HealthyHostCount',
        'UnHealthyHostCount'
    ]

    # Headers to format the table that shows the data
    headers = [
        'Target',
        'Request count',
        'Average response time (s)',
        'Status 2XX',
        'Status 4XX',
        'Status 5xx'
        'Connection Error Count',
        'HealthyHostCount',
        'UnHealthyHostCount'
    ]
    
    cluster1_data = ['Cluster1 (M4)']   # All the data from cluster1
    cluster2_data = ['Cluster2 (T2)']   # All the data from cluster2
    total_data = ['Total']              # All the data from both clusters

    # Get the data for each metric defined above
    for i, metric in enumerate(metrics):
        response, average = get_metric_data(metric, cluster1, cluster2, load_balancer)
        cluster1_values = sum(response['MetricDataResults'][0]['Values'])
        cluster2_values = sum(response['MetricDataResults'][1]['Values'])
        total_values = (cluster1_values + cluster2_values) / 2 if average else cluster1_values + cluster2_values

        # Add the fetched data to total data lists
        cluster1_data.append(cluster1_values)
        cluster2_data.append(cluster2_values)
        total_data.append(total_values)

    # Output all the data fetched for cluster1, cluster2 and both of them combined
    benchmark = tabulate([cluster1_data, cluster2_data, total_data], headers=headers)
    print(benchmark)
