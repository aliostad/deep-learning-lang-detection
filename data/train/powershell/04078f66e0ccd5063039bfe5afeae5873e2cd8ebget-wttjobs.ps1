param($query, $path, $category)

# wtt global state
$wttPath = $env:WTTSTDIO
$identityDbName = "WTTIdentity"
$dataStoreName = "WindowsPhone_Blue"
$serverName = "WPCWTTBID01.redmond.corp.microsoft.com"

# load the assemblies we need
$asmBase = [Reflection.Assembly]::LoadFrom("$wttPath\WTTOMBase.dll")
$asmIdentity = [Reflection.Assembly]::LoadFrom("$wttPath\WTTOMIdentity.dll")
$asmJobs = [Reflection.Assembly]::LoadFrom("$wttPath\WTTOMJobs.dll")
$asmAsset = [Reflection.Assembly]::LoadFrom("$wttPath\WTTOMAsset.dll")
$asmResource = [Reflection.Assembly]::LoadFrom("$wttPath\WTTOMResource.dll")
$asmParameter = [Reflection.Assembly]::LoadFrom("$wttPath\WTTOMParameter.dll")

$typeJob = $asmJobs.GetType("Microsoft.DistributedAutomation.Jobs.Job")
$typeDSUser = $asmBase.GetType("Microsoft.DistributedAutomation.DSUser")
$typeMachine = $asmResource.GetType("Microsoft.DistributedAutomation.Asset.Resource")
$typeResourceConfig = $asmResource.GetType("Microsoft.DistributedAutomation.Asset.ResourceConfiguration")

function get-PathQuery
{
    param($path)
    
    $jobQuery = New-Object Microsoft.DistributedAutomation.Query $typeJob
    $jobQuery.AddExpression("FullPath", "BeginsWith", $path)
    
    $jobQuery
}

function get-NameQuery($name)
{
    $jobQuery = New-Object Microsoft.DistributedAutomation.Query $typeJob
    write-host $name
    $jobQuery.AddExpression("Name", "Equals", $name)
    
    $jobQuery
}

function get-CategoryQuery
{
    param($path)
    
    $jobQuery = New-Object Microsoft.DistributedAutomation.Query $typeJob
    $jobQuery.AddExpression("FullPath", "BeginsWith", $path)
    
    $jobQuery
}

function get-PsqQuery
{
    param($path)
    
    [void][Reflection.Assembly]::LoadFrom("$env:_WINPHONEROOT\src\tools\testinfra\product\wttmobile\wttexternal\studio\microsoft.wtt.ui.controls.objectcontrols.dll");
    [void][Reflection.Assembly]::LoadFrom("$env:PROGRAMFILES\WTT 2.2\Studio\Tools\TuxNetSuiteUpdater\WtqHelper.dll")
    
    #[void][Reflection.Assembly]::LoadFrom("$env:PROGRAMFILES\Texus\Shell\microsoft.wtt.ui.controls.objectcontrols.dll");
    #[void][Reflection.Assembly]::LoadFrom("$env:_WINPHONEROOT\developr\scyost\monad\wttsdk\wtqhelper.dll")
    

    $wtq = New-Object Microsoft.DistributedAutomation.Mobile.WtqHelper $path

    $query = $wtq.GetQuery( $dataStore, $typeJob );
    
    $query   
}


    # alias some common WTT types that we will use
    $conjunction = [Microsoft.DistributedAutomation.Conjunction]
    $enterprise = [Microsoft.DistributedAutomation.Enterprise]
    $jobsDefinitionDataStore = [Microsoft.DistributedAutomation.Jobs.JobsDefinitionDataStore]
    $queryOperator = [Microsoft.DistributedAutomation.QueryOperator]
    $sortDirection = [Microsoft.DistributedAutomation.SortDirection]
    
    # set up the connection string to the identity database
    $identityInfo = New-Object Microsoft.DistributedAutomation.SqlIdentityConnectInfo $serverName, $identityDbName
    
    write-progress -activity "getting jobs" -status "Connecting to datastore"
    $global:dataStore = $enterprise::Connect($dataStoreName,
        $jobsDefinitionDataStore::ServiceName,
        $identityInfo)
    
    if ($path)
    {
        $jobQuery = get-pathquery $path
    }
    elseif ($query)
    {
        $jobQuery = get-psqQuery $query
    }
    elseif ($name)
    {
        $jobQuery = get-nameQuery $name
    }
    
    # todo: don't execute the query if there were failures in the script
    write-progress -activity "getting jobs" -status "Executing Query"
    $jobs = $dataStore.Query($jobQuery)
    
    write-progress -activity "getting jobs" -status "Done"
    $jobs
