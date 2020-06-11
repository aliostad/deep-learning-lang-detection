$ErrorActionPreference = "stop"

function new_azure_resource_management_base { param($resourceRestClient, $apiVersion)
	$obj = New-Object PSObject -Property @{
		ResourceRestClient = $resourceRestClient;
		Serializer = (New-Object Web.Script.Serialization.JavaScriptSerializer);
		ApiVersion = $apiVersion;
	}
	$obj | Add-Member -Type ScriptMethod PutOperation { param($path, $def)
		Write-Host "INFO: Executing resource management api operation: Path: $($path)"

		$defJson = $this.Serializer.Serialize($def)

		$putResult = $this.ResourceRestClient.Request(@{
			Verb = "PUT";
			Resource = "$($path)?Api-Version=$($this.ApiVersion)";
			OnResponse = $parse_json;
			Content = $defJson;
			ContentType = "application/json";
		})

		$opComplete = $this._checkOperation($putResult)

		while($opComplete -eq $false) {
			$opResult = $this.ResourceRestClient.Request(@{
				Verb = "GET";
				Resource = "$($path)?Api-Version=$($this.ApiVersion)";
				OnResponse = $parse_json;
			})

			$opComplete = $this._checkOperation($opResult)
		}

		$result = $this.ResourceRestClient.Request(@{
			Verb = "GET";
			Resource = "$($path)?Api-Version=$($this.ApiVersion)";
			OnResponse = $parse_json;
		})
		$result
	}
	$obj | Add-Member -Type ScriptMethod _printDictionary { param($def)
		$def.GetEnumerator() | % {
			if($_.Value -is [Array]) {
				$_.Value | % {
					$this._printDictionary($_)
				}
			}
			elseif(!($_.Value -is [String]) -and $null -ne $_.Value) {
				$this._printDictionary($_.Value)
			} else {
				Write-Host "$($_.Key): $($_.Value)"
			}
		}
	}
	$obj | Add-Member -Type ScriptMethod _checkOperation { param($opResult)
		$provisioningStatus = $opResult.properties.provisioningState
		Write-Host "INFO: Checking resource management api operation status. Status: $($provisioningStatus)"

		if($provisioningStatus -eq "Failed") {
			$operations = $this.ResourceRestClient.Request(@{
				Verb = "GET";
				Resource = "$($path)/operations?Api-Version=$($this.ApiVersion)";
				OnResponse = $parse_json;
			})

			try {
				$errors = $operations.value | ? { $_.properties.provisioningState -eq "Failed" }
				$errors | % { $this._printDictionary($_) }
			} catch {
			}

			throw "deployment failed"
		}

		if($provisioningStatus -eq "Succeeded") {
			$true
			return
		}

		if(!@("Creating","Accepted") -contains $provisioningStatus) {
			$resultString = $this.Serializer.Serialize($result)
			Write-Host "ERROR: $resultString"
			throw "ERROR: Unexpected status: $($provisioningStatus)"
		}

		Start-Sleep -s 3
		$false
	}
	$obj
}
