# BULK FILE COPY TOOL
# Ryan Currah
# Created: 7/30/2013
# Last Edited: 7/30/2013


###################### SET INITIAL VARIABLES ######################
# Load hostnames into memory
$hostnameFile = ".\hostname.txt"
$hostnameArray = @(Get-Content $hostnameFile)
$hostnameCount = $hostnameArray.count

# Result file if needed
$resultFile = "result.txt"
Clear-Content $resultFile

# Load File Names to Copy
#$fileNames = @("LON1_PACKAGES.bat", "LON2_PACKAGES.bat")
###################### END INITIAL VARIABLES ######################


############################ SET MENU #############################
# Give options
#Write-Host 'Please select the following...'
#Write-Host '1) To deploy file'
#Write-Host '2) To delete file'

# Ask for input
#$userSelection = Read-Host 'Please input 1 or 2'
############################ END MENU #############################


###################### START BUSINESS LOGIC #######################
Function check-even ($num) {[bool]!($num%2)}

for($i=0; $i -le ($hostnameCount - 1); $i++)
{
    $speed = "NULL"
    $speed = Get-WmiObject -ComputerName $hostnameArray[$i] -Class Win32_NetworkAdapter | Where-Object {$_.Name -like "*Intel*"} | select -ExpandProperty Speed
    
    $reult = $hostnameArray[$i] + ";" + $speed
    Add-Content $resultFile $reult
}

######################## END BUSINESS LOGIC ########################