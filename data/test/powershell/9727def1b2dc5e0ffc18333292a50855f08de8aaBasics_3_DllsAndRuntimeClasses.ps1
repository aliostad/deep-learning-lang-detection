#**************************************************
Write-Host ****************************************
Write-Host Accessing System Namespaced Assemblies
Write-Host ****************************************
#**************************************************

#I think what's available is based on what's loaded in the GAC, not 100% sure on that. 

#instantiation
$date = New-Object -TypeName System.DateTime 2014, 1, 1, 16, 30, 45
Write-Host $date

#static properties or methods
$color = [System.Drawing.Color]::AliceBlue
Write-Host $color.A $color.B $color.G


#**************************************************
Write-Host ****************************************
Write-Host Loading External Assemblies
Write-Host ****************************************
#**************************************************

#will throw errors because it doesn't exist, but this is the idea. 

Add-Type -Path "C:/DemoPath/ninject.dll"
$kernel = New-Object -TypeName Ninject.StandardKernel


#**************************************************
Write-Host ****************************************
Write-Host Runtime Class Declaration - Parse C#
Write-Host ****************************************
#**************************************************

Add-Type @"
    public static class RuntimeCSharp {
        public static string Message {get{return "Hello";}}
    }
"@

$message = [RuntimeCSharp]::Message
Write-Host $message


#**************************************************
Write-Host ****************************************
Write-Host Runtime Class Declaration - Powershell Syntax
Write-Host ****************************************
#**************************************************

function New-RuntimeObject(
    [string]$Message
){
    $runtimeObj = New-Object PSObject
    $runtimeObj | Add-Member -Type NoteProperty  -Name Message -Value $Message
    return $runtimeObj
}

$instance = New-RuntimeObject -Message Hello
Write-Host $instance.Message