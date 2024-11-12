import boto3
import time

def lambda_handler(event, context):
    client = boto3.client('logs')
    cloudwatch = boto3.client('cloudwatch')

    # Replace with your specific log group name, start time, and end time
    log_group_name = '/aws/lambda/your-function-name'
    start_time = int(time.time()) - 300  # 5 minutes ago
    end_time = int(time.time())

    response = client.filter_log_events(
        logGroupName=log_group_name,
        startTime=start_time,
        endTime=end_time,
        filterPattern=''  # Adjust filter pattern if needed
    )

    log_count = len(response['events'])

    # Put metric data to CloudWatch
    cloudwatch.put_metric_data(
        Namespace='YourNamespace',
        MetricData=[
            {
                'MetricName': 'LogCount',
                'Dimensions': [
                    {'Name': 'ApplicationName', 'Value': 'YourApplication'},
                    {'Name': 'Environment', 'Value': 'Production'}
                ],
                'Value': log_count,
                'Unit': 'Count'
            }
        ]
    )