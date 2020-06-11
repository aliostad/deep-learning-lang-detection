function LaunchTestRunner([string] $testsExePath) {
	#This must be run with the current directory set to "Build\TestRunner"
						
	$testsDir = [System.IO.Path]::GetDirectoryName($testsExePath)
	if ($testsExePath -like "*\Micro-4.2\*") {
		$sdkDir = "..\MF.SDK\Micro-4.2"
	} else {
        #default to NETMF 4.3
		$sdkDir = "..\MF.SDK\Micro-4.3"
	}
	$exe = "$sdkDir\Microsoft.SPOT.Emulator.Sample.SampleEmulator.exe"
					
	#build a list of dependencies
	$workQueue = New-Object System.Collections.Queue
	$assembliesToLoad = @()
	$assemblyPaths = @()
	
	$workQueue.Enqueue($testsExePath)
	
	while ($workQueue.Count -gt 0) {
		$assemblyPath = $workQueue.Dequeue()
		if ($assemblyPaths -contains $assemblyPath) {
			continue
		}
							
		$assembly = [System.Reflection.Assembly]::ReflectionOnlyLoadFrom($assemblyPath)
		$assemblyPaths += $assemblyPath
		$assembliesToLoad += $assembly.FullName

		$referencedNames = $assembly.GetReferencedAssemblies()
		foreach ($name in $referencedNames) {
			if (!($assembliesToLoad -contains $name)) {
				$name = $name.Name
				$probePaths = % {
					"$testsDir\$name.dll"
					"$sdkDir\$name.dll"								
				}
				foreach ($probe in $probePaths) {
					if (Test-Path $probe) {
						$workQueue.Enqueue($probe)
					}
				}						
			}
		}
	}
	
	#build list of pe files from list of assembly paths
	$peFiles = @()
	foreach ($assemblyPath in $assemblyPaths) {
		$dir = [System.IO.Path]::GetDirectoryName($assemblyPath)
		$name = [System.IO.Path]::GetFileNameWithoutExtension($assemblyPath)
		$probePaths = %{
			"$dir\$name.pe"
			"$dir\le\$name.pe"
		}
		foreach ($probe in $probePaths) {
			if (Test-Path $probe) {
				$peFiles += """/load:$probe"""
				break
			}
		}						
	}
		
	Start-Process -FilePath $exe -ArgumentList $peFiles -Wait
}