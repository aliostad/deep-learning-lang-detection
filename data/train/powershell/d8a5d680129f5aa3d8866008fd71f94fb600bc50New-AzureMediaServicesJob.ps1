function New-AzureMediaServicesJob {
    <#
    .Synopsis
    Creates a new Azure Media Services processing job.

    .Parameter Name
    The name of the new Azure Media Services job that will be created.

    .Parameter Priority
    The priority of the new Azure Media Services job that will be created. The Microsoft
    Azure documentation does not state the valid values for this.

    .Parameter Context
    The Azure Media Services context that will be used to create the new job. If you do not
    have a context, you can use the Get-AzureMediaServicesContext command to get one.
    #>
    [CmdletBinding()]
    [OutputType([Microsoft.WindowsAzure.MediaServices.Client.IJob])]
    param (
        [Parameter(Mandatory = $true, ParameterSetName = 'ByName')]
        [Parameter(Mandatory = $true, ParameterSetName = 'SaveAsTemplate')]
        [string] $Name
       ,[Parameter(Mandatory = $true, ParameterSetName = 'ByName')]
        [Parameter(Mandatory = $true, ParameterSetName = 'SaveAsTemplate')]
        [Microsoft.WindowsAzure.MediaServices.Client.CloudMediaContext] $Context
       ,[Parameter(Mandatory = $false, ParameterSetName = 'ByName')]
        [Parameter(Mandatory = $false, ParameterSetName = 'SaveAsTemplate')]
        [UInt32] $Priority = 1
       ,[Parameter(Mandatory = $true, ParameterSetName = 'FromTemplate')]
        [Microsoft.WindowsAzure.MediaServices.Client.IJobTemplate] $Template
       ,[Parameter(Mandatory = $true, ParameterSetName = 'FromTemplate')]
        [switch] $FromTemplate
       ,[Parameter(Mandatory = $true, ParameterSetName = 'SaveAsTemplate')]
        [switch] $SaveAsTemplate
       ,[Parameter(Mandatory = $true, ParameterSetName = 'SaveAsTemplate')]
        [string] $TemplateName
       ,[Microsoft.WindowsAzure.MediaServices.Client.IAsset[]] $Asset
    )

    # Create the Azure Media Services job, from the CloudMediaContext object
    if ($PSCmdlet.ParameterSetName -eq 'ByName') {
        $Job = $Context.Jobs.Create($Name, $Priority);
    }
    
    # Save the job as a template, if parameter is specified
    if ($PSCmdlet.ParameterSetName -eq 'SaveAsTemplate') {
        $Job.SaveAsTemplate($TemplateName);
    }

    $TaskCollectionProperty = { ([Microsoft.WindowsAzure.MediaServices.Client.IJob]$this).get_Tasks(); };
    Add-Member -MemberType ScriptProperty -InputObject $Job -Name TaskCollection -Value $TaskCollectionProperty;

    return $Job;
}