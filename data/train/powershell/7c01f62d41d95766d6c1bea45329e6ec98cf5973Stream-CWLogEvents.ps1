<#
.SYNOPSIS
Invokes the PutLogEvents operation. Unlike the standard Write-CWLogEvents, Stream-CWLogEvents accepts a string and will manage the SequenceToken for you.

.DESCRIPTION
Uploads events to CloudWatch logs. There no need to manage the sequence token.  This CmdLet will look up the SequenceToken before publishing. Events are of type string and will be truncated if longer than 4K characters.  You can send individual events or pipe data to create a series of events.  Events will be uploaded in batches of 100 events. You cannot specify a timestamp for events, it always uses the current date and time.  

.PARAMETER LogEvent
A string or array of strings that will become CloudWatch Log Events.

.PARAMETER LogGroupName
The name of the CloudWatch log group to put log events to.

.PARAMETER LogStreamName
The name of the CloudWatch log stream to put log events to.

.PARAMETER AccessKey
An IAM Access Key with permission to write to CloudWatch Logs.

.PARAMETER SecretKey
The Secret Key corresponding to the IAM Access Key with permission to write to CloudWatch Logs.

.PARAMETER Region
The AWS region to upload logs events to (e.g. us-east-1).

.EXAMPLE
Stream-CWLogEvents -LogGroupName MyGroupName -LogStreamName MyStreamName -Event "Logs From PowerShell"
Uploads a batch with a single event.
.EXAMPLE
Stream-CWLogEvents -LogGroupName MyGroupName -LogStreamName MyStreamName -Event "Event1", "Event2"
Uploads a batch of two events.
.EXAMPLE
Get-Content .\SomeFile.txt | Stream-CWLogEvents -LogGroupName MyGroupName -LogStreamName MyStreamName
Uploads the the content received from the pipeline in batches of 100 events.  
#>
Function Stream-CWLogEvents {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$True,ValueFromPipeline=$True,ValueFromPipelinebyPropertyName=$True)][string[]]$LogEvent,
        [Parameter(Mandatory=$True)][string]$LogGroupName,
        [Parameter(Mandatory=$True)][string]$LogStreamName,
        [Parameter(Mandatory=$False)][string]$AccessKey,
        [Parameter(Mandatory=$False)][string]$SecretKey,
        [Parameter(Mandatory=$False)][string]$Region = (Get-DefaultAWSRegion).Region
    )
    BEGIN {
        $NoEcho = [System.Reflection.Assembly]::LoadFrom('C:\CloudWatch\CloudWatch\bin\Debug\CloudWatchLogs.dll')
        $CWLTraceListner = New-Object -TypeName BrianBeach.CloudWatchLogsTraceListener -ArgumentList @($LogGroupName, $LogStreamName, $Region, $AccessKey, $SecretKey, $true)
    }
    PROCESS {
        $LogEvent | % { $CWLTraceListner.WriteLine($_) }
    }
    END {
        $CWLTraceListner.Flush()
        $CWLTraceListner.Close()
    }
}
