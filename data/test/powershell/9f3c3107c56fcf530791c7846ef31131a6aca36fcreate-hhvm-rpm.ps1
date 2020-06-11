
<# Require the package, password, repouser and repopass name as parameter to build #>
param (
  [string]$package = $(throw "-package is required."),
  [string]$password = $(throw "-password is required."),
  [string]$repouser = $(throw "-repouser is required."),
  [string]$repopass = $(throw "-repopass is required."),
  [string]$repo = $(throw "-repo is required."),
  [string]$port = $(throw "-port is required.")
)
 
<# Set all required variables. #>
$PackageArray = @( "ulyaoth-hhvm3.13", "ulyaoth-hhvm3.12", "ulyaoth-hhvm3.11", "ulyaoth-hhvm3.9", "ulyaoth-hhvm3.6" )
$MachineArray = @{ 'ced4ecfc-6d6d-4d68-9881-96a0b0753411' = '192.168.1.120'; 'a705a5d7-9d97-454b-b683-c478afc9f67c' = '192.168.1.106'; '4fd05e17-169c-4835-8716-088142f2c3b8' = '192.168.1.104'; '111bc301-86f8-4fb7-bf49-3d143fb69ba7' = '192.168.1.102'; 'cc41ec2f-7aae-47d9-a910-70b02b71d535' = '192.168.1.100'; '952260f7-c1c8-4424-ab91-bbce560f401b' = '192.168.1.116'; '9be402dd-887c-45a3-bcd1-f23b601d7df0' = '192.168.1.110'; '29859737-1b3f-47cd-af6a-b4c854b0f998' = '192.168.1.113'; '73dfb8bf-2b07-4b2e-8c8a-17d7c6668668' = '192.168.1.119' }
$machinename = Get-Random

<# Set the correct build variable based on package input #>
if ($PackageArray -contains $package)
{
  $build = "wget https://raw.githubusercontent.com/ulyaoth/repository/master/ulyaoth-rpm-build.sh ; chmod +x ulyaoth-rpm-build.sh ; ./ulyaoth-rpm-build.sh -b $package -u $repouser -r $repo -p $port"
}
Else
{
  "Only a supported Ulyaoth repository package can be used as input."
  exit
} 
 
"CHECK 0: a valid package parameter was provide ($package)."
 
 
<# check if the ulyaoth directory exist and if not then create it #>
if(!(Test-Path -Path c:\ulyaoth\createrpm))
  {
   new-item c:\ulyaoth\createrpm -itemtype directory
   "The directory 'c:\ulyaoth\createrpm' was created."
  }
else
  {
   "CHECK 1: c:\ulyaoth\createrpm  directory already exists"
  }
  
  <# check if the plink application exist and if not then download it #>
  if(!(Test-Path -Path c:\ulyaoth\createrpm\plink.exe))
  {
   Invoke-WebRequest -uri https://downloads.ulyaoth.net/exe/putty/0.63/plink.exe -Method Get -OutFile c:\ulyaoth\createrpm\plink.exe
   "The program plink was downloaded."
  }
else
  {
   "CHECK 2: putty program is already available"
  }
  
  <# check if the psftp application exist and if not then download it #>
  if(!(Test-Path -Path c:\ulyaoth\createrpm\psftp.exe))
  {
   Invoke-WebRequest -uri https://downloads.ulyaoth.net/exe/putty/0.63/psftp.exe -Method Get -OutFile c:\ulyaoth\createrpm\psftp.exe
   "The program psftp was downloaded."
  }
else
  {
   "CHECK 3: psftp program is already available"
  }

ForEach ($buildbox in $MachineArray.GetEnumerator()) 
{
<# Create the virtual machine #>
& "C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" clonevm $buildbox.Name --name buildhhvm-$machinename --mode all --options keepallmacs --register
"Creating the virtual machine"

<# Modify the virtual machine #>
& "C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" modifyvm buildhhvm-$machinename --vram 128 --cpus 4 --memory 8192
"We are building $package so increasing Memory to 8GB and cpus to 4."

<# Start the virtual machine #>
& "C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" startvm buildhhvm-$machinename --type headless
"Starting the virtual machine"
  
<# Sleep for 60 seconds so machine can boot #>
"Sleeping 60 seconds while waiting for the Virtual Machine to boot."
Start-Sleep -Seconds 60

<# ssh into the machine and start the rpm build process #>
"Running the build script"
echo y | c:\ulyaoth\createrpm\plink.exe -ssh -l root $buildbox.Value -pw $password "$build"

<# Poweroff the virtual machine #>
& "C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" controlvm buildhhvm-$machinename poweroff
"Stopping the virtual machine"

<# Sleep for 15 seconds so machine can power off #>
"Sleeping 15 seconds while waiting for the Virtual Machine to power off."
Start-Sleep -Seconds 15

<# Delete the virtual machine #>
& "C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" unregistervm --delete buildhhvm-$machinename
"Deleting the virtual machine"

<# Sleep for 10 seconds before looping again #>
"Sleeping 10 seconds just to make sure the delete operation is finished."
Start-Sleep -Seconds 10
}
