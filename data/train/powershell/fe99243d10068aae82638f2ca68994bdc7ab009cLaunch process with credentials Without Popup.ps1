# Launching a process with Specific User/Credentials WITHOUT popup
$user = "domain\User1"
$password = "P@ssw0rd" | ConvertTo-SecureString -AsPlainText -Force
$cred = New-Object system.Management.Automation.PSCredential($user, $password)
Start-Process notepad.exe -Credential $cred -LoadUserProfile