<# Require the password to update all servers #>
param (
  [string]$password = $(throw "-password is required.")
)
 
<# Set all required variables. #>
$MachineArray = @{ 'cc41ec2f-7aae-47d9-a910-70b02b71d535' = '192.168.1.91'; '111bc301-86f8-4fb7-bf49-3d143fb69ba7' = '192.168.1.92'; '4fd05e17-169c-4835-8716-088142f2c3b8' = '192.168.1.93'; 'dff21ab0-7f79-4f75-b9fe-be371298471b' = '192.168.1.94'; '9be402dd-887c-45a3-bcd1-f23b601d7df0' = '192.168.1.95'; 'c1f6edf7-4363-4b72-9f8f-92216493352e' = '192.168.1.96'; '29859737-1b3f-47cd-af6a-b4c854b0f998' = '192.168.1.97'; 'a705a5d7-9d97-454b-b683-c478afc9f67c' = '192.168.1.98'; '82b9c8f4-1afe-4bed-a845-7a88b080aefe' = '192.168.1.99'; '864610ff-9373-4ab1-909a-ba2d25a208cd' = '192.168.1.100'; '1012bcbf-6bce-4312-b39f-0a94096022a6' = '192.168.1.101'; '20f33fac-e9cb-40ed-88b4-f5e0768cfc7b' = '192.168.1.102'; '31d4cc79-4391-44f4-beaa-57292463bc1f' = '192.168.1.103'; '7c64ee00-3040-4803-8f6e-4392c6fa6ef8' = '192.168.1.104'; '952260f7-c1c8-4424-ab91-bbce560f401b' = '192.168.1.105'; '98af04ef-2c20-490c-ac3f-bcd4b980e40d' = '192.168.1.106'; 'a1b5baaf-3cce-4920-9170-eb7a24d09768' = '192.168.1.107'}


<# check if the ulyaoth directory exist and if not then create it #>
if(!(Test-Path -Path c:\ulyaoth\yumupdate))
  {
   new-item c:\ulyaoth\yumupdate -itemtype directory
   "The directory 'c:\ulyaoth\yumupdate' was created."
  }
else
  {
   "CHECK 1: c:\ulyaoth\yumupdate  directory already exists"
  }
  
  <# check if the plink application exist and if not then download it #>
  if(!(Test-Path -Path c:\ulyaoth\yumupdate\plink.exe))
  {
   Invoke-WebRequest -uri https://trash.ulyaoth.net/trash/exe/putty/0.63/plink.exe -Method Get -OutFile c:\ulyaoth\yumupdate\plink.exe
   "The program plink was downloaded."
  }
else
  {
   "CHECK 2: plink program is already available"
  }
  
ForEach ($buildbox in $MachineArray.GetEnumerator()) 
{
<# Start the virtual machine #>
& "C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" startvm $buildbox.Name
"Starting the virtual machine"
  
<# Sleep for 30 seconds so machine can boot #>
"Sleeping 30 seconds while waiting for the Virtual Machine to boot."
Start-Sleep -Seconds 30

<# ssh into the machine and start the update process #>
"Running yum update"
echo y | c:\ulyaoth\createrpm\plink.exe -ssh -l root $buildbox.Value -pw $password "yum install -y update"

<# Reboot the server #>
"Rebooting the server"
echo y | c:\ulyaoth\createrpm\plink.exe -ssh -l root $buildbox.Value -pw $password "reboot"

<# Sleep for 35 seconds so machine can reboot #>
"Sleeping 35 seconds while waiting for the Virtual Machine to reboot."
Start-Sleep -Seconds 35

<# Shutdown the server #>
"Shutdown the server"
echo y | c:\ulyaoth\createrpm\plink.exe -ssh -l root $buildbox.Value -pw $password "shutdown -h now"
}

Remove-Item c:\ulyaoth\yumupdate -Force -Recurse
