Function Open-PoshPAIGAbout {
	$rs=[RunspaceFactory]::CreateRunspace()
	$rs.ApartmentState = "STA"
	$rs.ThreadOptions = "ReuseThread"
	$rs.Open()
	$ps = [PowerShell]::Create()
	$ps.Runspace = $rs
    $ps.Runspace.SessionStateProxy.SetVariable("pwd",$pwd)
	[void]$ps.AddScript({ 
[xml]$xaml = @"
<Window
    xmlns='http://schemas.microsoft.com/winfx/2006/xaml/presentation'
    xmlns:x='http://schemas.microsoft.com/winfx/2006/xaml'
    x:Name='AboutWindow' Title='About' Height = '170' Width = '330' ResizeMode = 'NoResize' WindowStartupLocation = 'CenterScreen' ShowInTaskbar = 'False'>    
        <Window.Background>
        <LinearGradientBrush StartPoint='0,0' EndPoint='0,1'>
            <LinearGradientBrush.GradientStops> <GradientStop Color='#C4CBD8' Offset='0' /> <GradientStop Color='#E6EAF5' Offset='0.2' /> 
            <GradientStop Color='#CFD7E2' Offset='0.9' /> <GradientStop Color='#C4CBD8' Offset='1' /> </LinearGradientBrush.GradientStops>
        </LinearGradientBrush>
    </Window.Background>     
    <StackPanel>
            <Label FontWeight = 'Bold' FontSize = '20'>PowerShell Patch/Audit GUI </Label>
            <Label FontWeight = 'Bold' FontSize = '16' Padding = '0'> Version: 2.1.7 </Label>
            <Label FontWeight = 'Bold' FontSize = '16' Padding = '0'> Created By: Boe Prox </Label>
            <Label Padding = '10'> <Hyperlink x:Name = 'AuthorLink'> http://learn-powershell.net </Hyperlink> </Label>
            <Button x:Name = 'CloseButton' Width = '100'> Close </Button>
    </StackPanel>
</Window>
"@
#Load XAML
$reader=(New-Object System.Xml.XmlNodeReader $xaml)
$AboutWindow=[Windows.Markup.XamlReader]::Load( $reader )


#Connect to Controls
$CloseButton = $AboutWindow.FindName("CloseButton")
$AuthorLink = $AboutWindow.FindName("AuthorLink")

#PsexecLink Event
$AuthorLink.Add_Click({
    Start-Process "http://learn-powershell.net"
    })

$CloseButton.Add_Click({
    $AboutWindow.Close()
    })

#Show Window
[void]$AboutWindow.showDialog()
}).BeginInvoke()
}