#
# Clear-RecycleBin.ps1
#

#1. create 25 temporary files (using the PowerShell 5 New-TemporaryFile cmdlet)
	# 1..25 | % {New-TemporaryFile }
#2. look at the Temporary folder to ensure that I have the temporary files there
	# explorer.exe $([io.path]::GetTempPath())
#3. delete the temporary files
	# dir $([io.path]::GetTempPath()) | Remove-Item -Recurse

#show what in the recycle bin.
(New-Object -ComObject Shell.Application).NameSpace(0x0a).Items() | Select-Object Name,Size,Path
#clean up the recycle bin
Clear-RecycleBin -Force
