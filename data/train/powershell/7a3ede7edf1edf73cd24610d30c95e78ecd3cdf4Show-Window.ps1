function Show-Window {
    <#
    .Synopsis
        Show-Window shows a WPF control within a window, 
        and is used by the -Show Parameter of all commands within WPK
    .Description
        Show-Window displays a control within a window and adds several resources to the window
        to make several scenarios (like timed events or reusable scripts) easier to accomplish
        within the WPF control.
    .Parameter Control
        The UI Element to display within the window
    .Parameter Xaml
        The xaml to display within the window
    .Parameter WindowProperty
        Any additional properties the window should have.
        Use the values of this dictionary as you would parameters to New-Window
    .Parameter OutputWindowFirst
        Outputs the window object just before it is displayed.
        This is useful when you need to interact with the window from outside 
        of the thread displaying it.
    .Example
        New-Label "Hello World" | Show-Window
    #>
    [CmdletBinding(DefaultParameterSetName="Window")]
    param(   
    [Parameter(Mandatory=$true,ParameterSetName="Control",
    ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true,
    Position=0)]      
    [Windows.Media.Visual]
    $Control,     

    [Parameter(Mandatory=$true,ParameterSetName="Xaml",ValueFromPipeline=$true,Position=0)]      
    [xml]
    $Xaml,
       
    [Parameter(ParameterSetName='Window',Mandatory=$true,ValueFromPipeline=$true,Position=0)]
    [Windows.Window]
    $Window,
                      
    [Hashtable]
    $WindowProperty = @{},
       
    [Switch]
    $OutputWindowFirst
    )
   
   process {
        try {
            $windowProperty += @{
                SizeToContent="WidthAndHeight"   
            }
        } catch {
            Write-Debug ($_ | Out-String)
        }
        switch ($psCmdlet.ParameterSetName) {
            Control {
                $window = New-Window
                Set-Property -inputObject $window -property $WindowProperty
                $window.Content = $Control
            }
            Xaml {
                $window = New-Window
                Set-Property -inputObject $window -property $WindowProperty
                $strWrite = New-Object IO.StringWriter
                $xaml.Save($strWrite)
                $Control = [windows.Markup.XamlReader]::Parse("$strWrite")
                $window.Content = $Control
            }
        }
        $Window.Resources.Timers = 
            New-Object Collections.Generic.Dictionary["string,Windows.Threading.DispatcherTimer"]
        $Window.Resources.TemporaryControls = @{}
        $Window.Resources.Scripts =
            New-Object Collections.Generic.Dictionary["string,ScriptBlock"]
        $Window.add_Closing({
            foreach ($timer in $this.Resources.Timers.Values) {
                if (-not $timer) { continue }
                $null = $timer.Stop()
            }
        })
        if ($outputWindowFirst) {
            $Window
        }
        $null = $Window.ShowDialog()            
        if ($Control.Tag) {
            $Control.Tag            
        } else {
            if ($Control.SelectedItems) {
                $Control.SelectedItems
            }
            if ($Control.Text) {
                $Control.Text
            }
            if ($Control.IsChecked) {
                $Control.IsChecked
            }
        }
        return                
   }
}
