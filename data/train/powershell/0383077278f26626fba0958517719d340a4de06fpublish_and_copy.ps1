$msbuild= "C:\Windows\Microsoft.NET\Framework\v4.0.30319\MSBuild.exe"
$loc = "C:\Users\sg0219289\Desktop\wthyde\Automation\VS\web\CMS"
$sln = "$loc\CMS.sln"
$proj = "$loc\WebApplication1\WebApplication1.csproj"
$options = "/p:Configuration=Release"
$copyFrom = "$loc\WebApplication1"
$copyTo = "C:\inetpub\wwwroot\CMS"
$clean = $msbuild + " $sln " + " $options " + " /t:Clean"
$build = $msbuild + " $sln " + " $options " + " /t:Build"
$publish = $msbuild + " $proj " + " $options " + " /t:publish"
Invoke-Expression $clean
Invoke-Expression $build
Invoke-Expression $publish
Invoke-Expression "iisreset /stop"
Remove-Item $copyTo\* -Recurse
Copy-Item $copyFrom\* $copyTo -Recurse
Remove-Item $copyTo\*.cs 
Remove-Item $copyTo\Account\*.cs 
Remove-Item $copyTo\Admin\*.cs 
Remove-Item $copyTo\App_Data\*.cs 
Remove-Item $copyTo\App_Start\*.cs 
Remove-Item $copyTo\bin\*.cs 
Remove-Item $copyTo\Content*.cs 
Remove-Item $copyTo\Images\*.cs 
Remove-Item $copyTo\obj\*.cs 
Remove-Item $copyTo\Properties\*.cs 
Remove-Item $copyTo\Scripts\*.cs 
Invoke-Expression "iisreset /start"