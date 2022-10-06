import boto3
import os
import sys
from datetime import timedelta, datetime
from tabulate import tabulate

cloudwatch_client = boto3.client('cloudwatch', 'us-east-1')

def handler(metricname, targetgrouparn, lbarn):
    result = access_last_data_metric(metricname, targetgrouparn, lbarn)
    return result

def access_last_data_metric(metricname, targetGroup, loadBalancer):
    start = datetime.utcnow() - timedelta(minutes = 15)
    end = datetime.utcnow()
    if 'REQUESTS_START' in os.environ:
        start = datetime.utcfromtimestamp(int(os.environ['REQUESTS_START']))

    print(end - start)
    response = cloudwatch_client.get_metric_data(
        MetricDataQueries=[
            {
                'Id': 'myrequest',
                'MetricStat': {
                    'Metric': {
                        'Namespace': 'AWS/ApplicationELB',
                        'MetricName': metricname,
                        'Dimensions': [
                            {
                                'Name': 'TargetGroup',
                                'Value': targetGroup
                            },
                            {                        
                                'Name': 'LoadBalancer',
                                'Value': loadBalancer
                            },
                        ]
                    },
                    'Period': 60,
                    'Stat': 'Average' if metricname == 'TargetResponseTime' else 'Sum',
                    'Unit': 'Seconds' if metricname == 'TargetResponseTime' else 'Count'
                }
            },
        ],
        StartTime=start,
        EndTime=end
    )
    return sum(response['MetricDataResults'][0]['Values'])

if __name__ == "__main__":

    lb = os.popen('terraform output --raw lb_arn_suffix').read()
    cluster1 = os.popen('terraform output --raw cluster1_arn_suffix').read()
    cluster2 = os.popen('terraform output --raw cluster2_arn_suffix').read()

    metricNames = ['RequestCount', 'TargetResponseTime', 'HTTPCode_Target_2XX_Count', 'HTTPCode_Target_4XX_Count']
    headers = ['Target', 'Request count', 'Average response time (s)', 'Status 2XX', 'Status 4XX']
    cluster1_data = ['Cluster1']
    cluster2_data = ['Cluster2']
    total_data = ['Total']



    for metric in metricNames:
        cluster1_data.append(handler(metric, cluster1, lb))
        cluster2_data.append(handler(metric, cluster2, lb))

    total_data.append(cluster1_data[1] + cluster2_data[1])
    total_data.append((cluster1_data[2] + cluster2_data[2])/2)
    total_data.append(cluster1_data[3] + cluster2_data[3])
    total_data.append(cluster1_data[4] + cluster2_data[4])

    benchmark = tabulate([cluster1_data, cluster2_data, total_data], headers=headers)
    print(benchmark)

    if 'BENCHMARK_START' in os.environ:
        print('total run time (s): ' + str((datetime.utcnow() - datetime.utcfromtimestamp(int(os.environ['REQUESTS_START']))).total_seconds()))
