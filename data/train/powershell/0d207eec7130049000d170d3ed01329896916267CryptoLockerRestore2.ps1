function CryptoLockerRestore2{
    <#
    .SYNOPSIS

    Used for restoring a CryptoLocker infected directory structure from backup. Use with the variant of CryptoLocker which doesn't rename the files to .encrypted.

    IMPORTANT NOTE: Before using this script, visit https://www.decryptcryptolocker.com/ and see whether your files are able to be decrypted using the keys recovered during Operation Tovar.
    
    .DESCRIPTION

    Iterates a directory recursively and looks in each folder for a file named "DECRYPT_INSTRUCTION.TXT". 
	If this file exists, it will attempt to restore all files in that direction from a backup copy

    .PARAMETER liveFolder

    The path where the encrypted files reside.

    .PARAMETER backupCopy

    The path where the most recent backup resides. Generally this will be a locally mounted image-based backup.
    Ensure that this path points to the equivalent root directory of liveFolder

    .PARAMETER testMode

    Set this to $true to display a report of what would have occurred.

    Set to $false to actually perform the restores.
    
    .EXAMPLE

    CryptoLockerRestore2 -liveFolder "C:\Data" -backupCopy "X:Data" -testMode $false
    
    .NOTES

    You need to run this function as a user who has read and write access to the directory tree.

    #>
    param( 
         [string]$liveFolder   = $(throw "LiveFolder parameter not specified") 
        ,[string]$backupCopy     = $(throw "BackupCopy parameter not specified")
        ,[boolean]$testMode= $(throw "testMode parameter not specified")) 
    
    write-host "Enumerating files..."
    
    gci -LiteralPath $liveFolder -Recurse | Where-Object {$_.Name -eq "DECRYPT_INSTRUCTION.TXT"} | % {
		$thisDirectory = $_.DirectoryName
		$thisDirectorySansRoot = $thisDirectory.Replace($liveFolder,"");
		
		$backupCopyPath = "$backupCopy$thisDirectorySansRoot"
		
		if ($testMode -eq $true)
		{
			write-host "'$backupCopyPath' would be copied over '$thisDirectory'";
		}
		else
		{
			write-host "Copying all files in '$backupCopyPath' over '$thisDirectory'";
			Copy-Item "$backupCopyPath\*" $thisDirectory -Force
		}
		
    }
    write-host "Completed"
}

