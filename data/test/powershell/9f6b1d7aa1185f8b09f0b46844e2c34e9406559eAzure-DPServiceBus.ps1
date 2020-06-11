<#
.DESCRIPTION
A library of Azure Service Bus support calls with common specific values
#>

#some common constants
$defaultAzureRegion = "Australia East" #you could also try West Europe, East Asia


function Ensure-DPServiceBusDll {
    <#
    .DESCRIPTION
    Load the Azure dll to give us more granular Azure operations than just the issue Azure Powershells
    #>
    $dll = "Microsoft.ServiceBus.dll"
    $dllLocationSubFolder = "ServiceBusDll"
    #msdn docs on the servicebus namespace
    #https://msdn.microsoft.com/library/azure/microsoft.servicebus.aspx?f=255&MSPPError=-2147217396
    try
    {
        Write-Output "Adding the $dll assembly to the script..."
        
        $packagesFolder = Join-Path -Path $PSScriptRoot -ChildPath $dllLocationSubFolder
		if (-not (Test-Path -Path $packagesFolder)) {
			Write-Error "Ensure-DPServiceBusDll: Could not locate packages folder: $packagesFolder"
			exit(1)
		}

        $assembly = Get-ChildItem $packagesFolder -Include $dll -Recurse
		if (-not($assembly)) {
			Write-Error "Could not locate $dll at $packagesFolder"
			exit(1)
		}
        Add-Type -Path $assembly.FullName

        Write-Output "The $dll assembly has been successfully added to the script."
        $True
    }
    catch [System.Exception]
    {
        Write-Error "Could not add the $dll assembly to the script."
		Write-Error "Exception message: $_.Exception.Message"
        $False
		exit (1)
    }
}


function Get-DPServiceBusConnectionString {
    <#
    .DESCRIPTION
    Just return the connectionstring for use in subscriptions and creating clients
    #>
    [CmdletBinding()]
    param($serviceBusNamespace)
    $ns = Get-AzureSBNamespace -Name $serviceBusNamespace
    $ns.ConnectionString
}

function Create-DPServiceBusSASKey {
    <#
    .DESCRIPTION
    Create or get an SAS key against the service bus and return its key for use with clients
    .PARAMETER serviceBusNamespace
    The name of your service bus
    .PARAMETER ruleName
    The name to give your rule
    .PARAMETER permission
    list of permissions, eg $("Manage", "Listen", "Send")
    or $("Listen", "Send")
    or $("Listen")

    .EXAMPLE
    New-AzureSBAuthorizationRule -Name "MyRule" -Namespace $AzureSBNameSpace 
      -Permission $("Manage", "Listen", "Send") -EntityName $QName -EntityType Queue

    .NOTES
    New-AzureSBAuthorizationRule works only when I creating a namespace level SAS policy. 
    Using -EntityName and -EntityType params creating an entity level SAS policy gives 
    an object reference not set error. 
    Bug in the MS Powershell cmdlet - so just create at ServiceBus level (meh).
    #>
    [CmdletBinding()]
    param($serviceBusNamespace, $ruleName, $permission=$("Manage", "Listen", "Send"))

    #if it already exists, we just return it
    $ruleDetails = Get-AzureSBAuthorizationRule -Namespace $serviceBusNamespace | ? { $_.Name -eq $ruleName}
    if ($ruleDetails) {
        Write-Verbose "$ruleName already exists - just returning the existing connectionstring"
        $ruleDetails.ConnectionString
        return
    }

    $ruleDetails = New-AzureSBAuthorizationRule -Name $ruleName -Namespace $serviceBusNamespace -Permission $permission 
    
    $ruleDetails.ConnectionString
}

function Select-DPServiceBus {
	<#
    .DESCRIPTION
    Create the service bus. Default is to create in Australia East region. Some other regions are: West Europe, East Asia
    .PARAMETER force
    should the service bus be created if it does not already exist
    #>
    [CmdletBinding()]
    param($location = $defaultAzureRegion, $serviceBusNamespace, [switch] $force)
	$ns = Get-AzureSBNamespace -Name $serviceBusNamespace

    if ($ns) {
        $ns
        return
    }

	if (-not $ns -and $force) {
		Write-Output "Service Bus namespace $serviceBusNamespace does not already exist, forcing creation"
		Write-Output "Creating the [$serviceBusNamespace] namespace in the [$Location] region..."
	    New-AzureSBNamespace -Name $serviceBusNamespace -Location $Location -CreateACSNamespace $false -NamespaceType Messaging
	    $ns = Get-AzureSBNamespace -Name $serviceBusNamespace
	    Write-Verbose "The [$serviceBusNamespace] namespace in the [$Location] region has been successfully created."
	}

	$ns
}

