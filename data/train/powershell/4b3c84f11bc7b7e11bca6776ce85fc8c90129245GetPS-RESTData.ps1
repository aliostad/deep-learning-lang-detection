
Add-PSSnapin microsoft.sharepoint.powershell

#URL settings
$time = Get-Date

Function getEntity($entity){
    $user = "" #change this
    $pword = ConvertTo-SecureString –String "Password1" –AsPlainText -Force #change this
    $credential = New-Object –TypeName System.Management.Automation.PSCredential –ArgumentList $user, $pword

    $PWA_Url = "http://URL.com" #change this 
    $Url = $PWA_Url+"_api/ProjectData/"
    #Account
	   
    $fullURL = $Url + $entity
    Write-Host $fullURL
    Return Invoke-RestMethod -Method Get -Uri $fullURL -Credential $Credential
}
Function getTimesheetInfo($timesheet){
   $tsEntry = [xml]$timesheet.OuterXml
   $resourceId = $tsEntry.entry.content.properties.TimesheetOwnerId.'#text'
   $resource = getResourceInfo $resourceId
   $manager = getResourceInfo $resource.entry.content.properties.ResourceTimesheetManageId.'#text'
   $resourceName = $resource.entry.content.properties.ResourceName
   $resourceEmail = $resource.entry.content.properties.ResourceEmailAddress
   $managerName = $manager.entry.content.properties.ResourceName
   $managerEmail = $manager.entry.content.properties.ResourceEmailAddress
   #Write-Host $managerName $managerEmail $resourceName $resourceEmail
   sendNotification $managerName $managerEmail $resourceName $resourceEmail
}
Function getResourceInfo($resourceId){
   $resourceRequest = "Resources(guid'"+$resourceId+"')"
   $resource = getEntity $resourceRequest
   Return [xml]$resource.OuterXml
}
Function sendNotification($managerName, $managerEmail, $resourceName, $resourceEmail){
   $Subject = "Timesheet Submitted for " + $resourceName
   $Body =  $managerName + ", " +$resourceName + " has submitted a timesheet for your review."
  
   $AnonUser = "anonymous"
   $AnonPWord = ConvertTo-SecureString –String "anonymous" –AsPlainText -Force
   $AnonCredential = New-Object –TypeName System.Management.Automation.PSCredential –ArgumentList $AnonUser, $AnonPWord
   
   Write-Host $resourceName $managerName
   $SMTPServer = "000.000.000.000" #SMTP Server Address
   $SMTPFrom = "NoReply@emails.com" #Email address

   Send-MailMessage -Credential $AnonCredential -From $SMTPFrom -SmtpServer $SMTPServer -To $managerEmail -Subject $Subject -Body $Body
}
Function UpdateLastRun(){
   $location = "C:\Tools\LastRun.txt"
   $file = Get-Item $location
   if($file.exists){
    $file.Delete()
   }
   $time = Get-Date
   $time.ToString() | Out-File -FilePath $location
}
Function GetLastRun(){
   $location = "c:\Tools\LastRun.txt"
   $file = Get-Item $location
   if($file.exists){
    $lastRun = Get-Content -LiteralPath $location
    Return $lastrun
   }
}

$lastRun = GetLastRun
$restQuery = "Timesheets?`$filter=(TimesheetStatusId eq 1)"
if($lastRun){
    $dateFilter = [DateTime]$lastRun    
    $restQuery += " and (ModifiedDate gt DateTime'"+$dateFilter.GetDateTimeFormats("s")+"')"
}
$timesheets = getEntity($restQuery)
$timesheets | ForEach-Object {getTimesheetInfo($_)}
UpdateLastRun

