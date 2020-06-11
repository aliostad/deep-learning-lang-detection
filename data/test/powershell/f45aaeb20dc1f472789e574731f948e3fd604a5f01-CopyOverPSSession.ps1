#region setup session
$PassWord = (ConvertTo-SecureString -String 'P@ssw0rd!' -AsPlainText -Force)
$SessionArgs = @{
    ComputerName = '10.10.10.20'
    Credential = [pscredential]::new('Administrator',$PassWord)
}
$CopySession = New-PSSession @SessionArgs
#endregion

#region ToSession
New-Item -Path c:\ -Name CDC.txt -Value 'PowerShell Rocks!' -ItemType File
Copy-Item -Path C:\CDC.txt -ToSession $CopySession -Destination C:\ -Force
#endregion

#region validate and stage
$CopySession | Enter-PSSession
Get-Item c:\CDC.txt
New-Item -Path c:\ -Name CDC2.txt -Value 'CDC Rocks!' -ItemType File
Exit-PSSession
#endregion

#region FromSession
Copy-Item -Path C:\CDC2.txt -FromSession $CopySession -Destination C:\ -Force
Get-Item C:\CDC2.txt
#endregion

#region Remote Edit
$CopySession | Enter-PSSession
psEdit c:\CDC.txt
Exit-PSSession
#endregion