#Get-iAzureResourceUsageData

    param (
	     $reportedStartTime = "2015-05-01"
	    ,$reportedEndTime = ([datetime]::Today).toString('yyyy-MM-dd')
	    ,[ValidateSet('Daily','Hourly')]
	     $granularity = 'Daily'
        ,$subscriptionId = 'a027c53d-0359-4edf-a3eb-9d5c429cbc95'
        ,$showDetails = $true
        ,$credential
    )

    Add-AzureRmAccount -credential $credential

    $ResourceData = @()
    $continuationToken = ""
    Do { 

        $usageData = Get-UsageAggregates `
            -ReportedStartTime $reportedStartTime `
            -ReportedEndTime $reportedEndTime `
            -AggregationGranularity $granularity `
            -ShowDetails:$showDetails `
            -ContinuationToken $continuationToken

        $ResourceData += $usageData.UsageAggregations.Properties | 
            Select-Object `
                UsageStartTime, `
                UsageEndTime, `
                @{n='SubscriptionId';e={$subscriptionId}}, `
                MeterCategory, `
                MeterId, `
                MeterName, `
                MeterSubCategory, `
                MeterRegion, `
                Unit, `
                Quantity, `
                @{n='Project';e={$_.InfoFields.Project}}, `
                InstanceData
        if ($usageData.NextLink) {
            $continuationToken = `
                [System.Web.HttpUtility]::`
                UrlDecode($usageData.NextLink.Split("=")[-1])
        } 
	    else {
            $continuationToken = ""
        }
    } until (!$continuationToken)

    $ResourceData