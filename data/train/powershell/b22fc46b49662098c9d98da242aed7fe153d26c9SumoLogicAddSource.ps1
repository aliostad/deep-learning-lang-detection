function Add-Source
{
$credential = Get-Credential

#First you need to get a list of collectors

$JSONCollectors = Invoke-WebRequest -Uri https://api.sumologic.com/api/v1/collectors -Credential $credential

#Convert the list of collectors to a PoSH object from JSON

$JSONObject = $JSONCollectors.Content | ConvertFrom-Json

#Get the href for the REST endpoint for the collector's sources by collector name

$myid = $JSONObject.collectors | ?{$_.Name -eq "ord-log-01"}
$endurl = $myid.links.href
$sources = "https://api.sumologic.com/api$endurl"

#This is testing to get the list of sources
$JSONSources = Invoke-WebRequest -Uri $sources -Credential $credential
$JSONSources.Content | fl
#write-host $JSONSources.Content

#$JSONNewSource = @{source = @{name="Dev_Three API - IAD-WEB-01";category="Development_IIS";hostName="IAD-WEB-01";pathExpression="\\IAD-WEB-01\c$\\Web\dev_three\Logs\API\*.txt";sourceType="LocalFile"}} | ConvertTo-Json

#$myheaders = @{"Content-Type"="application/json"}

#Invoke-WebRequest -Uri $sources -Body $JSONNewSource -Method Post -Headers @{"Content-Type"="application/json"} -Credential $credential

#$JSONConvert = Get-Content 'C:\code\working\NewPSObjectSource.txt'| ConvertTo-Json -Depth 30

#Invoke-WebRequest -Uri $sources -Body $JSONConvert -Method Post -Headers @{"Content-Type"="application/json"} -Credential $credential
}

function Get-AllSourceByCollector
{

    [CmdletBinding()]
    [OutputType([string])]
    Param
    (
        # Param1 help description
        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true,
                   ValueFromPipeline=$true,
                   Position=0)]
        $SumoCollectorName

    )

    $credential = Get-Credential

    #First you need to get a list of collectors

    $JSONCollectors = Invoke-WebRequest -Uri https://api.sumologic.com/api/v1/collectors -Credential $credential

    #Convert the list of collectors to a PoSH object from JSON

    $JSONObject = $JSONCollectors.Content | ConvertFrom-Json

    #Get the href for the REST endpoint for the collector's sources by collector name

    $myid = $JSONObject.collectors | ?{$_.Name -eq $SumoCollectorName}
    $endurl = $myid.links.href
    $sources = "https://api.sumologic.com/api$endurl"

    #This is testing to get the list of sources
    $JSONSources = Invoke-WebRequest -Uri $sources -Credential $credential
    $SumoSourcesByName = $JSONSources.Content | ConvertFrom-Json
    foreach($Source in $SumoSourcesByName.sources)
    {
        $sourcename = $Source.name
        $Prop = [PSObject][ordered]@{

                                        'SourceName'=$sourcename;
                                        'SourceID'=$source.id;
                                        ''='';


                                    }
        write-output $Prop
    }
    
}

function Get-SourceByID
{
     [CmdletBinding()]
    [OutputType([string])]
    Param
    (
        # Param1 help description
        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true,
                   ValueFromPipeline=$true,
                   Position=0)]
        $SumoCollectorName,
        # Param1 help description
        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true,
                   ValueFromPipeline=$true,
                   Position=1)]
        [string]$SumoSourceID
    )
    <#$SumoCollectorName = 'ord-log-01'
    $SumoSourceID = '133379606'#>
    if($credential)
    {
    }
    else
    {
        $credential = Get-Credential
    }

    #First you need to get a list of collectors

    $JSONCollectors = Invoke-WebRequest -Uri https://api.sumologic.com/api/v1/collectors -Credential $credential

    #Convert the list of collectors to a PoSH object from JSON

    $JSONObject = $JSONCollectors.Content | ConvertFrom-Json

    #Get the href for the REST endpoint for the collector's sources by collector name

    $myid = $JSONObject.collectors | ?{$_.name -eq $SumoCollectorName}
    $endurl = $myid.links.href
    $sources = "https://api.sumologic.com/api$endurl/$SumoSourceID"

    While ($Response -notmatch '^(Y|N)$')
    {
        $Response = Read-Host "Contacting URL $sources Do you wish to continue (y/n)?"
    }
    if($Response -ne "y")
    {
        Break
    }

    $JSONSources = Invoke-WebRequest -Uri $sources -Credential $credential
    $SumoSourcesByName = $JSONSources.Content | ConvertFrom-Json
    foreach($Source in $SumoSourcesByName.source)
    {
        #$sourcename = $Source.name
        [PSObject]$PropBag=@{}
        foreach($Prop in $source.psobject.Properties)
        {

        
            <#$Propbag = [PSObject][ordered]@{

                                            'SourceName'=$sourcename;
                                            'SourceID'=$source.id;
                                            ''='';
                                            $prop.name = $prop.Value}#>

            Add-Member -InputObject $PropBag -Name $prop.name -Value $prop.Value -MemberType $prop.MemberType
         
        }
        write-output $PropBag
        

    }

}

function Get-SourceByNameGetJSON
{
     [CmdletBinding()]
    [OutputType([string])]
    Param
    (
        # Param1 help description
        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true,
                   ValueFromPipeline=$true,
                   Position=0)]
        $SumoCollectorName,
        # Param2 help description
        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true,
                   ValueFromPipeline=$true,
                   Position=1)]
        [string]$SumoSourceName,
        # Param3 help description
        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true,
                   ValueFromPipeline=$true,
                   Position=2)]
        [string]$FileName,
        # Param4 help description
        [Parameter(Mandatory=$false,
                   ValueFromPipelineByPropertyName=$true,
                   ValueFromPipeline=$true,
                   Position=3)]
        [switch]$OverwriteFile



    )
    #$SumoCollectorName = 'ord-log-01'
    #$SumoSourceName = 'WM IIS - PCWEB-01'
    If(Test-Path $FileName)
    {
        If($OverwriteFile)
        {
            write-host "File $Filename will be overwritten."

        }
        else
        {
            write-host "File $Filename already exists and the OverwriteFile option was not selected.  Exiting...."
            break
        }
        
    }
    else
    {
        write-host "File $Filename will contain the JSON output."
    }



    [pscredential]$credential
    if($credential)
    {
    }
    else
    {
        $credential = Get-Credential
    }

    #First you need to get a list of collectors

    $JSONCollectors = Invoke-WebRequest -Uri https://api.sumologic.com/api/v1/collectors -Credential $credential

    #Convert the list of collectors to a PoSH object from JSON

    $JSONObject = $JSONCollectors.Content | ConvertFrom-Json

    #Get the href for the REST endpoint for the collector's sources by collector name

    $myid = $JSONObject.collectors | ?{$_.name -eq $SumoCollectorName}
    $endurl = $myid.links.href
    $sources = "https://api.sumologic.com/api$endurl"

    $JSONSources = Invoke-WebRequest -Uri $sources -Credential $credential
    $SumoSourcesByName = $JSONSources.Content | ConvertFrom-Json
    $sourceid = $SumoSourcesByName.sources | ?{$_.name -eq $SumoSourceName}
    $srcid = $sourceid.id
    $newURL = "$sources/$srcid"

    $JSONSource = Invoke-WebRequest -Uri $newURL -Credential $credential
    

    $JSONSource.Content | Out-File $FileName

}