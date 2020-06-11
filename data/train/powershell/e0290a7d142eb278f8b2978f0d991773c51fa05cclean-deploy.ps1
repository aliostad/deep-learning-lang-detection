# Exit on any error
$ErrorActionPreference = "Stop"

# Get a tag for the build
$Tag = Read-Host -Prompt "Enter a unique tag for build"

# Build the image
docker build -t gcr.io/slacker-157712/api:$Tag ../

# Set google cloud project
gcloud config set project slacker-157712

# Create container cluster
gcloud container clusters create api --zone=europe-west1-b --machine-type=g1-small

# Push image to google cloud
gcloud docker push gcr.io/slacker-157712/api:$Tag

# Write rc-file
(Get-Content rc-file-template.yaml).Replace("{{tag}}", $Tag) | Set-Content rc-file.yaml 

# Create the replication controller
kubectl create -f rc-file.yaml

# Create the load balancer
kubectl create -f service-file.yaml
