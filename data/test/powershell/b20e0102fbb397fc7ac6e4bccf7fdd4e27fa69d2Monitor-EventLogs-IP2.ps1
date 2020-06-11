$base_dir_env = Get-Item env:IP2ASSEMBLIES
$base_dir = $base_dir_env.Value
$first_path = Join-Path $base_dir 'Microsoft.Scripting.dll'
$second_path = Join-Path $base_dir 'IronPython.dll'

[reflection.assembly]::LoadFrom($first_path)
[reflection.assembly]::LoadFrom($second_path)

$engine = [ironpython.hosting.python]::CreateEngine()
$st = [microsoft.scripting.sourcecodekind]::Statements
$scope = $engine.CreateScope()


$source = $engine.CreateScriptSourceFromString(@'
import clr
clr.AddReference('System')
from System.Diagnostics import EventLog

def handler(sender, event):
    print 'Entry from', sender.Log
    entry = event.Entry
    print entry.Message
    
logs = EventLog.GetEventLogs()
for log in logs:
    try:
        log.EnableRaisingEvents = True
        log.EntryWritten += handler
        print 'Added handler to', log.Log
    except:
        print 'Failed to add handler to', log.Log
'@, $st)

$source.Execute($scope)