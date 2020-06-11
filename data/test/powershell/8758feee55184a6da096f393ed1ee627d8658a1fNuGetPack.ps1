param(
  [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
  [string]
  $apiKey,

  [Parameter(Mandatory = $false, Position=0)]
  [string]
  [ValidateSet('Push','Pack')]
  $operation = 'Push',

  [Parameter(Mandatory = $false, Position=1)]
  [string]
  $source = ''
)

function Get-CurrentDirectory
{
  $thisName = $MyInvocation.MyCommand.Name
  [IO.Path]::GetDirectoryName((Get-Content function:$thisName).File)
}

Import-Module (Join-Path (Get-CurrentDirectory) 'tools\Nuget.psm1')

$pubParams = @{
  Include = 'Midori';
  Path = (Get-CurrentDirectory);
  Source = $source;
  ApiKey = $apiKey;
  Force = $true;
}

if ($operation -eq 'Pack')
{
  $pubParams.KeepPackages = $true;
  $pubParams.Source = (Get-CurrentDirectory)
}

Publish-NuGetPackage @pubParams
