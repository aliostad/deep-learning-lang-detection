param(
    [String]$version,
    $EmailAddr,
    $dispatchers
)

function Expand-ZIPFile($file, $destination)
{
$shell = new-object -com shell.application
$zip = $shell.NameSpace($file)
foreach($item in $zip.items())
{
$shell.Namespace($destination).copyhere($item)
}
}

#change path here on appropriate
$TPAM = "C:\TPAM\"
$TPAMrem = "\TPAM\"
$log = $TPAM + "Scripts\Temp\JavaAPIlog.txt"

$path = "\\morflsw01.prod.quest.corp\RD-TPAM-DEV-BUILD\latest\api\"
$fullpathtoshare = $path + $version
# $version = "TPAM-API-Java-2.5.914.zip"

$TPAMJavaTempFolder = $TPAM + "Scripts\Temp\JavaAPI\"
$fullpath = $TPAMJavaTempFolder + $version

New-Item -ItemType Directory -Force -Path $TPAMJavaTempFolder | Out-Null
"Copy File `n" > $log

gci $TPAMJavaTempFolder | Remove-Item -Recurse -Force -Confirm:$false 
if (Test-Path $TPAMJavaTempFolder* ) {
    "Temporary files are not deleted successfully!" >> $log
} else {
    "Temporary files are deleted successfully." >> $log
}

Copy-Item $fullpathtoshare $TPAMJavaTempFolder -Force -PassThru >> $log
Expand-ZIPFile -file $fullpath -destination $TPAMJavaTempFolder


$edmzparapi = $TPAMJavaTempFolder + "edmz-par-api.jar"
$j2sshcore = $TPAMJavaTempFolder + "j2ssh-core-0.2.9.jar"
$libFolder = $TPAMrem +"lib\"

foreach ($dispatcher in $dispatchers) 
{ 
   $tmppath = "\\"+$dispatcher+"\c$" + $libFolder
   Copy-Item $edmzparapi $tmppath -Force -PassThru >> $log
   Copy-Item $j2sshcore $tmppath -Force -PassThru >> $log
}

gci $TPAMJavaTempFolder | Remove-Item -Recurse -Force -Confirm:$false 
if (Test-Path $TPAMJavaTempFolder* ) {
    "Temporary files are not deleted successfully!" >> $log
} else {
    "Temporary files are deleted successfully." >> $log
}

#send mail
$emailFrom = "tpamresults@tpam.com" 
$subject="JavaAPI upload result"
$message = (Get-Content $log) -join "`n" 
$smtpserver="relayemea.prod.quest.corp"
$smtp=new-object Net.Mail.SmtpClient($smtpServer) 
$smtp.Send($emailFrom, $EmailAddr, $subject, $message)