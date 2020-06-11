[T4Scaffolding.Scaffolder(Description = "Generates MVVM Light MESSAGES for communication")][CmdletBinding()]
param(        
	[string]$ModelType,
	[string[]]$MessageTypes,
	[string]$PrimaryKeyName,
	[string]$MessageName,
	[string]$DomainContextName,
	[string]$Namespace,
	[string]$OutputFolder,
	[string]$DefaultNamespace,
	[string]$Area,
	[string]$Project,
	[string]$CodeLanguage,
	[string[]]$TemplateFolders,
	[switch]$Force = $false
)


#namespaces
if(!$Namespace)
{
	$namespace = (Get-Project $Project).Properties.Item("DefaultNamespace").Value
	$namespace = $namespace + ".Messages"
}

if(!$DefaultNamespace)
{
	$defaultNamespace = (Get-Project $Project).Properties.Item("DefaultNamespace").Value;
}

#ModelType
if ($ModelType) 
{
	$foundModelType = Get-ProjectType $ModelType -Project $Project
	if (!$foundModelType) 
	{
		return 
	}
}

#ModelType plural form
$modelTypeName = $foundModelType.Name;
$modelTypeNamePlural = [string](Get-PluralizedWord $foundModelType.Name);
if(!$modelTypeNamePlural)
{
	$modelTypeNamePlural = $foundModelType.Name + "s";
}

#Gets related entities for the ModelType
#if ($foundModelType) { $relatedEntities = [Array](Get-RelatedEntities $foundModelType.FullName -Project $project) }
if (!$relatedEntities) { $relatedEntities = @() }

#PrimaryKey of the ModelType
if(!$PrimaryKeyName)
{
	$primaryKeyName = $foundModelType.Name+"Id";
	#$primaryKeyName = [string](Get-PrimaryKey $foundModelType.FullName -Project $Project)
}
#OutputPath
if(!$OutputFolder)
{
	$outputFolder = "Messages"
}

#Construct Message class Name
if(!$MessageTypes)
{
	$MessageTypes = @("LaunchEdit",
					  "LaunchNew",
					  "Updated",
					  "Saved"
					  )
}

foreach($messageType in $MessageTypes)
{
	$messageName =  $messageType + $modelTypeName + "Message"

	$outputPath = $outputFolder+ "\" + $messageName  # The filename extension will be added based on the template's <#@ Output Extension="..." #> directive

	Add-ProjectItemViaTemplate $outputPath -Template MessageTemplate `
		-Model @{ 
				ModelType = $foundModelType; 
				PrimaryKeyName = $primaryKeyName;
				MessageName = $messageName;
				Namespace = $namespace;
				DefaultNamespace = $defaultNamespace;
				DomainContextName = $domainContextName; 
				ModelTypeNamePlural = $modelTypeNamePlural; 
				RelatedEntities = $relatedEntities} `
		-SuccessMessage "Added Message output at {0}" `
		-TemplateFolders $TemplateFolders -Project $Project -CodeLanguage $CodeLanguage -Force:$Force
}


Scaffold Message -ModelType $ModelType -MessageType Saved -MessageKind Dialog -Force:$force