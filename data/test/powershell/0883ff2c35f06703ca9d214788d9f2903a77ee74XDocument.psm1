[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Xml")
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Xml.Linq")

function New-XAttribute (
  [parameter(Mandatory=$true)]
  [PSObject] $Name,
  [parameter(Mandatory=$true)]
  [string] $Value
) {
  New-Object System.Xml.Linq.XAttribute @($Name, $Value)
}

function New-XElement (
  [parameter(Mandatory=$true,Position=0)]
  [string] $Name,
  [parameter(Mandatory=$false,ValueFromRemainingArguments=$true)]
  [PSObject[]] $Children = @()
) {
  $xname = [System.Xml.Linq.XName]::Get($Name)
  $element = New-Object System.Xml.Linq.XElement $xname
  $Children | Foreach { $element.Add($_) }
  $element
}

function New-XDocument (
  [parameter(Mandatory=$false,ValueFromRemainingArguments=$true)]
  [PSObject[]] $Children = @()
) {
  $doc = New-Object System.Xml.Linq.XDocument
  $Children | Foreach { $doc.Add($_) }
  $doc
}

function Select-XNode (
  [parameter(Mandatory=$true)]
  [string] $XPath,
  [parameter(Mandatory=$true,ValueFromPipeline=$true)]
  [System.Xml.Linq.XNode] $Node
) {
  process {
    [System.Xml.XPath.Extensions]::XPathEvaluate($Node, $XPath)
  }
}

function ConvertTo-XDocument (
  [parameter(Mandatory=$true,ValueFromPipeline=$true)]
  [xml] $Source
) {

  process {
    $reader = New-Object System.Xml.XmlNodeReader $Source
    try {
      [void] $reader.MoveToContent()
      [System.Xml.Linq.XDocument]::Load($reader)
    } finally {
      $reader.Close()
    }
  }
}

function ConvertFrom-XDocument (
  [parameter(Mandatory=$true,ValueFromPipeline=$true)]
  [System.Xml.Linq.XDocument] $Source
) {

  process {
    $reader = $Source.CreateReader()
    try {
      $doc = New-Object System.Xml.XmlDocument
      $doc.Load($reader)
      $doc
    } finally {
      $reader.Close()
    }
  }
}

function Get-XDocument (
  [parameter(Mandatory=$true)]
  [string] $Path,
  [parameter(Mandatory=$false)]
  [System.Text.Encoding] $Encoding = [System.Text.Encoding]::UTF8
) {

  if (-not (Test-Path $Path)) {
    throw "Unable to find '$Path'."
  }

  $Path = @(Get-ChildItem $Path)[0].FullName
  $reader = New-Object System.IO.StreamReader @($Path, $Encoding)
  
  try {
    [System.Xml.Linq.XDocument]::Load($reader)
  } finally {
    $reader.Close()
  }
}

function Set-XDocument (
  [parameter(Mandatory=$true)]
  [string] $Path,
  [parameter(Mandatory=$true,ValueFromPipeline=$true)]
  [System.Xml.Linq.XDocument] $Document
) {
  process {
    $Document.Save($Path)
  }
}

New-Alias xe New-XElement
New-Alias xa New-XAttribute
New-Alias xd New-XDocument
New-Alias sx Select-XNode

Export-ModuleMember -Function '*'
Export-ModuleMember -Alias '*'