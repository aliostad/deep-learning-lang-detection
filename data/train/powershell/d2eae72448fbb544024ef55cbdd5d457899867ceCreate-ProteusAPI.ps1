param ( 
    [Parameter(Mandatory=$TRUE, Position=0, HelpMessage="Enter the URL for the Proteus Server, ie proteus.website.com")] 
    [string] 
    $ProteusServer,

    [Parameter(Mandatory=$FALSE, Position=1, HelpMessage="Enter the path to WSDL.exe")] 
    [string] 
    $WSDLPath = 'C:\Program Files (x86)\Microsoft SDKs\Windows\v7.0A\Bin\wsdl.exe',

    [Parameter(Mandatory=$FALSE, Position=2, HelpMessage="Whether or not this function should delete left over files made for compiling")] 
    [string] 
    $Clean = $TRUE
    )


if($false -eq (Test-Path $WSDLPath)){
    #Microsoft WDSL exe isn't installed. 
    echo "WSDL could not be found! Please Define -WSDLPath"
    break
}

#Ignores invalid SSL, to Self Signed Cert won't throw it off
[System.Net.ServicePointManager]::ServerCertificateValidationCallback = {$true}
$WebClient = new-object system.net.webclient
$APIPath = "https://$ProteusServer/Services/API?wsdl"
$wsdlContent = $WebClient.downloadstring($APIPath)
Set-Content "ProteusAPI.wsdl" $wsdlContent

if($false -eq (Test-Path "ProteusAPI.wsdl")){
    "ProteusAPI.wdsl was not generated"
    break
}

& $WSDLPath "ProteusAPI.wsdl" /out:ProteusAPI.cs 

#Test to see if WDSL Generated the API Wrapper
if($false -eq (Test-Path ProteusAPI.cs)){
    "ProteusAPI.cs was not generated"
    break
}

#Edit CS to allow for Cookies! (For Auth)
$ProteusAPIContent = Get-Content -Path ProteusAPI.cs
Remove-Item -Path ProteusAPI.cs
"Processing C# Content"
$NewProteusAPIContent = @()
$ProteusAPIContent | ForEach-Object {
    if($_ -cmatch "public ProteusAPI()"){
        $NewProteusAPIContent += "`t public ProteusAPI(string ServerURL) {"
        $NewProteusAPIContent += "`t `t this.CookieContainer = new System.Net.CookieContainer();"
        "Inserted ProteusAPI cookie containter"
    }elseif($_ -cmatch "this.Url ="){
        $NewProteusAPIContent += "`t `t this.Url = ServerURL;"
    }else{
        $NewProteusAPIContent += $_
    }
}
Set-Content ProteusAPI.cs $NewProteusAPIContent
"Proteus API Ready to Compile"

if($Clean -eq $TRUE){
    "Removing ProteusAPI.wsdl"
    Remove-Item -Path ProteusAPI.wsdl
}

if($true -eq (Test-Path "C:\Windows\Microsoft.NET\Framework64\v4.0.30319\csc.exe")){
    & "C:\Windows\Microsoft.NET\Framework64\v4.0.30319\csc.exe" /t:library /out:ProteusAPI.dll ProteusAPI.cs 
}elseif($true -eq (Test-Path "C:\Windows\Microsoft.NET\Framework\v4.0.30319\csc.exe")){
    & "C:\Windows\Microsoft.NET\Framework\v4.0.30319\csc.exe" /t:library /out:ProteusAPI.dll ProteusAPI.cs
}elseif($true -eq (Test-Path "C:\Windows\Microsoft.NET\Framework64\v2.0.50727\csc.exe")){
    & "C:\Windows\Microsoft.NET\Framework64\v2.0.50727\csc.exe" /t:library /out:ProteusAPI.dll ProteusAPI.cs
}elseif($true -eq (Test-Path "C:\Windows\Microsoft.NET\Framework\v2.0.50727\csc.exe")){
    & "C:\Windows\Microsoft.NET\Framework\v2.0.50727\csc.exe" /t:library /out:ProteusAPI.dll ProteusAPI.cs
}else{
    "CSC Compiler not found"
    break
}

#Test to see if CSC Generated the API Wrapper DLL
if($false -eq (Test-Path ProteusAPI.dll)){
    "ProteusAPI.dll was not generated"
    break
}

"ProteusAPI.dll successfully compiled!"

if($Clean -eq $TRUE){
    "Cleaning up, removing CS file"
    Remove-Item -Path ProteusAPI.cs
}

