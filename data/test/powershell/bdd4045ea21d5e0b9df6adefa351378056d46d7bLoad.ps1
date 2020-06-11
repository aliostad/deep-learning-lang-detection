$PreLoad = {
    # Note, we skip using Import-OMPModule as the required module is packaged
    # with this plugin.
    Import-Module (Join-Path $PluginPath 'fzf\bin\PSFzf\PsFzf.psm1') -Global -Force
}

$PostLoad = {
    Write-Output @'
Fuzzy logic provider has been loaded.  Here are a few things you can do with this:

- Ctrl+F = Search through your history in a cool new way (try invoke-FuzzyHistory
to do the same but also launch the results!)

- Alt+C = Change your current directory like a boss!

- Alt+A = Parse through your argument history.

'@

}
$Config = {}
$Shutdown = {}