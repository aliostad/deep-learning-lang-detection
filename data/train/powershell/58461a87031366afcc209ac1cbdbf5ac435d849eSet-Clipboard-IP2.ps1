$base_dir_env = Get-Item env:IP2ASSEMBLIES
$base_dir = $base_dir_env.Value
$first_path = Join-Path $base_dir 'Microsoft.Scripting.dll'
$second_path = Join-Path $base_dir 'IronPython.dll'
[reflection.assembly]::LoadFrom($first_path)
[reflection.assembly]::LoadFrom($second_path)

$engine = [ironpython.hosting.python]::CreateEngine()
$global:st = [microsoft.scripting.sourcecodekind]::Statements

$global:scope = $engine.CreateScope()
$global:ClipCode = $engine.CreateScriptSourceFromString(@'
import clr
clr.AddReference("System")
clr.AddReference("mscorlib")
clr.AddReference ("System.Windows.Forms")
from System.Windows.Forms import Clipboard
import System
from System.Threading import Thread, ThreadStart

def thread_proc():
     Clipboard.SetText(text)

t = Thread(ThreadStart(thread_proc))
t.ApartmentState = System.Threading.ApartmentState.STA
t.Start()
'@, $st)

Function global:Set-Clipboard ($Text){
  $scope.SetVariable('text', $Text)
  $params = @('microsoft.scripting.hosting.scriptscope')
  ./Invoke-GenericMethod $ClipCode 'Execute' $params $scope
}