function Create-DPSbTopic {
    [CmdletBinding()]
	param($serviceBusNamespace, $topicName, $defaultMessageTimeToLiveMinutes = 10, [switch] $forceRecreate)

    $t = Ensure-DPServiceBusDll
    if (-not $t) {
        Write-Error "Could not ensure the service bus dll was loaded. Stopping"
        return
    }


    $ns = Select-DPServiceBus -serviceBusNamespace $serviceBusNamespace -force
    if (-not $ns) {
        Write-Error "Could not select the Service Bus $serviceBusNamespace. Stopping."
        return
    }
    $nsManager = [Microsoft.ServiceBus.NamespaceManager]::CreateFromConnectionString($ns.ConnectionString);
	
    if ($nsManager.TopicExists($topicName))
    {
        Write-Output "The $topicName topic already exists in the $serviceBusNamespace namespace." 
        if ($forceRecreate) {
            #flush the existing and go on
            Write-Verbose "Flushing existing as you said forceRecreate"
            $nsManager.DeleteTopic($topicName)
            Write-Verbose "Deleted existing Topic $topicName"
        }
        else {
            return
        }
    }

    Write-Output "Creating $topicName Topic in the $serviceBusNamespace namespace"
    $topicDescription = (New-Object -TypeName Microsoft.ServiceBus.Messaging.TopicDescription -ArgumentList $topicName)
    if ($defaultMessageTimeToLiveMinutes) {
        $topicDescription.DefaultMessageTimeToLive = [System.TimeSpan]::FromMinutes($defaultMessageTimeToLiveMinutes)
    }
  
    $nsManager.CreateTopic($topicDescription);
    Write-Verbose "Created $topicName Topic in the $serviceBusNamespace namespace"
}

function Create-DPSbSubscription {
	[CmdletBinding()]
    param($serviceBusNamespace, 
		$topicName, 
		$subscriptionName, 
		$messageTimeToLiveMinutes,
		$sqlFilter,
		[switch] $force
	)

    $t = Ensure-DPServiceBusDll
    if (-not $t) {
        Write-Error "Could not ensure the service bus dll was loaded. Stopping"
        exit (1)
    }

    $ns = Select-DPServiceBus -serviceBusNamespace $serviceBusNamespace -force
    if (-not $ns) {
        Write-Error "Could not select the Service Bus $serviceBusNamespace. Stopping."
        return
    }

    $nsManager = [Microsoft.ServiceBus.NamespaceManager]::CreateFromConnectionString($ns.ConnectionString);

    if ($nsManager.SubscriptionExists($topicName, $subscriptionName)) {
        Write-Verbose "Subscription $subscriptionName already exists on Topic $topicName."
		if (-not ($force)) {
			return
		}
        Write-Verbose "but you said to force it, so I will remove the existing and re-create it"
		$nsManager.DeleteSubscription($topicName, $subscriptionName)
		Write-Verbose "existing subscription deleted."
    }

	if ($sqlFilter) {
		Write-Verbose "creating a filter for the subscription as: $sqlFilter"
		$filterObject = (New-Object -TypeName Microsoft.ServiceBus.Messaging.SqlFilter -ArgumentList $sqlFilter)

		$ruleDescription = (New-Object -TypeName Microsoft.ServiceBus.Messaging.RuleDescription -ArgumentList $filterObject)

		$subDescription = $nsManager.CreateSubscription($topicName, $subscriptionName, $ruleDescription)

		if ($messageTimeToLiveMinutes) {
			$subDescription.DefaultMessageTimeToLive = [System.TimeSpan]::FromMinutes($messageTimeToLiveMinutes)
		}
	}
	else {
		$subDescription = (New-Object -TypeName Microsoft.ServiceBus.Messaging.SubscriptionDescription -ArgumentList $topicName, $subscriptionName)

		if ($messageTimeToLiveMinutes) {
			$subDescription.DefaultMessageTimeToLive = [System.TimeSpan]::FromMinutes($messageTimeToLiveMinutes)
		}

		$nsManager.CreateSubscription($subDescription)
	}


    #$nsManager.CreateSubscription($topicName, $subscriptionName) #for creating a simple subscription

    Write-Verbose "Subscription $subscriptionName created on Topic $topicName"
}


function DPTestit {
    #just a quick test so you do not have to type the whole command
    Create-DPSbTopic -serviceBusNamespace 'realtime-preprod' -topicName 'tester1' -defaultMessageTimeToLiveMinutes 10
    #create a subscription on that topic
    Create-DPSbSubscription -serviceBusNamespace 'realtime-preprod' -topicName 'tester1' `
        -subscriptionName 'TestSub1' -messageTimeToLiveMinutes 10
}
