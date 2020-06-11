Function Show-ComputerInstallDate {
Param(
[Parameter(ValueFromPipelinebypropertyname=$true,Position=0)]
$Computername=(ls Env:\COMPUTERNAME).value

) 

begin {

$fmt = "{0,-25}  {1,-45}  {2,-30}"

$fmt -f "System Name","OS Version", "Installation Date"
}

Process{
trap {continue}
Try {
$os = Get-WmiObject win32_operatingsystem -comp $computername -erroraction SilentlyContinue
$fmt -f $os.csname,$os.caption,$os.ConvertToDateTime($os.InstallDate) 
}
Catch {}

}
}



# now test it
ipmo activedirectory
Get-ADComputer -filter * | Show-ComputerInstallDate

#"cookham8","cookham1" | Show-ComputerInstallDate