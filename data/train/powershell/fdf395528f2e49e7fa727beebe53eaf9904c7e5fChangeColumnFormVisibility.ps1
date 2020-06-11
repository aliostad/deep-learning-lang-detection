#
# This PowerShell script will demonstrate how to you can chage the visibilty of SharePoint list column in different forms like DisplayForm
#

#Parameters
[CmdletBinding()]
Param(
	[Parameter(Mandatory=$False,Position=0)]
	[string]$Url,

	[Parameter(Mandatory=$False,Position=1)]
	[string]$ListName,

	[Parameter(Mandatory=$False,Position=2)]
	[string]$FieldName,

	[Parameter(Mandatory=$False,Position=3)]
	[ValidateSet("EditForm", "DisplayForm", "NewForm")]
	[string]$ListView,

	[Parameter(Mandatory=$False,Position=4)]
	[bool]$ShowInForm
)

Import-Module Microsoft.Online.SharePoint.PowerShell

#Get SharePoint.Cliend dll:s. The path here may need to change if you used e.g. C:\Lib.. 
Add-Type -Path "c:\Program Files\Common Files\microsoft shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.dll" 
Add-Type -Path "c:\Program Files\Common Files\microsoft shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.Runtime.dll"

try
{
	# connect/authenticate to SharePoint Online and get ClientContext object..
	$credential = Get-Credential
	$clientContext = New-Object Microsoft.SharePoint.Client.ClientContext($Url)
	$credentials = New-Object Microsoft.SharePoint.Client.SharePointOnlineCredentials($credential.UserName, $credential.Password)
	$clientContext.Credentials = $credentials

	if (!$clientContext.ServerObjectIsNull.Value)
	{ 
		#This gets Microsoft.SharePoint.Client.List
		$oList = $clientContext.Web.Lists.GetByTitle($ListName); 
		#This gets Microsoft.SharePoint.Client.FieldCollection
		$fieldColl = $oList.Fields;

		$clientContext.Load($fieldColl);
		$clientContext.ExecuteQuery();
		
		$field = $fieldColl.GetByInternalNameOrTitle($FieldName);
		
		$clientContext.Load($field);
		$clientContext.ExecuteQuery();
		
		switch ($listView) {
			"DisplayForm"
			{
				$field.SetShowInDisplayForm($ShowInForm);				
				$clientContext.ExecuteQuery();
				
				$message = "Fields '" + $field.Title + "' DisplayForm visibility changed to: " + $ShowInForm
				write-Host $message -ForegroundColor Green
				break
			}
			"NewForm"
			{
				$field.SetShowInNewForm($ShowInForm);				
				$clientContext.ExecuteQuery();
				
				$message = "Fields '" + $field.Title + "' NewForm visibility changed to: " + $ShowInForm
				write-Host $message -ForegroundColor Green
				break
			}
			"EditForm"
			{
				$field.SetShowInEditForm($ShowInForm);				
				$clientContext.ExecuteQuery();
				
				$message = "Fields '" + $field.Title + "' EditForm visibility changed to: " + $ShowInForm
				write-Host $message -ForegroundColor Green
				break
			}
		}
	}
}
finally {
	$clientContext.Dispose()
}

#The MIT License (MIT)

#Copyright (c) 2015 Mikko Koskinen @mikkokoskinen

#Permission is hereby granted, free of charge, to any person obtaining a copy
#of this software and associated documentation files (the "Software"), to deal
#in the Software without restriction, including without limitation the rights
#to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
#copies of the Software, and to permit persons to whom the Software is
#furnished to do so, subject to the following conditions:

#The above copyright notice and this permission notice shall be included in
#all copies or substantial portions of the Software.

#THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
#IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
#AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
#LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
#OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
#THE SOFTWARE.