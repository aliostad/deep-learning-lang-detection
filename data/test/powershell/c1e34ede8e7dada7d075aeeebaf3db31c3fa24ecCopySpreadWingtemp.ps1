
$sourcedir = "\\ssl-testserver\ProductBuild\"
$destination = "E:\GrapeCity\Spread\WPFSL\SSLPerformanceTest\Product\ProductBuild\"

mkdir $destination -Force
Remove-Item $destination -Recurse -Force

Copy-Item -Path $sourcedir -Destination $destination -PassThru -Force –Recurse



$sourcedir = "\\xa-spreadjp-at1\SpreadV1DailyBuild\"

$destination1 = "D:\SpreadAT\Spread\V1\SL\ProductBuild"
mkdir $destination1 -Force
Remove-Item $destination1 -Recurse -Force
mkdir $destination1

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

$destination2 = "E:\GrapeCity\Spread\WPFSL\Product\V1\SpreadWPF"
mkdir $destination2 -Force
Remove-Item $destination2 -Recurse -Force
mkdir $destination2

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

$sourcedir = "\\ssl-testserver\ProductBuild\"
$destination3 = "E:\GrapeCity\Spread\WPFSL\Product\V1\SpreadXSL"
mkdir $destination3 -Force
Remove-Item $destination3 -Recurse -Force
mkdir $destination3

$source3 = $sourcedir + "\SpreadXSL\GrapeCity.Silverlight.Excel.dll"
Copy-Item $source3 -Destination  $destination3
$source3 = $sourcedir + "\SpreadXSL\GrapeCity.SL.SpreadX.Data.dll"
Copy-Item $source3 -Destination  $destination3
$source3 = $sourcedir + "\SpreadXSL\GrapeCity.SL.SpreadX.UI.dll"
Copy-Item $source3 -Destination  $destination3
$source3 = $sourcedir + "\SpreadXSL\ICSharpCode.Silverlight.SharpZipLib.dll"
Copy-Item $source3 -Destination  $destination3

$destination4 = "E:\GrapeCity\Spread\WPFSL\Product\V1\SpreadXWPF"
mkdir $destination4 -Force
Remove-Item $destination4 -Recurse -Force
mkdir $destination4

$source4 = $sourcedir + "\SpreadXWPF\GrapeCity.SpreadX.WPF.Data.dll"
Copy-Item $source4 -Destination  $destination4
$source4 = $sourcedir + "\SpreadXWPF\GrapeCity.Wpf.Excel.dll"
Copy-Item $source4 -Destination  $destination4
$source4 = $sourcedir + "\SpreadXWPF\GrapeCity.WPF.SpreadX.UI.dll"
Copy-Item $source4 -Destination  $destination4
$source4 = $sourcedir + "\SpreadXWPF\ICSharpCode.Wpf.SharpZipLib.dll"
Copy-Item $source4 -Destination  $destination4


# copy to D:\, for smoking test
$destination1 = "D:\SpreadAT\Spread\V1\SL\ProductBuild"
mkdir $destination1 -Force
Remove-Item $destination1 -Recurse -Force
mkdir $destination1

$source1 = $sourcedir + "\SpreadSL\GrapeCity.Silverlight.Spread.dll"
Copy-Item $source1 -Destination  $destination1
$source1 = $sourcedir + "\SpreadSL\GrapeCity.Silverlight.Spread.pdb"
Copy-Item $source1 -Destination  $destination1
$source1 = $sourcedir + "\SpreadSL\GrapeCity.Silverlight.Spread.XML"
Copy-Item $source1 -Destination  $destination1


$destination2 = "D:\SpreadAT\Spread\V1\WPF\ProductBuild"
mkdir $destination2 -Force
Remove-Item $destination2 -Recurse -Force
mkdir $destination2

$source2 = $sourcedir + "\SpreadWPF\GrapeCity.Wpf.Spread.dll"
Copy-Item $source2 -Destination  $destination2
$source2 = $sourcedir + "\SpreadWPF\GrapeCity.Wpf.Spread.pdb"
Copy-Item $source2 -Destination  $destination2
$source2 = $sourcedir + "\SpreadWPF\GrapeCity.Wpf.Spread.xml"
Copy-Item $source2 -Destination  $destination2
