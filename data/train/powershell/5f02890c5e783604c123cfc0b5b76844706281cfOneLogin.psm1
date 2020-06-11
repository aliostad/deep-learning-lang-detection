$ONELOGIN_API_KEY = ""	# Key here...
$ONELOGIN_USER = $ONELOGIN_API_KEY + ":X"
$ONELOGIN_BASE64_STRING = [System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes($ONELOGIN_USER))
$ONELOGIN_HEADERS = @{Authorization = "Basic $ONELOGIN_BASE64_STRING"}

$ONELOGIN_END_POINTS = @{
	"Users"	= "https://api.onelogin.com/api/v3/users.xml"
	"ByUserName" = "https://api.onelogin.com/api/v3/users/username/"
	"ByID" = "https://api.onelogin.com/api/v3/users/"
}

function Get-OneLoginUser {
	param ([string]$Username, [string]$UserID, [switch]$All)
	
	function Create-OneLoginObjects {
		param ([xml]$XML, [string]$XPath)
		
		$Nodes = $XML.SelectNodes($XPath)
		foreach ($N in $Nodes) {
			$UserObj = New-Object PSObject
			foreach ($Key in $N.ChildNodes) {
				$KeyName = $Key.Name
               			$TextInfo = (Get-Culture).TextInfo
               			$PSKeyName = $TextInfo.ToTitleCase($KeyName.Replace("-"," ")).Replace(" ","")
               			$KeyVal = $N.$KeyName
				if ($KeyVal.nil) {
					$UserObj | Add-Member -MemberType NoteProperty -Name $PSKeyName -Value $null
				}
				else {
                   			if ($KeyName -eq "status") {
                       				switch ($KeyVal) {
                           				0 {$KeyVal = "Unactivated"}
							1 {$KeyVal = "Active"}
                    	    				2 {$KeyVal = "Suspended"}
                	        			3 {$KeyVal = "Locked"}
            	            				4 {$KeyVal = "Password Expired"}
        	                			5 {$KeyVal = "Awaiting Password Reset"}
    	                    				default {$KeyVal = "Unknown"}
	                			}
                   			}
					$UserObj | Add-Member -MemberType NoteProperty -Name $PSKeyName -Value $KeyVal
				}
			}
			[array]$AllObj += $UserObj
		}
		return $AllObj	
	}
	
	if ($Args.Count -gt 1) {
		Write-Error "Function overloaded. Number of parameters should be 1. $($Args.Count) were passed."
	}
	else {
		if ($All) {
			$Data = $true
			$i = 1
			while ($Data) {
				[xml]$XML = (curl -Uri $($ONELOGIN_END_POINTS["Users"] + "?page=$i") -Header $ONELOGIN_HEADERS -Method "GET").Content
				$TempArr = Create-OneLoginObjects -XML $XML -XPath "/users/user"
				if ($TempArr) {
					[array]$AllUsers += $TempArr
					$i++
				}
				else {
					$Data = $false
				}			
			}
		}
		else {
			if ($Username) {
				[xml]$XML = (curl -Uri $($ONELOGIN_END_POINTS["ByUserName"] + $Username) -Header $ONELOGIN_HEADERS -Method "GET").Content
			}
			elseif ($UserID) {
				[xml]$XML = (curl -Uri $($ONELOGIN_END_POINTS["ByID"] + $UserID) -Header $ONELOGIN_HEADERS -Method "GET").Content
			}
			$AllUsers = Create-OneLoginObjects -XML $XML -XPath "/user"
		}
		return $AllUsers
	}
}

function New-OneLoginUser {
    #TODO: Add some stuff here. It's empty :(
    continue
}

function Remove-OneLoginUser {
	param ([string]$Username, [string]$UserID)
	if ($Username) {
		$FullURI = $ONELOGIN_END_POINTS["ByUsername"] + $Username
        	Write-Host "Removing ${Username}: " -NoNewline
	}
	elseif ($ID) {
		$FullURI = $ONELOGIN_END_POINTS["ByID"] + $UserID
        	Write-Host "Removing ${UserID}: " -NoNewline
	}
	try {
		$WebReq = curl -Uri $FullURI -Header $ONELOGIN_HEADERS -Method "DELETE"
        if ($WebReq.StatusCode -eq "200") {
		    Write-Host -Fore Green "Success"
        }
        else {
            Write-Host -Fore Red "Failed ($($WebReq.StatusCode))"
        }
	}
	catch {
		Write-Host -Fore Red "$($Error[0].Exception.Message)"
	}
}

function Set-OneLoginUser {
    param ([string]$Username, [string]$UserID)
    #TODO: Add some stuff here. It's empty :(
    continue
}
