#!/bin/bash

execute_role='LambdaExecuteRole'
execute_policy='arn:aws:iam::aws:policy/AWSLambdaFullAccess'

aws iam create-role \
  --role-name $execute_role \
  --assume-role-policy-document file://iam/lambda-assumerole-policy.json

aws iam attach-role-policy \
  --role-name $execute_role \
  --policy-arn $execute_policy


s3_invoke_role='S3LambdaInvokeRole'
invoke_policy='arn:aws:iam::aws:policy/service-role/AWSLambdaRole'
aws iam create-role \
  --role-name $s3_invoke_role \
  --assume-role-policy-document file://iam/s3-assumerole-policy.json

aws iam attach-role-policy \
  --role-name $s3_invoke_role \
  --policy-arn $invoke_policy

kinesis_invoke_role='KinesisLambdaInvokeRole'
aws iam create-role \
  --role-name $kinesis_invoke_role \
  --assume-role-policy-document file://iam/s3-assumerole-policy.json

aws iam attach-role-policy \
  --role-name $kinesis_invoke_role \
  --policy-arn $invoke_policy

