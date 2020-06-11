##########################################################################

# Title: PowerShell Public Folders Permission App

# Author: Adam Loghides

# Created: 7 March 2013

# Purpose: Modifying Public Folder Permissions

###########################################################################

Function Funct {
	If ($Funct -eq "Add") {
		CLS
			$rights = Read-Host "Enter Permission Level (None, Owner, PublishingEditor, Editor, PublishingAuthor, Author, Non-EditingAuthor, Reviewer, Contributor)"
			$Folder = Read-Host "Enter Public Folder Name ex. 'Accounting Fax' (do not include the quotation marks... use help for a list)"
			$Folder1 = "\" + "$Folder"
			$user = Read-Host "Enter the username of the account you wish to grant permissions ex. adam.loghides"
		AddPerm
	}
	IF ($Funct -eq "Remove") {
		CLS
			$rights = Read-Host "Enter Permission Level (None, Owner, PublishingEditor, Editor, PublishingAuthor, Author, Non-EditingAuthor, Reviewer, Contributor)"
			$Folder = Read-Host "Enter Public Folder Name ex. 'Accounting Fax' (do not include the quotation marks... use help for a list)"
			$Folder1 = "\" + "$Folder"
			$user = Read-Host "Enter the username of the account you wish to remove permissions ex. adam.loghides"
		RemPerm
	}
	IF ($Funct -eq "Check")  {
		CLS
			$Folder = Read-Host "Enter Public Folder Name ex. 'Accounting Fax' (do not include the quotation marks... use help for a list)"
			$Folder1 = "\" + "$Folder"
			$user = Read-Host "Enter the username of the account you wish to check permissions ex. adam.loghides"
		CheckPerm
	}
	IF ($Funct -eq "Help") {
		CLS
		Help
	}
}

Function CheckPerm {
Get-PublicFolderClientPermission -Identity "$Folder1" | Select-Object User,AccessRights
}

Function AddPerm {
# $rights = Read-Host "Enter Permission Level (None, Owner, PublishingEditor, Editor, PublishingAuthor, Author, Non-EditingAuthor, Reviewer, Contributor)"
# $Folder = Read-Host "Enter Public Folder Name ex. "Accounting Fax" (do not include the quotation marks... use help for a list)"
# $Folder1 = "\" + "$Folder"
# $user = Read-Host "Enter the username of the account you wish to grant permissions ex. adam.loghides"
Add-PublicFolderClientPermission -Identity "$Folder1" -accessrights "$rights" -user $user
}

Function RemPerm {
# $rights = Read-Host "Enter Permission Level (None, Owner, PublishingEditor, Editor, PublishingAuthor, Author, Non-EditingAuthor, Reviewer, Contributor)"
# $Folder = Read-Host "Enter Public Folder Name ex. "Accounting Fax" (do not include the quotation marks... use help for a list)"
# $Folder1 = "\" + "$Folder"
# $user = Read-Host "Enter the username of the account you wish to remove permissions ex. adam.loghides"
Remove-PublicFolderClientPermission -Identity "$Folder1" -accessrights "$rights" -user $user -confirm
}

Function Help { 
Write-Host "Use this tool to manage public folder permissions."
Write-Host "You may either ADD or REMOVE public folder permissions for a specific user."
Write-Host "When prompted, enter the value requested.  For certain commands, the available vaules are listed in parenthesis as part of the prompt."
Write-Host
Write-Host "Commands are Help, Add, or Remove"
Write-Host "Here is a list of all of the public folders:"
Get-PublicFolder -Recurse -Identity \ | Select-Object Name
}

CLS
$header1 = "Welcome to the PowerShell Public Folders Permission App"
$header2 = "By Adam Loghides"
$header3 = '-' * $header1.length
Write-Host "$header1"
Write-Host "$header2"
Write-Host "$header3"
Write-Host
Write-Host
$Funct = Read-Host "Would you like to add or remove permissions? (Check, Add, Remove, or Help)"
Funct