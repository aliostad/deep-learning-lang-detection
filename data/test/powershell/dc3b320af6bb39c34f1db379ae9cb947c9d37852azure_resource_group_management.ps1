$ErrorActionPreference = "stop"

function new_azure_resource_group_management ($resourceRestClient) {
	$obj = New-Object PSObject -Property @{
		ResourceRestClient = $resourceRestClient;
		Serializer = (New-Object Web.Script.Serialization.JavaScriptSerializer);
		ApiVersion = "2014-04-01";
	}
	$obj | Add-Member -Type ScriptMethod _get_web_exception { param($e)
		$result = $e
		while($result.Response -eq $null) {
			if($null -eq $result.InnerException) { throw "could not find web exception" }
			$result = $result.InnerException
		}
		$result
	}
	$obj | Add-Member -Type ScriptMethod _exists { param($existsRequestOptions, $onExists)
		$restResult = $null
		$result = $false
		try {
			$restResult = $this.ResourceRestClient.Request($existsRequestOptions)
			$result = $true
		} catch {
			$e = $_.Exception
			$webException = $this._get_web_exception($e)
			if($webException.Response.StatusCode -eq "NotFound"){
				$result = $false
			} else {
				throw $_
			}
		}
		if($true -eq $result -and $null -ne $onExists) {
			& $onExists $restResult
		}
		
		$result
	}
	$obj | Add-Member -Type ScriptMethod CreateResourceGroup { param($name, $dataCenter)
		$def = @{
			location = $dataCenter;
			tags = @{};
		}

		$defJson = $this.Serializer.Serialize($def)

		$this.ResourceRestClient.Request(@{
			Verb = "PUT";
			Resource = "resourcegroups/$name`?api-version=$($this.ApiVersion)";
			OnResponse = $write_host;
			Content = $defJson;
			ContentType = "application/json";
		})
	}
	$obj | Add-Member -Type ScriptMethod DeleteResourceGroup { param($name)
		$resourceGroupExists = $true

		$resource = "resourcegroups/$name`?api-version=$($this.ApiVersion)"
		$existsOptions = @{ Verb = "GET"; Resource = $resource; OnResponse = $parse_json }

		if($this._exists($existsOptions)) {
			$this.ResourceRestClient.Request(@{
				Verb = "DELETE";
				Resource = $resource;
				OnResponse = $write_host
			})

			while($resourceGroupExists) {
				$resourceGroupExists = $this._exists(@{ Verb = "GET"; Resource = $resource; OnResponse = $parse_json }, { param($result)
					$provisioningStatus = $result.properties.provisioningState
					Write-Host "INFO: Checking template deployment status. Status: $($provisioningStatus)"
					if($provisioningStatus -ne "Deleting") {
						throw "ERROR: An unknow provisioning status occured when deleting the resoure group"
					}
				})
				Start-Sleep -S 1
			}
		}
	}
	$obj
}
