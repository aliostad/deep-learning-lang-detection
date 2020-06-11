param ($FileName)

if (Get-Item $FileName -ErrorAction SilentlyContinue)
{
    $Installed = $true
    }
else
{
    $Installed = $false
    }

$Api = New-Object -ComObject 'MOM.ScriptAPI'
$Bag = $Api.CreatePropertyBag()

$Bag.AddValue('Installed',$Installed)

$api.Return($bag)

$Bag