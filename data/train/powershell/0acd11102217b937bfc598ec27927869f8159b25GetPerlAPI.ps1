param(
    [String]$version,
    $EmailAddr,
    $dispatchers
    )
    
$TPAM = "C:\TPAM\"
$tpamfold = "\tpam\"
$log = $TPAM + "Scripts\Temp\PerlAPIlog.txt"
#$dispatchers = "10.30.46.37", "10.30.46.100"
#$version = "ParApi-Perl-2.5.914.zip"
$TPAMPerlTempFolder = $TPAM + "Scripts\Temp\PerlAPI\"
$path = "\\morflsw01.prod.quest.corp\RD-TPAM-DEV-BUILD\latest\api\"
$fullpathtoshare = $path + $version


$CreateWorkingDir = {
     param($TPAMPerlTempFolder)
    New-Item -ItemType Directory -Force -Path $TPAMPerlTempFolder 
}

#Creating temporary directories on dispatchers
" ***   Creating temporary directories   ***" > $log
foreach ($dispatcher in $dispatchers) 
{ 
$resultcwd = Invoke-Command -ComputerName $dispatcher -ScriptBlock $CreateWorkingDir -ArgumentList ($TPAMPerlTempFolder)
$resultcwd >> $log
}

#Copy zip API file on dispatchers
"`n ***   Copy zip API file on dispatchers   ***" >> $log
foreach ($dispatcher in $dispatchers) 
{ 
   $tmppath = "\\"+$dispatcher+"\c$" + $tpamfold + "Scripts\Temp\PerlAPI\"
   Copy-Item $fullpathtoshare $tmppath -Force -PassThru >> $log
}


$ScriptBlock={
    param($version,$TPAMPerlTempFolder)

function Expand-ZIPFile($file, $destination) {
    $shell = new-object -com shell.application
    $zip = $shell.NameSpace($file)
    foreach($item in $zip.items()) {
        $shell.Namespace($destination).copyhere($item)
    }
}

$version -match '\d+\.\d+\.\d+' | out-null
$dv = $Matches[0]
$fullpath = $TPAMPerlTempFolder + $version

"`n--------------------------------------------------------------------------------" 
hostname
"`n" 

#Extract ZIP archive
Expand-ZIPFile -file $fullpath -destination $TPAMPerlTempFolder

$pathtomodule = $TPAMPerlTempFolder + "perl\" + $dv+ "\PpmDists\ParApi-ApiClient.ppd"
$cmd = "cmd"
$cmdargs = " /c ppm install $pathtomodule"

$psi = New-object System.Diagnostics.ProcessStartInfo 
$psi.CreateNoWindow = $true 
$psi.UseShellExecute = $false 
$psi.RedirectStandardOutput = $true 
$psi.RedirectStandardError = $true 
$psi.FileName = $cmd 
$psi.Arguments = @($cmdargs) 
$process = New-Object System.Diagnostics.Process 
$process.StartInfo = $psi 
[void]$process.Start()
$output = $process.StandardOutput.ReadToEnd() 
$output += $process.StandardError.ReadToEnd()
$process.WaitForExit() 

$output 


#Cleanup temporary directory
gci $TPAMPerlTempFolder | Remove-Item -Recurse -Force -Confirm:$false | out-null
 if (Test-Path $TPAMPerlTempFolder* ) {
     "Temporary files are not deleted successfully!" 
    } else {
     "Temporary files are deleted successfully." 
 }
}


foreach ($dispatcher in $dispatchers) { 
    $aut = Invoke-Command -ComputerName $dispatcher -ScriptBlock $ScriptBlock -ArgumentList ($version,$TPAMPerlTempFolder)
    $aut >> $log
}


#send mail
$emailFrom = "tpamresults@tpam.com" 
$subject="Perl API upload result"
$message = (Get-Content $log) -join "`n" 
$smtpserver="relayemea.prod.quest.corp"
$smtp=new-object Net.Mail.SmtpClient($smtpServer) 
$smtp.Send($emailFrom, $EmailAddr, $subject, $message)