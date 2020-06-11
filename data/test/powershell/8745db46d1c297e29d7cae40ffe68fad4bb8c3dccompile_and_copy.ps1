$msbuild = "C:\Windows\Microsoft.NET\Framework\v4.0.30319\MSBuild.exe"
$sln = "C:\Users\sg0219289\Desktop\wthyde\Automation\VS\helloWorld\helloWorld.sln"
$auto = "C:\Users\sg0219289\Desktop\wthyde\Automation"
$copyFrom = "C:\Users\sg0219289\Desktop\wthyde\Automation\VS\helloWorld\helloWorld\bin\Release"
$copyTo = "C:\Users\sg0219289\Desktop\wthyde\Automation\Scripts\copyLoc"
$options = "/p:Configuration=Release"
$clean = $msbuild + " $sln " + " $options " + " /t:Clean"
$build = $msbuild + " $sln " + " $options " + " /t:Build"
Invoke-Expression $clean
Invoke-Expression $build
Copy-Item $copyFrom\* $copyTo


