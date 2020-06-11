Framework "4.0"

properties {
	$baseDir = Resolve-Path ".."
	$outDir = "$(Resolve-Path "".."")\src\bin"
	$configuration = "Release"
}

Task default -Depends Build-Compiler, Build-Library

Task Clean {
	if (Test-Path $outDir) {
		rm -Recurse -Force "$outDir" >$null
	}
	md "$outDir" >$null
}

Task Compile -Depends Clean {
	Exec { msbuild "$baseDir\src\acute.sln" /verbosity:minimal /p:"Configuration=$configuration" }
}

Task Output-Binaries -Depends Compile {
	$acuteProjectTargetDir = "$baseDir\src\Acute\bin\$configuration"
	$msBuildProjectTargetDir = "$baseDir\src\Acute.Build\bin\$configuration\"
	$msBuildProjectTargetFileName = "Acute.Build.dll"
	copy "$acuteProjectTargetDir\Acute.dll" "$outDir"  
	copy "$acuteProjectTargetDir\Saltarelle.Linq.dll" "$outDir"  
	copy "$acuteProjectTargetDir\Saltarelle.Linq.xml" "$outDir"  
	copy "$baseDir\submodules\saltarelle.compiler\Runtime\CoreLib\bin\mscorlib.dll" "$outDir"  
	copy "$baseDir\submodules\saltarelle.compiler\Runtime\CoreLib\bin\mscorlib.xml" "$outDir"  
	copy $msBuildProjectTargetDir*.* "$outDir"  
	Exec { & "$baseDir\submodules\saltarelle.compiler\build\EmbedAssemblies.exe" /o "$outDir\$msBuildProjectTargetFileName" /a "$msBuildProjectTargetDir*.dll" /a "$msBuildProjectTargetDir*.exe"  $msBuildProjectTargetDir$msBuildProjectTargetFileName}
}

Task Output-Script -Depends Compile {
	$projectTargetDir = "$baseDir\src\Acute\bin\$configuration"
	$packagesDir = "$baseDir\src\Packages"

	#combine js file (no minification)
	Get-Content "$packagesDir\Saltarelle.Runtime.2.5.0\mscorlib.js","$packagesDir\Saltarelle.Linq.2.4.0\linq.js","$baseDir\submodules\angular.js\build\angular.js", "$baseDir\submodules\angular.js\build\angular-route.js",  "$baseDir\submodules\angular.js\build\angular-cookies.js", "$projectTargetDir\Acute.js" | Set-Content "$outDir\acute.js" 
	#use uglifyjs to minify js files
	Exec { uglifyjs "$packagesDir\Saltarelle.Runtime.2.5.0\mscorlib.js" "$packagesDir\Saltarelle.Linq.2.4.0\linq.js" "$baseDir\submodules\angular.js\build\angular.js" "$baseDir\submodules\angular.js\build\angular-route.js" "$baseDir\submodules\angular.js\build\angular-cookies.js" "$projectTargetDir\Acute.js" --output "$outDir\acute.min.js" --compress}
}

Task Nuget-Pack -Depends Output-Binaries, Output-Script {
	$contentDir = "$baseDir\build\nuget\Acute\content"
	$libDir = "$baseDir\build\nuget\Acute\lib"

	if (Test-Path $contentDir) {
		rm -Recurse -Force "$contentDir" >$null
	}
	if (Test-Path $libDir) {
		rm -Recurse -Force "$libDir" >$null
	}
	md $contentDir >$null
	md $libDir >$null

	copy "$outDir\Acute.Build.dll" "$baseDir\build\nuget\Acute\tools" 
	copy "$outDir\Acute.Compile.targets" "$baseDir\build\nuget\Acute\tools" 
	copy "$outDir\Acute.Compiler.exe" "$baseDir\build\nuget\Acute\tools" 
	copy "$outDir\Antlr3.Runtime.dll" "$baseDir\build\nuget\Acute\tools" 
	copy "$outDir\Castle.Core.dll" "$baseDir\build\nuget\Acute\tools" 
	copy "$outDir\Castle.Windsor.dll" "$baseDir\build\nuget\Acute\tools" 
	copy "$outDir\ICSharpCode.NRefactory.CSharp.dll" "$baseDir\build\nuget\Acute\tools" 
	copy "$outDir\ICSharpCode.NRefactory.dll" "$baseDir\build\nuget\Acute\tools" 
	copy "$outDir\ICSharpCode.NRefactory.IKVM.dll" "$baseDir\build\nuget\Acute\tools" 
	copy "$outDir\IKVM.Reflection.dll" "$baseDir\build\nuget\Acute\tools" 
	copy "$outDir\JavaScriptParser.dll" "$baseDir\build\nuget\Acute\tools" 
	copy "$outDir\JavaScriptParser.dll" "$baseDir\build\nuget\Acute\tools" 
	copy "$outDir\Saltarelle.Compiler.dll" "$baseDir\build\nuget\Acute\tools" 
	copy "$outDir\Saltarelle.Compiler.JSModel.dll" "$baseDir\build\nuget\Acute\tools" 
	copy "$outDir\acute.js" "$baseDir\build\nuget\Acute\" 
	copy "$outDir\acute.min.js" "$baseDir\build\nuget\Acute\content\" 
	copy "$outDir\mscorlib.*" "$baseDir\build\nuget\Acute\tools" 
	copy "$outDir\Acute.dll" $libDir 
	copy "$outDir\Saltarelle.Linq.*" $libDir 
	Exec{ & "$baseDir\build\nuget\nuget.exe" pack "$baseDir\build\nuget\Acute\Acute.nuspec" -NoPackageAnalysis}
} 

