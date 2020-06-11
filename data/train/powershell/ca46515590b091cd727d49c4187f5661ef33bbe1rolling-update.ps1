# Exit on any error
$ErrorActionPreference = "Stop"

# Get a tag for the build
$Tag = Read-Host -Prompt "Enter a unique tag for build"

# Build docker image
docker build -t gcr.io/slacker-157712/api:$Tag ../

# Push image to google cloud
gcloud docker push gcr.io/slacker-157712/api:$Tag

# Write rc-file
(Get-Content rc-file-template.yaml).Replace("{{tag}}", $Tag) | Set-Content rc-file.yaml 

# Get currently active replication controller
[regex]$regex = "(api-[a-zA-Z0-9\.-:]+)"

$ActiveReplicationControllers = kubectl get rc
$CurrentReplicationController = $regex.Matches($ActiveReplicationControllers) | % {$_.Value}

# Rolling update
kubectl rolling-update $CurrentReplicationController -f rc-file.yaml --update-period=10s --poll-interval=1s