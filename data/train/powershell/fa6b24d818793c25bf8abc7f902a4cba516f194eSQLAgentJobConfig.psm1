<#
.SYNOPSIS
	Get all SQL Agent Job Owners

.PARAMETER SQLServer
    Name of the SQL Server
#>
function Get-SQLAgentJobOwner
{
    [cmdletbinding()]
    param (
        [Parameter(Mandatory=$true)][string]$SQLServer
    )

    # Load SMO Assembly
    [System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.Smo") | Out-Null;

    $SQLObj = New-Object "Microsoft.SqlServer.Management.Smo.Server" $SQLServer
    $SQLObj.ConnectionContext.Connect()
    $Jobs = $SQLObj.JobServer.Jobs
    $Jobs | Select-Object OriginatingServer,Name,OwnerLoginName
}

<#
.SYNOPSIS
	Set SQL Agent Job Owners

.PARAMETER SQLServer
    Name of the SQL Server

.PARAMETER OwnerName
    SQL Agent Job owner login name
#>
function Set-SQLAgentJobOwner
{
    [cmdletbinding()]
    param (
        [Parameter(Mandatory=$true)][string]$SQLServer ,
        [string]$OwnerName = 'sa'
    )

    # Load SMO Assembly
    [System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.Smo") | Out-Null;

    $SQLObj = New-Object "Microsoft.SqlServer.Management.Smo.Server" $SQLServer
    $SQLObj.ConnectionContext.Connect()
    $Jobs = $SQLObj.JobServer.Jobs

    foreach ($Job in $Jobs) { 
        $Job.OwnerLoginName = $OwnerName
        $Job.Alter()
    }
}

<#
.SYNOPSIS
	Get the SQL Server Agent job output name and location for all job steps

.PARAMETER SQLServer
    Name of the SQL Server
#>
function Get-SQLAgentJobOutputFile {
    [cmdletbinding()]
    param (
        [Parameter(Mandatory=$true)][string]$SQLServer
    )

    # Load SMO Assembly
    [System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.Smo") | Out-Null;

    $SQLObj = New-Object "Microsoft.SqlServer.Management.Smo.Server" $SQLServer
    $SQLObj.ConnectionContext.Connect()
    $JobSteps = $SQLObj.JobServer.Jobs.JobSteps

    # Display the Steps and the Output Locations
    $JobSteps | Select-Object @{Label='SQLServer';Expression={$SQLServer.ToUpper()}},Name,OutputFileName,JobStepFlags
}

<#
.SYNOPSIS
	Set the SQL Server Agent job output name and location

.PARAMETER SQLServer
    Name of the SQL Server

.PARAMETER SQLAgentOutputLocation
    Desired SQL Agent Job output location
#>
function Set-SQLAgentJobOutputFile {
    [cmdletbinding()]
    param (
        [Parameter(Mandatory=$true)][string]$SQLServer ,
        [Parameter(Mandatory=$true)][string]$SQLAgentOutputLocation 
    )

    # Create the $SQLAgentOutputLocation if it doesn't exist
    if (!(Test-Path -Path $SQLAgentOutputLocation -PathType Container)) {
        New-Item -Path $SQLAgentOutputLocation -ItemType Directory -Force
    }

    # Load SMO Assembly
    [System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.Smo") | Out-Null;

    $SQLObj = New-Object "Microsoft.SqlServer.Management.Smo.Server" $SQLServer
    $SQLObj.ConnectionContext.Connect()
    $JobSteps = $SQLObj.JobServer.Jobs.JobSteps

    # Set the OutputFileName for each job step
    foreach ($Step in $JobSteps) {
        $JobName = ($Step.Parent.Name).Replace(" ","")
        $StepOutFile = "${SQLAgentOutputLocation}\${JobName}" + '_Step$(ESCAPE_SQUOTE(STEPID))_$(ESCAPE_SQUOTE(STRTDT)).txt'
    
        $Step.OutputFileName = $StepOutFile
        $Step.JobStepFlags = "AppendToLogFile"
        $Step.Alter()
    }
}

<#
.SYNOPSIS
	Get all SQL Agent Jobs CompletionAction

.PARAMETER SQLServer
    Name of the SQL Server
#>
function Get-SQLAgentJobCompletionAction
{
    [cmdletbinding()]
    param (
        [Parameter(Mandatory=$true)][string]$SQLServer = "LOCALHOST"
    )

    # Load SMO Assembly
    [System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.Smo") | Out-Null;

    $SQLObj = New-Object "Microsoft.SqlServer.Management.Smo.Server" $SQLServer
    $SQLObj.ConnectionContext.Connect()
    $Jobs = $SQLObj.JobServer.Jobs

    # Display the Jobs and the new EventLogLevel
    $Jobs | Select-Object OriginatingServer,Name,EventLogLevel
}

<#
.SYNOPSIS
	Set all SQL Agent Jobs CompletionAction

.PARAMETER SQLServer
    Name of the SQL Server

.PARAMETER CompletionAction
    SQL Agent Job Completion Action. Default is OnFailure.
#>
function Set-SQLAgentJobCompletionAction
{
    [cmdletbinding()]
    param (
        [Parameter(Mandatory=$true)][string]$SQLServer ,
        [ValidateSet('Always','Never','OnFailure','OnSuccess')][string]$CompletionAction  = 'OnFailure'
    )

    # Load SMO Assembly
    [System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.Smo") | Out-Null;

    $SQLObj = New-Object "Microsoft.SqlServer.Management.Smo.Server" $SQLServer
    $SQLObj.ConnectionContext.Connect()
    $Jobs = $SQLObj.JobServer.Jobs

    foreach ($Job in $Jobs) { 
        $Job.EventLogLevel = [Microsoft.SqlServer.Management.Smo.Agent.CompletionAction]::$CompletionAction
        $Job.Alter()
    }
}