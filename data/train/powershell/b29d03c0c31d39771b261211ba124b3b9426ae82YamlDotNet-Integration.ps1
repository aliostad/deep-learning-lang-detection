function Load-YamlDotNetLibraries([string] $dllPath)
{
	gci $dllPath | % { [Reflection.Assembly]::LoadFrom($_.FullName) } | Out-Null
}

function Get-YamlStream([string] $file)
{
	$streamReader = [System.IO.File]::OpenText($file)
	$yamlStream = New-Object YamlDotNet.RepresentationModel.YamlStream
	
	$yamlStream.Load([System.IO.TextReader] $streamReader)
	$streamReader.Close()
    return $yamlStream	
}

function Get-YamlDocument([string] $file)
{
    $yamlStream = Get-YamlStream $file
	$document = $yamlStream.Documents[0]
    return $document
}

function Get-YamlDocumentFromString([string] $yamlString)
{
	$stringReader = new-object System.IO.StringReader($yamlString)
	$yamlStream = New-Object YamlDotNet.RepresentationModel.YamlStream
	$yamlStream.Load([System.IO.TextReader] $stringReader)
	
	$document = $yamlStream.Documents[0]
    return $document
}


function Convert-YamlSequenceNodeToList($node)
{
	$list = @()
	$yamlNodes = $node.Children
	
	foreach($yamlNode in $yamlNodes)
	{
		$list += Explode-Node $yamlNode
	}
	
	return $list
}

function Explode-Node($node)
{
	if ($node.GetType().Name -eq "YamlScalarNode")
	{
		return Convert-YamlScalarNodeToValue $node 
	}
	elseif ($node.GetType().Name -eq "YamlMappingNode")
	{
		return Convert-YamlMappingNodeToHash $node
	}
	elseif ($node.GetType().Name -eq "YamlSequenceNode")
	{	
		return Convert-YamlSequenceNodeToList $node
	}
}

function Convert-YamlScalarNodeToValue($node)
{
    return $node.Value
}

function Convert-YamlMappingNodeToHash($node)
{
    $hash = @{}
	$yamlNodes = $node.Children

    foreach($key in $yamlNodes.Keys)
    {
        $hash[$key.Value] = Explode-Node $yamlNodes[$key]
    }
	return $hash
}

