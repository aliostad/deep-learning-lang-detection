$pshost = get-host
$pswindow = $pshost.ui.rawui
$x86Path = (get-item 'Env:ProgramFiles(x86)').Value

$pswindow.windowtitle='PS A-Go-Go'
$pswindow.backgroundcolor = 'Black'
$pswindow.foregroundcolor = 'Gray'

$env:path += ';' + (get-item 'Env:ProgramFiles(x86)').value + '\Git\bin'

set-alias fsi ($x86Path + '\Microsoft SDKs\F#\4.0\Framework\v4.0\fsi.exe')

# load virtualenv wrapper
#import-module virtualenvwrapper

# Load posh-git example profile
. ($HOME + '\Documents\WindowsPowerShell\Modules\posh-git\profile.example.ps1')

#clear-host
