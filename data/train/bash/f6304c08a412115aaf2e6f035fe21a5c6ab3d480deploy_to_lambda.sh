#!/bin/bash

set -e

function lambda_invoke {
  aws lambda invoke --function-name LambdaTest --payload "`cat data.json`" --qualifier PROD lambdaoutput.txt
  cat lambdaoutput.txt
  echo -e "\n"
}

cd /deploy

echo "Output before deployment"
lambda_invoke

# Change Printed Date in LambdaTest to show the difference between the deployed functions
sed -i.bu s/DATE/$RANDOM/ LambdaTest.js

# Preparing and deploying Function to Lambda
zip -r LambdaTest.zip LambdaTest.js
aws lambda update-function-code --function-name LambdaTest --zip-file fileb://LambdaTest.zip

# Publishing a new Version of the Lambda function
version=`aws lambda publish-version --function-name LambdaTest | jq -r .Version`

# Updating the PROD Lambda Alias so it points to the new function
aws lambda update-alias --function-name LambdaTest --function-version $version --name PROD

echo "Output after deployment"
lambda_invoke
