[T4Scaffolding.Scaffolder(Description = "Payments.AuthNet - Builds the classes for the Authorize.Net payment provider")][CmdletBinding()]
param(        
    [string]$Project,
	[string]$CodeLanguage,
	[string[]]$TemplateFolders,
	[switch]$Force = $false
)

 $templates = 
 	@("HttpClient", `
		"WebApiManager", `
		"WebApiProvider", `
		"WebApiProviderCollection", `
		"WebApiSection")

foreach ($tml in $templates){
	$outputPath = $tml
	add-template $webapiProjectName $outputPath $tml -Force:$Force $TemplateFolders
}