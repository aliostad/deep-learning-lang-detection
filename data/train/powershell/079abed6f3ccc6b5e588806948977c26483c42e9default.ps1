Properties {
	$release = "1.0.3.93"
	$src = "..\source"
	$sln = "$src\LZ4.sln"
	$snk = "$src\LZ4.snk"
	$libz = "$src\packages\LibZ.Bootstrap.1.0.3.3\tools\libz.exe"
}

Include ".\common.ps1"

FormatTaskName (("-"*79) + "`n`n    {0}`n`n" + ("-"*79))

Task default -depends LibZ

Task LibZ -depends Release {
	Create-Folder libz
	
	copy-item any\*.dll libz\
	
	exec { cmd /c $libz inject-dll -a libz\LZ4.dll -i libz\*.dll -e LZ4.dll "--move" -k $snk }
}

Task Release -depends Rebuild {
	Create-Folder x86
	Create-Folder x64
	Create-Folder any

	copy-item "$src\LZ4\bin\Release\LZ4.dll" any\
	copy-item "$src\LZ4n\bin\Release\LZ4n.dll" any\
	copy-item "$src\LZ4s\bin\Release\LZ4s.dll" any\

	copy-item "$src\bin\Win32\Release\*.dll" x86\
	copy-item "$src\bin\x64\Release\*.dll" x64\

	copy-item x86\LZ4mm.dll any\LZ4mm.x86.dll
	copy-item x86\LZ4cc.dll any\LZ4cc.x86.dll

	copy-item x64\LZ4mm.dll any\LZ4mm.x64.dll
	copy-item x64\LZ4cc.dll any\LZ4cc.x64.dll
}

Task Version {
	Update-AssemblyVersion $src $release 'Tests', 'MixedModeAutoLoad'
}

Task Rebuild -depends VsVars,Clean,KeyGen,Version {
	Build-Solution $sln "Any CPU"
	Build-Solution $sln x86
	Build-Solution $sln x64
}

Task KeyGen -depends VsVars -precondition { return !(test-path $snk) } {
	exec { cmd /c sn -k $snk }
}

Task Clean {
	Clean-BinObj $src
	remove-item * -recurse -force -include x86,x64,any,libz
}

Task VsVars {
	Set-VsVars
}
