# Load the module and its CmdLets
Import-Module Dramatic.NZBIndex


# Search t NZBIndex for a specific comic:
$NZBs = Search-StripArchief2015NZB -searchTerm thorgal, kriss 

$NZBs
# NZBTitle                                                                                   NZBUrl                                                                                     Title                                                                                    
# --------                                                                                   ------                                                                                     -----                                                                                    
# (Striparchief_2015_TT) - "Thorgal -- Kriss Van Valnor, De Werelden Van 01-04 (c).nzb" [... http://www.nzbindex.nl/download/115197956/Striparchief-2015-TT-Thorgal-Kriss-Van-Valnor... Thorgal -- Kriss Van Valnor, De Werelden Van 01-04 (c).nzb



$saveFolder = 'C:\temp\nzb\comics'
if (!(Test-Path $saveFolder))
{
    New-Item -Path $saveFolder -ItemType Directory | Out-Null
}
# And now download the found NZB file(s) to the save folder; 
# Make sure this is a SABNZB/NZBGet watched folder
$NZBs| foreach { Write-Host "Downloading NZB `"$($_.Title)`""; Invoke-WebRequest -Uri $_.NZBUrl -OutFile (Join-Path 'C:\temp\nzb\comics' $_.Title) }

