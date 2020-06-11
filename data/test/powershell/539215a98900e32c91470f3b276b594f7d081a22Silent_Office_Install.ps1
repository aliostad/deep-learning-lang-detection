$CurrentTime = Get-Date
$ComputerName = Get-Content env:COMPUTERNAME
$MessageBody = "$ComputerName started office installation at $CurrentTime `n`n"


$deployPath = "\\"
$version = Get-WmiObject -Class Win32_Product | Select-Object Name | where {$_.Name -like "*Microsoft Office Professional Plus*"}

#Check if Office 15 is installed - quit install
if ($version.Name -eq "Microsoft Office Professional Plus 2013"){
   $MessageBody += "Office 2013 is already installed. `n`n"
}
#Check if Office 14 is installed - upgrade to office 15, uninstall remaining office 14
elseif($version.Name -eq "Microsoft Office Professional Plus 2010"){
   #check which bit version of office 14 is installed by checking Outlook bitness key
   $BitnessKey = "HKLM:\Software\Microsoft\Office\14.0\Outlook"
   $Bitness = (Get-ItemProperty -Path $BitnessKey).Bitness

   if($Bitness -eq "x86"){
        $process = $(Start-Process $deployPath\x86\setup.exe -PassThru)
        $process | Wait-Process
        $MessageBody += "Office 15 install finished with error code: " + $process.ExitCode + "`n`n"

        $uninstall_args = "/uninstall ProPlus /config UninstallConfig.xml"
        $process = $(Start-Process "$deployPath\x86_Uninstall_2010\setup.exe" $uninstall_args -PassThru)
        $process | Wait-Process
        $MessageBody += "Office 14 uninstall finished with error code: " + $process.ExitCode + "`n`n" + "(3010 is a success) `n`n"
    }
    elseif ($Bitness -eq "x64"){
        $process = $(Start-Process $deployPath\x64\setup.exe -PassThru)
        $process | Wait-Process
        $MessageBody += "Office 15 install finished with error code: " + $process.ExitCode + "`n`n"

        $uninstall_args = "/uninstall ProPlus /config UninstallConfig.xml"
        $process = $(Start-Process "$deployPath\x64_Uninstall_2010\setup.exe" $uninstall_args -PassThru)
        $process | Wait-Process
        $MessageBody += "Office 14 uninstall finished with error code: " + $process.ExitCode + "`n`n" + "(3010 is a success) `n`n"
    }
    else {
        $MessageBody += "This version of office cannot be identified. No installation will occur. `n`n"
    }
}
#There is nothing installed - install office 15
else {
    $process = $(Start-Process $deployPath\x86\setup.exe -PassThru)
    $process | Wait-Process
    $MessageBody += "Office 15 install finsihed with error code: " + $process.ExitCode + "`n`n"
}

$CurrentTime = Get-Date
$MessageBody += "Office silent installation ended at $CurrentTime `n`n"
$AlertEmailAddress = "max.wagner@something.com"
# Send E-mail Message
$EmailMessage = New-Object System.Net.Mail.MailMessage 
$EmailMessage.From = "me@something.com"
$EmailMessage.To.Add($AlertEmailAddress) 
$EmailMessage.Subject = $MessageSubject

$EmailMessage.Body = $MessageBody

$smtp = New-Object System.net.Mail.SmtpClient 
$smtp.Host = "smtpserver"
$smtp.Send($EmailMessage)
