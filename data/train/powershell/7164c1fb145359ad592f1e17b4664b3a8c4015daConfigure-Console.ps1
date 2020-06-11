# Powershell links have console window settings
copy "Windows PowerShell (x86).lnk_" "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Accessories\Windows PowerShell\Windows PowerShell (x86).lnk"
copy "Windows PowerShell.lnk_" "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Accessories\Windows PowerShell\Windows PowerShell.lnk"
copy "Windows PowerShell.lnk_" "$env:HOMEDRIVE\$env:HOMEPATH\AppData\Roaming\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar\Windows PowerShell.lnk"

# More console window settings
& ".\Console Settings.reg"
 
"Console configured."