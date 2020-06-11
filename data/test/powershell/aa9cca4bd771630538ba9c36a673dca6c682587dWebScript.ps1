param($type)
Function WebScriptApiCall($username, $password, $extension)
{
    $baseuri = "https://www.webscript.io/api/0.1"
    $uri = New-Object System.Uri ($baseuri+"/"+$extension)  
    $encoded =  [System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($username+":"+$password))  
    $headers = @{Authorization = "Basic "+$encoded}  
    $r = Invoke-WebRequest $uri -Headers $headers  
    return $r.Content
}
Function SubdomainHandle($powerShellCustomObject)
{
    $subDomains = @()
    $i = 0
    ForEach($subDomainNames in $powerShellCustomObject| Get-Member)
    {
        if($subDomainNames.MemberType -eq "NoteProperty")
        {
            $subDomains += $subDomainNames.Name
            $response = "Type $i to write in " + $subDomains[$i]
           Write-Host $response
            $i++
        }
    }
    $response = Read-Host 'Type number of subdomain you want to save'
    if(!($response -as [int]) -and ($response -ne 0))
    {
       Write-Host "Error in input please check your input not int"
        exit
    }
    if($response -gt $subDomains.length-1)
    {
        Write-Host "Error in input please check your input"
        exit
    }
    $subDomainToSave = $subDomains[$response]
    return $subDomainToSave
}
Function DirectoryHandler()
{
    $curLocatio = dir
    $directories = @()
    $i = 0
    ForEach($webScriptDirectories in $curLocatio.Name)
    {
       $directories += $webScriptDirectories
       Write-Host "pick directory to save files $i : $webScriptDirectories"
       $i++
    }

    $response = Read-Host 'Type number of directory you want to save'
    if(!($response -as [int]) -and ($response -ne 0))
    {
        Write-Host "Error in input please check your input not int"
        cd $oldLocatio
        exit
    }
    if($response -gt $directories.length-1)
    {
        Write-Host "Error in input please check your input"
        cd $oldLocatio
        exit
    }
    $directoryToSave = $directories[$response]
    return $directoryToSave
}
Function WebScriptApiSave($username, $password, $extension, $file)
{
    $baseuri = "https://www.webscript.io/api/0.1/script"
    $code = (Get-Content $file) -join "`n"
    $uri = New-Object System.Uri ($baseuri+"/"+$extension)  
    $encoded =  [System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($username+":"+$password))  
    $headers = @{Authorization = "Basic "+$encoded}  
    Invoke-RestMethod $uri -Headers $headers -Method Put -Body $code
}
Function CreateConfig()
{
    $response = Read-Host 'Your Username to Webscript'
    if(!($response -as [string]))
    {
        Write-Host "Error in input please check your input"
        exit
    }
    $username = $response
    $response = Read-Host 'Your AppId to Webscript'
    if(!($response -as [string]))
    {
        Write-Host "Error in input please check your input"
        exit
    }
    $appid = $response
    $response = Read-Host 'Your Webscript file locatio (full path)'
    if(!($response -as [string]))
    {
        Write-Host "Error in input please check your input"
        exit
    }
    $savePath = $response
    $saveInfoUsername = "Username€" + $username
    $saveInfoAppId = "AppId€" + $appid
    $saveInfoSavePath = "SavePath€" + $savePath
    $saveInfoUsername | Set-Content 'WebScriptConfig.txt'
    $saveInfoAppId |Add-Content 'WebScriptConfig.txt'
    $saveInfoSavePath |Add-Content 'WebScriptConfig.txt'
    Write-Host "Config file is now configured."

}
Function GetConfiguration()
{
    $ConfigContent = Get-Content "WebScriptConfig.txt"
    $ConfigContentSplitByLines = $ConfigContent.Split("`n")
    $configuration = @()
    for($i = 0; $i -lt $ConfigContentSplitByLines.Length;$i++)
    {
        $splittedContent = $ConfigContentSplitByLines[$i].Split('€')
        $configuration += $splittedContent[1]
    }
    return $configuration
}
Function HelpText()
{
   Write-Host "Help: "
   Write-Host ""
   Write-Host "  You can push data to Webscript with command push."
   Write-Host ""
   Write-Host "  You can pull data from Webscript with command pull"
   Write-Host ""
   Write-Host "  You can setup your Webscript settings with command config"
}
Function Pull($username, $appid, $savePath)
{
    $webScriptAnswer = WebScriptApiCall $username $appid $extensions
    $powerShellCustomObject = ConvertFrom-Json $webScriptAnswer

    ForEach($subDomainNames in $powerShellCustomObject| Get-Member)
    {
        if($subDomainNames.MemberType -eq "NoteProperty")
        {
            $subDomainName = $subDomainNames.Name
            cd $savePath

            if(!(Test-Path $savePath\$subDomainName))
            {
                mkdir $subDomainName
                echo "Made a folder:  $subDomainName"
            }

            $scriptList = $powerShellCustomObject.$subDomainName.scripts

            ForEach($script in $scriptList)
            {
                $scriptPathExtensio = "script/"+$subDomainName+$script
                $luaCode = WebScriptApiCall $username $appid $scriptPathExtensio
                echo "Creating file: $script.lua"
                New-Item $savePath\$subDomainName\$script.lua -Force -ItemType file
                $luaCode | Out-File $savePath\$subDomainName\$script.lua -Force
            }
        }
    }
}
Function Push($username, $appid, $savePath)
{
    $webScriptAnswer = WebScriptApiCall $username $appid $extensions
    $powerShellCustomObject = ConvertFrom-Json $webScriptAnswer
    $subDomainToSave = SubdomainHandle $powerShellCustomObject
    Write-Host "Subdomain we save data $subDomainToSave"
    
    cd $savePath
    $directoryToSaveFrom = DirectoryHandler
    cd $directoryToSaveFrom

    $curLocatio = dir
    $i = 0
    ForEach($scriptFile in $curLocatio.Name)
    {
        $scriptFileSplit = $scriptFile.split(".")
        $extensionNew = $subDomainToSave + "/" + $scriptFileSplit[0]
        WebScriptApiSave $username $appid $extensionNew $scriptFile
        echo "Saved the file: $scriptFile into Webscript"
    }
}
if(!($type -as [string]))
{
   HelpText
   exit
}
$oldLocatio = Get-Location
$extensions = "subdomains"
$webScriptConfigLoc =$oldLocatio.ToString() + "\WebScriptConfig.txt"
if(Test-Path($webScriptConfigLoc))
{
    $configuration = GetConfiguration
    $username = $configuration[0]
    $appid = $configuration[1]
    $savePath = $configuration[2]

    if($type -eq "pull")
    {
        Write-Host "pulling data"
        Pull $username $appid $savePath
        cd $oldLocatio
    }
    Elseif($type -eq "push")
    {
        Write-Host "pushing data"
        Push $username $appid $savePath 
        cd $oldLocatio
    }
    Elseif($type -eq "config")
    {
        Write-Host "Creating config file"
        CreateConfig
    }
    Else
    {
        HelpText
    }
}
else
{
    if($type -eq "config")
    {
        cd $oldLocatio
        Write-Host "Creating config file"
        CreateConfig
        
    }
    Else
    {
       HelpText
       Write-Host ""
       Write-Host "  No configuration file found please create one"
    }
}