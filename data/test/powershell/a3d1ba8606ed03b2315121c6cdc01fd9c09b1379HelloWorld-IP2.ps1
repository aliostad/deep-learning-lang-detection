$base_dir_env = Get-Item env:IP2ASSEMBLIES
$base_dir = $base_dir_env.Value
$first_path = Join-Path $base_dir 'Microsoft.Scripting.dll'
$second_path = Join-Path $base_dir 'IronPython.dll'
[reflection.assembly]::LoadFrom($first_path)
[reflection.assembly]::LoadFrom($second_path)

$engine = [ironpython.hosting.python]::CreateEngine()
$st = [microsoft.scripting.sourcecodekind]::Statements
$code = 'print "Hello World from IP2!"'
$source = $engine.CreateScriptSourceFromString($code, $st)
$scope = $engine.CreateScope()
$source.Execute($scope)
