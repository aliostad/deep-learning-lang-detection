$ErrorActionPreference = "Stop"

## Start the Docker Service if not already running
#Start-Service Docker -ErrorAction Continue

Push-Location $PSScriptRoot

# Using the TCP endpoint avoids having to run PowerShell as Administrator.
$env:DOCKER_HOST = "127.0.0.1:2375"

function RemoveContainers(){
    # stop and remove all containers
    if ((docker ps -a -q) -ne $null){
        Write-Output "Stopping and removing the following containers:"
        docker ps -a

        docker stop $(docker ps -a -q)
        docker rm $(docker ps -a -q)
    }
}

# Build and run containers in a docker-compose stylee

# build camdan/api
Write-Host "docker build -t camdan/api:$env:BUILD_BUILDNUMBER .\api"
docker build -t camdan/api:$env:BUILD_BUILDNUMBER .\api

# build camdan/web
Write-Host "docker build -t camdan/web:$env:BUILD_BUILDNUMBER .\web"
docker build -t camdan/web:$env:BUILD_BUILDNUMBER .\web

RemoveContainers

# hostport:containerport
# run API on port 5000
$apiname = [guid]::NewGuid().ToString('N')
Write-Output "docker run --name $apiname -d -t -p 5000:80 camdan/api:$env:BUILD_BUILDNUMBER"
docker run --name $apiname -d -t -p 5000:80 camdan/api:$env:BUILD_BUILDNUMBER

# run Web on port 80
$webname = [guid]::NewGuid().ToString('N')
Write-Output "docker run --name $webname -d -t -p 80:3000 camdan/web:$env:BUILD_BUILDNUMBER"
docker run --name $webname -d -t -p 80:3000 camdan/web:$env:BUILD_BUILDNUMBER

Write-Output "docker images"
docker images

Write-Output "docker ps -a"
docker ps -a

Pop-Location
