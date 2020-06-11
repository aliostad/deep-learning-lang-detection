$destination = "D:\SpreadAT\Spread\V1\SL\ProductBuild\"
mkdir $destination -Force
Remove-Item $destination -Recurse -Force
mkdir $destination -Force

$destination = "D:\SpreadAT\Spread\V1\WPF\ProductBuild\"
mkdir $destination -Force
Remove-Item $destination -Recurse -Force
mkdir $destination -Force


$sourcedir = "\\xa-spreadjp-at1\SpreadV1DailyBuild\"
$destination1 = "D:\SpreadAT\Spread\V1\SL\ProductBuild"


$source1 = $sourcedir + "\Silverlight\GrapeCity.Silverlight.Spread.dll"
Copy-Item $source1 -Destination  $destination1
$source1 = $sourcedir + "\Silverlight\GrapeCity.Silverlight.CalcEngine.dll"
Copy-Item $source1 -Destination  $destination1
$source1 = $sourcedir + "\Silverlight\GrapeCity.Silverlight.Spread.Designer.exe"
Copy-Item $source1 -Destination  $destination1
$source1 = $sourcedir + "\Silverlight\GrapeCity.Silverlight.InputMan.Common.dll"
Copy-Item $source1 -Destination  $destination1
$source1 = $sourcedir + "\Silverlight\GrapeCity.Silverlight.InputMan.dll"
Copy-Item $source1 -Destination  $destination1
$source1 = $sourcedir + "\Silverlight\GrapeCity.Silverlight.Spread.InputManCell.dll"
Copy-Item $source1 -Destination  $destination1

$destination2 = "D:\SpreadAT\Spread\V1\WPF\ProductBuild"

$source2 = $sourcedir + "\WPF\GrapeCity.Wpf.Spread.dll"
Copy-Item $source2 -Destination  $destination2
$source2 = $sourcedir + "\WPF\GrapeCity.Wpf.CalcEngine.dll"
Copy-Item $source2 -Destination  $destination2
$source2 = $sourcedir + "\WPF\GrapeCity.WPF.InputMan.dll"
Copy-Item $source2 -Destination  $destination2
$source2 = $sourcedir + "\WPF\GrapeCity.Wpf.Spread.Designer.exe"
Copy-Item $source2 -Destination  $destination2
$source2 = $sourcedir + "\WPF\GrapeCity.Wpf.Spread.InputManCell.dll"
Copy-Item $source2 -Destination  $destination2

