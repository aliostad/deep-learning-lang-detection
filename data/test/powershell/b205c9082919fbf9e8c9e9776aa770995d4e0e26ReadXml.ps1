#ReadXml.ps1--v2

#---------------------------------------------------------------------------------
# Parameters
#---------------------------------------------------------------------------------

param(
    [string]$xmlFile = $(throw "please specify an xml document to open!"),
    [string]$scriptFile = $(throw "please specify a script to chain!"),
    [object]$scriptParams0 = $null,
    [object]$scriptParams1 = $null
)

#---------------------------------------------------------------------------------
# Load Assemblies
#---------------------------------------------------------------------------------
[void] [Reflection.Assembly]::LoadWithPartialName("System");
[void] [Reflection.Assembly]::LoadWithPartialName("System.Xml.Linq");

#---------------------------------------------------------------------------------
# Process the xml file
#---------------------------------------------------------------------------------

$xd = [System.Xml.Linq.XDocument]::Load((Resolve-Path $xmlFile));
$elements = $xd.Root.Elements();

# Used by Write-Progress
[int]$total = 0;
[int]$count = 0;
foreach($xe in $elements) { $total++; }

# make the scroll bar not loop
write-progress -percentcomplete 1 -Activity Installing -Status Installing

foreach($xe in $elements)
{
	$d = New-Object "System.Collections.Specialized.StringDictionary";
	#each row
	foreach($data in $xe.Elements())
	{
		#each column
		$d[$data.Name.LocalName] = $data.Value;
	}
    
    # make the scroll bar not loop for first user
    $progressPercent = (($count / $total) * 70) + 30;
    if ($progressPercent -lt 1) { $progressPercent = 1; }
    
    write-progress -percentcomplete $progressPercent -Activity Installing -Status Installing
	iex ($scriptFile + ([string]" `$scriptParams0 $scriptParams1 `$d"));
	$count++;
}
