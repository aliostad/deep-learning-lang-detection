module OctopusSamples

[<Literal>]
let OctopusProjectListSample = """
{
"ItemType": "Project",
"IsStale": false,
"TotalResults": 13,
"ItemsPerPage": 30,
"Items": [
    {
    "Id": "projects-161",
    "VariableSetId": "variableset-projects-161",
    "DeploymentProcessId": "deploymentprocess-projects-161",
    "IncludedLibraryVariableSetIds": [],
    "DefaultToSkipIfAlreadyInstalled": false,
    "VersioningStrategy": {
        "DonorPackageStepId": null,
        "Template": "#{Octopus.Version.LastMajor}.#{Octopus.Version.LastMinor}.#{Octopus.Version.NextPatch}"
    },
    "ReleaseCreationStrategy": {
        "ReleaseCreationPackageStepId": ""
    },
    "Name": "Certificates",
    "Slug": "certificates",
    "Description": "",
    "IsDisabled": false,
    "ProjectGroupId": "ProjectGroups-33",
    "LifecycleId": "lifecycles-97",
    "AutoCreateRelease": false,
    "LastModifiedOn": "2015-12-10T12:49:05.153+00:00",
    "LastModifiedBy": "someone@example.com",
    "Links": {
        "Self": "/api/projects/projects-161",
        "Releases": "/api/projects/projects-161/releases{/version}{?skip}",
        "Variables": "/api/variables/variableset-projects-161",
        "Progression": "/api/progression/projects-161",
        "DeploymentProcess": "/api/deploymentprocesses/deploymentprocess-projects-161",
        "Web": "/app#/projects/projects-161",
        "Logo": "/api/projects/projects-161/logo"
    }
    }
]
}
"""

[<Literal>]
let OctopusProjectSample = """
{
    "Environments": [
    {
        "Id": "Environments-97",
        "Name": "DEV"
    }
    ],
    "Releases": [
    {
        "Release": {
        "Id": "releases-4492",
        "Assembled": "2016-09-28T11:35:00.340+00:00",
        "ReleaseNotes": null,
        "ProjectId": "projects-481",
        "ProjectVariableSetSnapshotId": "variableset-projects-481-snapshot-13",
        "LibraryVariableSetSnapshotIds": [],
        "ProjectDeploymentProcessSnapshotId": "deploymentprocess-projects-481-snapshot-5",
        "SelectedPackages": [
            {
            "StepName": "Deploy web HTTPS",
            "Version": "1.0.105"
            },
            {
            "StepName": "Deploy web HTTP",
            "Version": "1.0.105"
            }
        ],
        "Version": "1.0.105",
        "Links": {
            "Self": "/api/releases/releases-4492",
            "Project": "/api/projects/projects-481",
            "Progression": "/api/releases/releases-4492/progression",
            "Deployments": "/api/releases/releases-4492/deployments",
            "DeploymentTemplate": "/api/releases/releases-4492/deployments/template",
            "Artifacts": "/api/artifacts?regarding=releases-4492",
            "ProjectVariableSnapshot": "/api/variables/variableset-projects-481-snapshot-13",
            "ProjectDeploymentProcessSnapshot": "/api/deploymentprocesses/deploymentprocess-projects-481-snapshot-5",
            "Web": "/app#/releases/releases-4492",
            "SnapshotVariables": "/api/releases/releases-4492/snapshot-variables",
            "Defects": "/api/releases/releases-4492/defects",
            "ReportDefect": "/api/releases/releases-4492/defects",
            "ResolveDefect": "/api/releases/releases-4492/defects/resolve"
        }
        },
        "Deployments": {
            "Environments-28": [
                {
                    "Id": "Deployments-2680",
                    "ProjectId": "Projects-10",
                    "EnvironmentId": "Environments-28",
                    "ReleaseId": "Releases-1274",
                    "DeploymentId": "Deployments-2680",
                    "TaskId": "ServerTasks-3006",
                    "TenantId": null,
                    "ChannelId": null,
                    "ReleaseVersion": "1.0.3949",
                    "Created": "2017-06-02T06:15:27.873+00:00",
                    "QueueTime": "2017-06-02T06:15:27.857+00:00",
                    "CompletedTime": "2017-06-02T06:23:23.571+00:00",
                    "State": "Success",
                    "HasPendingInterruptions": false,
                    "HasWarningsOrErrors": false,
                    "ErrorMessage": "",
                    "Duration": "8 minutes",
                    "IsCurrent": false,
                    "IsPrevious": false,
                    "IsCompleted": true,
                    "Links": {
                        "Self": "/api/deployments/Deployments-2680",
                        "Release": "/api/releases/Releases-1274",
                        "Tenant": "/api/tenants/",
                        "Task": "/api/tasks/ServerTasks-3006"
                    }
                }
            ],
            "Environments-29": [
                {
                    "Id": "Deployments-2693",
                    "ProjectId": "Projects-10",
                    "EnvironmentId": "Environments-29",
                    "ReleaseId": "Releases-1274",
                    "DeploymentId": "Deployments-2693",
                    "TaskId": "ServerTasks-3019",
                    "TenantId": null,
                    "ChannelId": null,
                    "ReleaseVersion": "1.0.3949",
                    "Created": "2017-06-02T21:34:43.902+00:00",
                    "QueueTime": "2017-06-02T21:34:43.887+00:00",
                    "CompletedTime": "2017-06-02T21:40:38.126+00:00",
                    "State": "Success",
                    "HasPendingInterruptions": false,
                    "HasWarningsOrErrors": false,
                    "ErrorMessage": "",
                    "Duration": "6 minutes",
                    "IsCurrent": false,
                    "IsPrevious": false,
                    "IsCompleted": true,
                    "Links": {
                        "Self": "/api/deployments/Deployments-2693",
                        "Release": "/api/releases/Releases-1274",
                        "Tenant": "/api/tenants/",
                        "Task": "/api/tasks/ServerTasks-3019"
                    }
                }
            ]
        },
        "NextDeployments": [
        "Environments-33",
        "Environments-129",
        "Environments-65"
        ],
        "HasUnresolvedDefect": false,
        "ReleaseRetentionPeriod": null,
        "TentacleRetentionPeriod": null
    }
    ]
}
"""
