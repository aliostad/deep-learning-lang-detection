########################################################### 
# AUTHOR      : Patrick Schmidt, support@server-eye.de  
# DATE        : 03-08-2015   
# DESCRIPTION : This scripts checks all databases for its available Whitespace!
#               Supported Exchange versions are 2007,2010 and 2013. (and hopefully above ;) )
#               Please notice that since Exchange 2010 only the root whitespace is available (otherwise you will need to dismount an mailbox and use eseutil)
# VERSION     : 0.8
########################################################### 

<#
<version>2</version>
<description>Prüft den verfügbaren Whitespace Ihrer Datenbanken (root Whitespace ab 2010)</description>
#>

param(
    [int]$minMBWhitespace,
    [string]$ignoredMailBoxes
)

#load the libraries from the Server Eye directory
$scriptDir = $MyInvocation.MyCommand.Definition |Split-Path -Parent |Split-Path -Parent

$pathToApi = $scriptDir + "\PowerShellAPI.dll"
$pathToJson = $scriptDir + "\Newtonsoft.Json.dll"
[Reflection.Assembly]::LoadFrom($pathToApi)
[Reflection.Assembly]::LoadFrom($pathToJson)

#init api variables..
$api = new-Object ServerEye.PowerShellAPI
$msg = new-object System.Text.StringBuilder

$exitCode = 0
$version = ""

If (Test-Path "HKLM:\SOFTWARE\Microsoft\Exchange\v8.0") 
{ 
    Add-PSSnapin Microsoft.Exchange.Management.PowerShell.Admin -EA SilentlyContinue 
    $msg.AppendLine("--Exchange Version: 2007")
    $version = 2007
} 
ElseIf ((Test-Path "HKLM:\SOFTWARE\Microsoft\ExchangeServer\v14") -or (Test-Path "HKLM:\SOFTWARE\Microsoft\ExchangeServer\v15")) 
{ 
    if(Test-Path "HKLM:\SOFTWARE\Microsoft\ExchangeServer\v15"){
        $msg.AppendLine("--Exchange Version: 2013")
        $version = 2013
    }else{
        $msg.AppendLine("--Exchange Version: 2010")
        $version = 2010
    }

    Add-PSSnapin Microsoft.Exchange.Management.PowerShell.E2010 -EA SilentlyContinue 
} 
Else 
{
    $msg.AppendLine("--Exchange Version: no exchange found!")
    $api.setStatus([ServerEye.PowerShellStatus]::ERROR)
    $exitCode = -5
} 

##only if exchange stuff was successfully loaded!
if($version -ne ""){
    
    $databases = Get-MailboxDatabase -Status
    $computer = gc env:computername
    $mailboxesToIgnore = $ignoredMailBoxes.Split(",")
    $atLeastOneCheckDone = "false"


    $msg.AppendLine("-------------------------------")
    $msg.AppendLine("")

    if($version -eq 2007){
        
        $mbCount = ($databases | Measure-Object).count
        $pbDbs = (Get-PublicFolderDatabase |Measure-Object).count

        $evtRecord = get-wmiobject -computer $computer -class Win32_NTLogEvent -Filter "logfile = 'application' AND EventIdentifier = 1074136261 AND sourcename = 'MSExchangeIS Mailbox Store'"| select -First $mbCount
         $evtpbRecord = get-wmiobject -computer $computer -class Win32_NTLogEvent -Filter "logfile = 'application' AND EventIdentifier = 1074136261 AND sourcename = 'MSExchangeIS public Store'"| select -First $pbDbs | Sort-Object -Property Message 


        $evtRecord |ForEach-Object{
            
            $whitespace = $_.insertionstrings[0] -as [int]
            $db = $_.insertionstrings[1] 
            $time = Get-Date([System.Management.ManagementDateTimeconverter]::ToDateTime($_.TimeGenerated)).toLocalTime()


            if($mailboxesToIgnore -contains $db){
                return
            }

            $atLeastOneCheckDone = "true"

            if($whitespace -lt $minMBWhitespace){
                $api.setStatus([ServerEye.PowerShellStatus]::ERROR)
                $exitCode = -2

                $msg.AppendLine("--ERROR: Mailbox (" + $db + ") available whitespace is " + $whitespace + " MB")
                $msg.AppendLine("-------Timestamp: " + $time)
                $msg.AppendLine()
            }else{
                 $msg.AppendLine("--OK: Mailbox (" + $db + ") available whitespace is " + $whitespace + " MB")
                 $msg.AppendLine("-------Timestamp: " + $time)
            }
            
            $api.setMeasurementValue($db,[double]$whitespace)

        }

        if($evtpbRecord -ne $null){
            $evtpbRecord |ForEach-Object{
            
                $whitespace = $_.insertionstrings[0] -as [int]
                $db = $_.insertionstrings[1] 
                $time = Get-Date([System.Management.ManagementDateTimeconverter]::ToDateTime($_.TimeGenerated))
                $totalSize = $_.databasesize

                if($mailboxesToIgnore -contains $db){
                    return
                }

                $atLeastOneCheckDone = "true"

                if($whitespace -lt $minMBWhitespace){
                    $api.setStatus([ServerEye.PowerShellStatus]::ERROR)
                    $exitCode = -2

                    $msg.AppendLine("--ERROR: Public Folder (" + $db + ") available whitespace is " + $whitespace + " MB")
                    $msg.AppendLine("-------Timestamp: " + $time)
                    $msg.AppendLine()
                }else{
                     $msg.AppendLine("--OK: Public Folder (" + $db + ") available whitespace is " + $whitespace + " MB")
                     $msg.AppendLine("-------Timestamp: " + $time)
                }
                
                $api.setMeasurementValue($db,[double]$whitespace)

            }
        }

    }else{
        $databases = $databases | Select-Object name,databasesize,@{label="WhitespaceinMB";expression={$_.availablenewmailboxspace.ToMB()}}

         $databases |ForEach-Object{
            $whitespace = $_.WhitespaceinMB
            $name = $_.name
            $totalSize =$_.databasesize

            if($mailboxesToIgnore -contains $name){
                return
            }

            $atLeastOneCheckDone = "true"

            if($whitespace -lt $minMBWhitespace){
                $api.setStatus([ServerEye.PowerShellStatus]::ERROR)
                $exitCode = -2

                $msg.AppendLine("--ERROR: Mailbox (" + $name + ") available whitespace is " + $whitespace + " MB, Mailbox Size is " + $totalSize)
                $msg.AppendLine()
            }else{
                 $msg.AppendLine("--OK: Mailbox (" + $name + ") available whitespace is " + $whitespace + " MB, Mailbox Size is " + $totalSize)
            }
    
            $api.setMeasurementValue($name,[double]$whitespace)
        }
    }
    
    if($atLeastOneCheckDone -eq "false"){
        $api.setStatus([ServerEye.PowerShellStatus]::ERROR)
        $exitCode = -3

        $msg.AppendLine("--ERROR: No mailbox check done! Please check your ignore selection or for any error output!")
    }

}



<#api adding #> 
$api.setMessage($msg)  

#write our api stuff to the console. 
Write-Host $api.toJson() 
exit $exitCode