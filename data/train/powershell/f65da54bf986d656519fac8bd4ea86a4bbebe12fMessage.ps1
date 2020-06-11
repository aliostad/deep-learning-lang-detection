[T4Scaffolding.Scaffolder(Description = "Generates MVVM Light message for communication")][CmdletBinding()]
param(        
	[string]$ModelType,
	[string]$MessageType,
	[string]$PrimaryKeyName,
	[string]$MessageName,
	[string]$DomainContextName,
	[string]$Namespace,
	[string]$MessageKind, #Base, Dialog
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

if(!$MessageKind)
{
	$MessageKind = "Base";#Generated class iherits from BaseMessage
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

#Construct Message class Name
if(!$MessageType -and !$MessageName)
{
	return
}

if(!$MessageName)
{
	$messageNameSuffix = "Message";
	if($MessageKind = "Dialog")
	{
		$messageNameSuffix = "Dialog" + $messageNameSuffix
	}
	$messageName =  $messageType + $modelTypeName + $messageNameSuffix
}

#OutputPath
if(!$OutputFolder)
{
	$outputFolder = "Messages"
}

$outputPath = $outputFolder+ "\" + $messageName  # The filename extension will be added based on the template's <#@ Output Extension="..." #> directive

#Depending on MessageKind we call MessageTemplate or DialogMessageTemplate
if($MessageKind = "Dialog")
{
	Add-ProjectItemViaTemplate $outputPath -Template DialogMessageTemplate `
		-Model @{ 
				ModelType = $foundModelType; 
				PrimaryKeyName = $primaryKeyName;
				MessageName = $messageName;
				Namespace = $namespace;
				DefaultNamespace = $defaultNamespace;
				DomainContextName = $domainContextName; 
				ModelTypeNamePlural = $modelTypeNamePlural; 
				RelatedEntities = $relatedEntities} `
		-SuccessMessage "Added Dialog Message output at {0}" `
		-TemplateFolders $TemplateFolders -Project $Project -CodeLanguage $CodeLanguage -Force:$Force
}
else
{
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