<#
.Synopsis
   Saves latest PowerShell Help files to disk
.DESCRIPTION
   1 - Checks to see if folder dated today exists.
            Creates new folder if needed.
   2 - Downloads latest PowerShell help files from web.
   3 - Saves help files to disk.
.EXAMPLE
   Update-OfflinePowerShellHelp
#>

# Today
$Today = Get-Date -uFormat "%Y-%m-%d"

# Path to save files - Change this value to default base location
$Path = "S:\PowerShell\Help\"

# Concatenate $Path + $Today 
$UNC = $Path + $Today


# Check to see if $UNC already exists
    if (!(Test-Path -Path $UNC))
        {# False - Create Folder
            $UNCnew = "Step 1 - Creating new folder " + $UNC
            Write-Output $UNCnew
            New-Item -Path $UNC -ItemType Directory
        }
    else
        {# True - Write output that folder already exists
            $UNCold = "Step 1 - Verified "+$UNC+" already exists"
            Write-Output $UNCold
        }

# Update PowerShell Help files from Internet
    Write-Output "Step 2 - Updating help files"
    Update-Help

# Save PowerShell Help files to $Path\%YYYY-MM-DD%
    Write-Output "Step 3 - Saving help files to disk"
    Save-Help -DestinationPath $UNC

Write-Output "Done"