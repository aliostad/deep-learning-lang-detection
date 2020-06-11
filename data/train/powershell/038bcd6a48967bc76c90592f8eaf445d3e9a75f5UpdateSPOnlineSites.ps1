<#
####################################################


Office365 Trial Signup:
https://products.office.com/en-us/business/office-365-enterprise-e3-business-software

Office365 Signing Page:
https://login.microsoftonline.com

Credentials
Email:
rfaeh@evodaydemo.onmicrosoft.com
Password:
kAF!JjK?m@_mR

####################################################
#>


break



# Import the required DLL
# Download and install this: http://www.microsoft.com/en-us/download/details.aspx?id=42038
Add-Type -Path "C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.dll"
Add-Type -Path "C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.Publishing.dll"
Add-Type -Path "C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.Runtime.dll"

$username = 'rfaeh@evodaydemo.onmicrosoft.com'

$passwordString = "kAF!JjK?m@_mR"

$password = ConvertTo-SecureString $passwordString -AsPlainText -Force

$site = "https://evodaydemo.sharepoint.com"

$clientContext = New-Object Microsoft.SharePoint.Client.ClientContext($site)
$creds = New-Object Microsoft.SharePoint.Client.SharePointOnlineCredentials($username,$password)
$clientContext.Credentials = $creds


#Activate a Feature

#Minimal Download Strategy Feature
$FeatureId = [GUID]("87294C72-F260-42f3-A41B-981A2FFCE37A") 

$webFeatures = $clientContext.Web.Features  
$clientContext.Load($webFeatures) 
$clientContext.ExecuteQuery() 

$webfeatures.Add($featureId, $false, [Microsoft.SharePoint.Client.FeatureDefinitionScope]::None) 

$clientContext.ExecuteQuery()



#Iterate through all Webs and Activate Versioning on all Lists
$rootWeb = $clientContext.Web
$childWebs = $rootWeb.Webs
$clientContext.Load($rootWeb)
$clientContext.Load($childWebs)
$clientContext.ExecuteQuery()


foreach ($childWeb in $childWebs){

    $lists = $childWeb.Lists
    $clientContext.Load($childWeb)
    $clientContext.Load($lists)
    $clientContext.ExecuteQuery()
    Write-Host "Web URL is" $childWeb.Url


    foreach($list in $lists){
        
        "List Name: " + $list.Title

        <#

        if(($list.Title -ne "Master Page Gallery") -and ($list.Title -ne "Site Pages")){

             Write-Host "---- Versioning enabled: " + ($list.EnableVersioning)

             $list.EnableVersioning = $true 
             $list.Update()

             $clientContext.Load($list)
             $clientContext.ExecuteQuery()

             Write-Host "---- Versioning now enabled: " + ($list.EnableVersioning)
         }

         #>
        
    }

}


