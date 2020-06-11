#####################################################
# Purpose: Import company member from a csv file.
# 
# Copyright (c) 2014 TeamViewer GmbH
# Example created 2014-02-20
# Version 1.1
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
#####################################################

###############
# Configuration
###############

# API access token
$accessToken = "XX-XXXXXXXXXXXXXXXXXXXX" #<-- your access token, can be left empty when OAuth (below) is configured.

# OAuth: API client id & authorizationCode
# if all variables are set here, OAuth will be used to request an access token
$clientId = ""            				#<-- Create an app in your TeamViewer Management Console and insert the client ID here.
$clientSecret = ""						#<-- Insert your client secret here.
$authorizationCode = ""      #<-- Visit https://webapi.teamviewer.com/api/v1/oauth2/authorize?response_type=code&client_id=YOURCLIENTIDHERE
                             #    Login, grant the permissions (popup) and put the code shown in the authorizationCode variable here

# import filename
$importFileName = "import.csv"

# new user defaults (if not available in csv import file)
$defaultUserLanguage = "en"                  
$defaultUserPassword = "myInitalPassword!"   
$defaultUserPermissions = "ShareOwnGroups,EditConnections,EditFullProfile,ViewOwnConnections"

##########
# includes
##########

$currentPath = Split-Path ((Get-Variable MyInvocation -Scope 0).Value).MyCommand.Path

. (Join-Path $currentPath "Common.ps1")

###########
# Functions
###########

# Read content of csv file
function ReadUserFromCSV($strImportCSV)
{
    Write-Host
    Write-Host "Reading CSV file "$strImportCsv" ..."
	
    $result1 = $NULL

    try
    {
        $path = (Join-Path $currentPath $strImportCSV)
        Write-Host "Reading from file: " $path
		$result1 = Get-Content $path -Encoding UTF8 | Where-Object {$_ -ne ""} | ConvertFrom-Csv
        Write-Host "Lines found in file: " $result1.length
    
		$userDict = @{}
		foreach ($element in $result1)
		{
			$userDict.Add($element.email, $element)
		}
		$result1 = $userDict
    }
    catch [Exception]
    {
        Write-Host ("File read failed! The error was '{0}'." -f $_)
        $result1 = $NULL
    }
    finally 
	{
        return $result1
    }    
}

#######################
# Import Users from CSV
#######################

Write-Host ("Starting CSV import...")

# check OAuth requirements
if ($clientId -and $authorizationCode) 
{
	#get token
	$token = RequestOAuthAccessToken $clientId $clientSecret $authorizationCode
	if ($token){
		$accessToken = $token
	}
}

#ping API to check connection and token
if (PingAPI($accessToken) -eq $true)
{
	#read users from the CSV file
	$dictUsersCSV = ReadUserFromCSV($importFileName)
	
	#sync
    #for each user in csv: check against api if user exists (by mail)	
	foreach($usrKey in $($dictUsersCSV.keys))
	{
		$userApi = $null
		$userCsv = $null
		
		$userCsv = $dictUsersCSV[$usrKey]
		$userApi = GetUserByMail $accessToken $usrKey #lookup api user by mail
		
		if ($userApi) #user found -> update user
		{
			Write-Host "User with email=" $usrKey" found."
			
			#Update the user
			UpdateUser $accessToken $userApi.id $userCsv
		}
		else #no user found -> create user
		{
            Write-Host "No user with email=" $usrKey" found."
            
            #Create User
            CreateUser $accessToken $userCsv $defaultUserPermissions $defaultUserLanguage $defaultUserPassword
		}
	}
}
else
{
	Write-Host ("No data imported. Token or connection problem.")
}
    
Write-Host ("CSV import finished.")