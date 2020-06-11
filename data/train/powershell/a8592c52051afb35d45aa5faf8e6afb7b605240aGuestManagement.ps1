# Invoke-VMScript lets you run scripts inside VMs.
$hc = Get-Credential
$wgc = Get-Credential
Get-VM vCenter* | Invoke-VMScript -HostCredential $hc -GuestCredential $wgc -ScriptType Bat dir

# You can run inside Windows or Linux.
$lgc = Get-Credential
Get-VM rhel* | Invoke-VMScript -HostCredential $hc -GuestCredential $lgc "rpm -qa"

# Copy-VMGuestFile copies files into or out of guests via VMware Tools.
Get-VM rhel* | Invoke-VMScript -HostCredential $hc -GuestCredential $lgc "ls /tmp"
Get-VM rhel* | Copy-VMGuestFile -HostCredential $hc -GuestCredential $lgc -LocalToGuest c:\temp\temp.csv /tmp/temp.csv
Get-VM rhel* | Invoke-VMScript -HostCredential $hc -GuestCredential $lgc "ls /tmp"

# WMI is another way to manage your guests. It requires networking
# and firewall connectivity.
# Get-WmiObject lets you do anything WMI can do.
Get-WmiObject -ComputerName 10.91.246.20 win32_process -Credential $wgc | select ProcessName, VirtualSize