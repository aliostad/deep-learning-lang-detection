<#
.DESCRIPTION 
    Loads all the Client Librairies into the PowerShell session
.NOTES
    Version :       1.0
    Author :        Sébastien Levert
    Date :          2014/11/29
.PARAMETER LibraryDirectory
    The directory where the client libraries reside
.EXAMPLE
    .\Load-SPOClientLibraries.ps1 -LibraryDirectory "ClientLibraries"
#>

#region Parameters
Param(
    [Parameter(Mandatory=$true)][ValidateNotNullOrEmpty()]
    [String]$LibraryDirectory
)
#endregion

#region References
#endregion

#region Private Methods
function Load-ClientLibrary()
{
	Param(
		[Parameter(Mandatory=$true)][ValidateNotNullOrEmpty()]
        $LibraryPath
	)
	
	Process { 
		Add-Type -Path $LibraryPath
	}
}
#endregion

#region Execution
Get-ChildItem $LibraryDirectory | ForEach-Object {
	Load-ClientLibrary $_.FullName
}
#endregion