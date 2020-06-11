#PowerShell.com POWERTIP of the Day
<#
Loading Additional Assemblies
When you want to load additional .NET assemblies to extend the types of object you can use, there are two ways of loading them: the direct .NET approach and the Add-Type cmdlet. Both examples do the same and open a MsgBox from PowerShell:
Direct .NET approach using reflection:
#>

$null = [System.Reflection.Assembly]::LoadWithPartialName('Microsoft.VisualBasic')
$date = [Microsoft.VisualBasic.Interaction]::InputBox('What is your birthday?')
$days = (New-TimeSpan -Start $date).Days
"You are $days days old."

#Using the Add-Type cmdlet:

Add-Type -AssemblyName Microsoft.VisualBasic
$date = [Microsoft.VisualBasic.Interaction]::InputBox('What is your birthday?')
$days = (New-TimeSpan -Start $date).Days
"You are $days days old."
<#
There is a crucial difference between these two methods, though. When you load an assembly using reflection, you load whatever version of that assembly exists on your machine. With Add-Type, the assembly version is hard-coded to the latest assembly.
#>