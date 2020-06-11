param(
[Parameter(Mandatory=$true)]
[String]$ProjectName,
[Parameter(Mandatory=$true)]
[String]$API_Key
)

$project_slug = $ProjectName.Replace(".","-").ToLower()

function Replace-Placeholders {
    param([string]$json)
    $json = $json.Replace("%PROJECT_NAME%",$ProjectName)
    $json
}

function Update-OctopusProcess {
    param([string]$process_id)
    Write-Host "Updating deployment process $process_id"

    $response = Invoke-WebRequest -Uri "http://deploy.particular.net/api/deploymentprocesses/${process_id}?apiKey=${API_Key}" -Method Get
    $current_process = ConvertFrom-Json $response.Content
    $current_version = $current_process.Version

    $new_process_json = Get-Content "Octopus\DeploymentProcess.json" -Raw
    $new_version = $current_version
    $new_process_json = $new_process_json.Replace("%VERSION%",$new_version)
    $new_process_json = Replace-Placeholders $new_process_json
    $response = Invoke-WebRequest -Uri "http://deploy.particular.net/api/deploymentprocesses/${process_id}?apiKey=${API_Key}" -Body $new_process_json -Method Put
}

function New-OctopusProject {
    Write-Host "Creating a new project"

    $project_json = Get-Content "Octopus\Project.json" -Raw
    $project_json = Replace-Placeholders $project_json

    $response = Invoke-WebRequest -Uri "http://deploy.particular.net/api/projects?apiKey=${API_Key}" -Body $project_json -Method Post
    $response_object = ConvertFrom-Json $response.Content
    $project_id = $response_object.Id
    $process_id = $response_object.DeploymentProcessId

    Update-OctopusProcess $process_id
}

function Update-OctopusProject {
    param([string]$project_id)
    Write-Host "Updating existing project $project_id"

    $project_json = Get-Content "Octopus\Project.json"
    $project_json = Replace-Placeholders $project_json

    $response = Invoke-WebRequest -Uri "http://deploy.particular.net/api/projects/${project_id}?apiKey=${API_Key}" -Body $project_json -Method Put
    $response_object = ConvertFrom-Json $response.Content
    $project_id = $response_object.Id
    $process_id = $response_object.DeploymentProcessId

    Update-OctopusProcess $process_id
}

try {
    $response = Invoke-WebRequest -Uri "http://deploy.particular.net/api/projects/${project_slug}?apiKey=${API_Key}" -Method Get
}
catch 
{    
    $request = $_.Exception.Response 
    if ($request.StatusCode -eq 404) {
        New-OctopusProject
        return
    } else {
        throw "Error while contacting Octopus"
    }
} 
$project_object = ConvertFrom-Json $response.Content
$project_id = $project_object.Id
Update-OctopusProject $project_id