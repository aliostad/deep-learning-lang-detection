function CreateEntityLogicApps{

	if($global:deleteRG){
		Remove-AzureRmResourceGroup -name  $global:ResourceGroupName
		ipconfig /flushdns
		Start-Sleep -s 10
	}
	$sub = Get-AzureRmSubscription -SubscriptionName $global:selectedsubscription
	$subId = $sub.SubscriptionId

	$global:CurrentServicePlanName = $global:ServicePlanName

	Replace ResourceGroupAndServicePlan.param.json ResourceGroupAndServicePlan1.param.json
	New-AzureRmResourceGroup -Name $global:ResourceGroupName -Location $global:ResourceGroupLocation -Force -Verbose	
	New-AzureRmResourceGroupDeployment -ResourceGroupName $global:ResourceGroupName -TemplateFile "$pwd\Templates\ResourceGroupAndServicePlan.json" -TemplateParameterFile "$pwd\Templates\ResourceGroupAndServicePlan1.Param.json" -Force -Verbose

	foreach($entitynode in $global:entitynodes){

		## inner logic app	
		$global:currentMicrosoftAccountEnabled = $entitynode.MicrosoftAccountEnabled
		$global:currentEntityName = $global:dbpkndict[$entitynode.EntityDBPK]
		$global:crmEntityName = $entitynode.Entity
		$global:currentCrmSecondPrimaryKey = $entitynode.EntitySK
		$global:currentMAP = $entitynode.MAP

		$global:currentHttpListenerApiAppName = ("HttpListener4" + $global:currentEntityName)		
		$global:currentCrmConnectorApiAppNameSite = ("crmconn4"+$global:currentEntityName+$global:appName+$global:environment)		
		$global:currentLogicAppName = ("LogicApp4CRMConnector" + $global:currentEntityName)

		# only support create here

		$rsql = $null
		$rsql = Get-AzureRmResource -ResourceGroupName $global:ResourceGroupName -ResourceType Microsoft.AppService/apiapps -ResourceName $global:currentHttpListenerApiAppName
		if($rsql){
			Write-Output ('remove http listener:'+$global:currentHttpListenerApiAppName)
			remove-azurermresource -resourceid $rsql.resourceid -Force
			Start-Sleep -s 10
			$rsql = $null
			$rsql = Get-AzureRmResource -ResourceGroupName $global:ResourceGroupName -ResourceType Microsoft.AppService/apiapps -ResourceName $global:currentHttpListenerApiAppName
			Write-Output 'after remove resource'
			Write-Output $rsql
		}
		
		if(!$rsql){ #create

			Write-Output ('Create LogicApp:'+$global:currentLogicAppName)
			
			#generate site name
			$ConnectorName = "HTTPListener"
			$ResourceIdPrefix = ("/subscriptions/" + $subId + "/resourcegroups/" + $global:ResourceGroupName)
			$ApiAppDeploymentTemplate = Invoke-AzureRmResourceAction -Action generate -ApiVersion "2015-03-01-preview" -Force -ResourceId ($ResourceIdPrefix + "/providers/Microsoft.AppService/deploymenttemplates") -Parameters @{ "hostingPlan" = @{ "hostingPlanName" = $global:ServicePlanName }; "packages" = @(@{ "id" = $ConnectorName }) }

			$JSONTemplateString = (ConvertTo-Json -InputObject $ApiAppDeploymentTemplate.Value -Depth 20) | Out-File -FilePath ".\Templates\Template_HttpListenerConnector.json"

			#get sitename & secret
			$httpconnector = (Get-Content -Raw -Path ".\Templates\Template_HttpListenerConnector.json" | ConvertFrom-Json)
			$httpconnectorVarList = $httpconnector.Variables.psobject.properties
			$httpconnectorValue = ($httpconnectorVarList | Where-Object {$_.name -Like "ApiApp*"}).Value
			$httpconnectorSitename = $httpconnectorValue.SiteName 
			$httpconnectorSecret = $httpconnectorValue.Secret
			$gatewayValue = ($httpconnectorVarList | Where-Object {$_.name -Like "Gateway*"}).Value
			$gatewayName = $gatewayValue.GatewayName
					
			$global:currentHttpListenerApiAppNameSite = $httpconnectorSitename
			$global:currentGatewayToApiAppSecret = $httpconnectorSecret
			$global:currentGatewayName = $gatewayName 

			
			Replace InnerLA.json InnerLA1.json
			Replace InnerLA.param.json InnerLA1.param.json
			New-AzureRmResourceGroupDeployment -ResourceGroupName $ResourceGroupName -TemplateFile "$pwd\Templates\InnerLA1.json" -TemplateParameterFile "$pwd\Templates\InnerLA1.param.json" -Force -Verbose

			$rsql = Get-AzureRmResource -ResourceGroupName $global:ResourceGroupName -ResourceType Microsoft.AppService/apiapps -ResourceName $global:currentHttpListenerApiAppName
		}
		$global:currentHttpListenerApiAppNameSite = $rsql.Properties.Host.ResourceName
		Write-Output 'httpconnector site name'
		Write-Output $global:currentHttpListenerApiAppNameSite
	
		## outter logic app
		$global:currentSqlConnectorName = ("SQLConn4" + $global:currentEntityName)	
		$global:currentLogicAppName = ("LogicApp4" + $global:currentEntityName)
		
		$rsql = $null
		$rsql = Get-AzureRmResource -ResourceGroupName $global:ResourceGroupName -ResourceType Microsoft.AppService/apiapps -ResourceName $global:currentSqlConnectorName	
		if(!$rsql){ #create
			Write-Output ('Create LogicApp:'+$global:currentLogicAppName)
			
			#generate site name
			$ConnectorName = "MicrosoftSqlConnector"
			$ResourceIdPrefix = "/subscriptions/" + $subId + "/resourcegroups/" + $global:ResourceGroupName 
			$ApiAppDeploymentTemplate = Invoke-AzureRmResourceAction -Action generate -ApiVersion "2015-03-01-preview" -Force -ResourceId ($ResourceIdPrefix + "/providers/Microsoft.AppService/deploymenttemplates") -Parameters @{ "hostingPlan" = @{ "hostingPlanName" = $global:ServicePlanName }; "packages" = @(@{ "id" = $ConnectorName }) }

			$JSONTemplateString = (ConvertTo-Json -InputObject $ApiAppDeploymentTemplate.Value -Depth 20) | Out-File -FilePath ".\Templates\Template_SqlConnector.json"

			#get sitename & secret
			$sqlconnector = (Get-Content -Raw -Path ".\Templates\Template_SqlConnector.json" | ConvertFrom-Json)
			$sqlconnectorVarList = $sqlconnector.Variables.psobject.properties
			$sqlconnectorValue = ($sqlconnectorVarList | Where-Object {$_.name -Like "ApiApp*"}).Value
			$sqlconnectorSitename = $sqlconnectorValue.SiteName 
			$gatewayValue = ($sqlconnectorVarList | Where-Object {$_.name -Like "Gateway*"}).Value
			$gatewayName = $gatewayValue.GatewayName
				
		}else{ #update
			Write-Output ('Update LogicApp:'+$LogicAppName)
			
			$sqlconnectorSitename = $rsql.Properties.Host.ResourceName
			$gatewayName = $rsql.Properties.Gateway.ResourceName
		}

		$global:currentSqlConnectorSiteName = $sqlconnectorSitename
		$global:currentGatewayName = $gatewayName
		$global:currentEntityDBPK = $entitynode.EntityDBPK
		$global:currentEntityDBGuidColumnName = $entitynode.EntityDBGuidColumnName

		Replace OutterLA.json OutterLA1.json
		Replace OutterLA.param.json OutterLA1.param.json
		New-AzureRmResourceGroupDeployment -ResourceGroupName $ResourceGroupName -TemplateFile "$pwd\Templates\OutterLA1.json" -TemplateParameterFile "$pwd\Templates\OutterLA1.param.json" -Force -Verbose
	}
	
}

