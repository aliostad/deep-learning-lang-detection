Add-Type -Assembly PresentationCore, PresentationFrameWork

trap{ break }

$mode = [System.Threading.Thread]::CurrentThread.ApartmentState
if($mode -ne "STA"){
    $m = "This script can only be run when powershell is " +
        "started with the -sta switch."
    throw $m
}

function Add-PSScriptRoot($file){
    $caller = Get-Variable -Value -Scope 1 MyInvocation
    $caller.MyCommand.Definition |
        Split-Path -Parent |
            Join-Path -Resolve -ChildPath $file
}

$xamlPath = Add-PSScriptRoot search.xaml

$stream = [System.IO.StreamReader] $xamlPath
$form = [System.Windows.Markup.XamlReader]::Load(
    $stream.BaseStream)
$stream.Close()

$Path = $form.FindName("Path")
$Path.Text = $PWD

$FileFilter = $form.FindName("FileFilter")
$FileFilter.Text = "*.ps1"

$TextPattern = $form.FindName("TextPattern")
$Recurse = $form.FindName("Recurse")

$UseRegex = $form.FindName("UseRegex")
$UseRegex.IsChecked = $true

$FirstOnly = $form.FindName("FirstOnly")

$Run = $form.FindName("Run")
$Run.add_Click({
    $form.DialogResult = $true
    $form.Close()
})

$Show = $form.FindName("Show")
$Show.add_Click({Write-Host (Get-CommandString)})

$Cancel = $form.FindName("Cancel")
$Cancel.add_Click({$form.Close()})

function Get-CommandString{
    function fixBool($val){'$' + $val}
    "Get-ChildItem $($Path.Text) ``
        -Recurse: $(fixBool $Recurse.IsChecked) ``
        -Filter '$($FileFilter.Text)' |
            Select-String -SimpleMatch: (! $(fixBool $UseRegex.IsChecked)) ``
                -Pattern '$($TextPattern.Text)' ``
                -List: $(fixBool $FirstOnly.IsChecked)"
}

if($form.ShowDialog()){
    $cmd = Get-CommandString
    Invoke-Expression $cmd
}


