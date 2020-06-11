function Show-GUIXaml
{
   <#
    .SYNOPSIS
        Show-GUIXaml creates a GUI interface based on a XAML file.

    .DESCRIPTION
        This function takes a XAML file to display a window on the screen, and provides variables to be used in events. It uses the WPF assemblies from the Microsoft .NET Framework.
   
    .EXAMPLE
        $win1 = Show-GUIXaml -Path .\sample.xaml; $button1.add_Click({$textbox1.Text += "Hello World!`n"}); $win1.ShowDialog() | out-null

        Creates a new window based on the file sample.xaml, then add an event handler using the button named button1 to add text to the element named textbox1, and finally show the window.
    #>
    Param([Parameter(Mandatory=$True)][string]$Path = $(throw "The parameter -Path is required."))

    [xml]$xml = Get-Content -Path $Path
    try
    {
        Add-Type -AssemblyName PresentationCore,PresentationFramework,WindowsBase,system.windows.forms
    }
    catch 
    {
        throw "Failed to load Windows Presentation Framework assemblies. Make sure the latest version of .NET Framework is installed."
    }

    $window = [Windows.Markup.XamlReader]::Load((new-object System.Xml.XmlNodeReader $xml))
    $xml.SelectNodes("//*[@Name]") | %{
        Set-Variable -Name ($_.Name) -Value $window.FindName($_.Name) -Scope Global
    }
    $window
}

Export-ModuleMember -Function Show-GUIXaml