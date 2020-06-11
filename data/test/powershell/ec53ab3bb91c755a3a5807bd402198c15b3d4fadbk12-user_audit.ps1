#------------------------------------------------------------------------------ 
# Copyright (c) 2017 Shandor Simon <s@duff.io>  https://duff.io
# 
# MIT License
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
#------------------------------------------------------------------------------ 
# Version 1.0.1 - 2017-01-11
#------------------------------------------------------------------------------ 
# Sample PowerShell script for Blackbaud K12 "ON" products API that
# uses the /user/audit API call (under constituents)

$schoolWebsite = "https://my_school.myschoolapp.com"  # website used to login to the "ON" products
$apiUser = "my_username"
$apiPassword = "my_password"

# First, we use the login method to get a authentication token using our username and password
$response = Invoke-RestMethod "$schoolWebsite/api/authentication/login?username=$apiUser&password=$apiPassword&format=json"

if($response.Token) { # Did we get a token in our response?
	$token = $response.Token
    
    $startDate = "8/1/2015 12:00 AM"  # Start date for audit period
	$endDate = "7/30/2016 12:00 AM"   # End date for audit period
	$roleIDs = "12070"                     # Comma seperate listed of roles to search, can find with /role/directory API

	$startDate = [System.Web.HttpUtility]::UrlEncode($startDate)  # Need to properly encode the date for use in URL
	$endDate = [System.Web.HttpUtility]::UrlEncode($endDate)

	$response = Invoke-RestMethod "$schoolWebsite/api/user/audit/?t=$token&RoleID=$roleIDs&startDate=$($startDate)&endDate=$($endDate)&report=5&format=json"

	$response | Export-CSV -NoTypeInformation -Encoding ascii -Path "C:/tmp/audit.csv"
	Invoke-Item "C:\tmp\audit.csv"
}
