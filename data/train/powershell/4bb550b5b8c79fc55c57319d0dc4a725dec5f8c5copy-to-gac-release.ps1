[System.Reflection.Assembly]::Load("System.EnterpriseServices, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a")            
$publish = New-Object System.EnterpriseServices.Internal.Publish           
$publish.GacRemove("..\Auth0.ClaimsProvider\bin\Release\Auth0.ClaimsProvider.dll")                   
$publish.GacInstall("..\Auth0.ClaimsProvider\bin\Release\Auth0.ClaimsProvider.dll")        
$publish.GacRemove("..\Auth0.ClaimsProvider\bin\Release\Auth0Merged.dll")                   
$publish.GacInstall("..\Auth0.ClaimsProvider\bin\Release\Auth0Merged.dll")              
iisreset
