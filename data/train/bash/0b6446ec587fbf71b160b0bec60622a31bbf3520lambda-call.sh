#!/bin/bash

# Setup CloudWatch logging
wget https://s3.amazonaws.com/aws-cloudwatch/downloads/latest/awslogs-agent-setup.py
chmod +x ./awslogs-agent-setup.py

./awslogs-agent-setup.py -n -r us-east-1 -c s3://dev-9-automation/log_config

LOGFILE=/var/log/automation.log

# Used because lambda needs a --invoke-args to run
echo '{ "emtpy":"" }' > nothing.json

echo 'Calling AWS Clean functions' >> $LOGFILE
aws lambda --region=us-west-2 --function-name=awsCleanup --debug --invoke-args=nothing.json invoke-async >> $LOGFILE
