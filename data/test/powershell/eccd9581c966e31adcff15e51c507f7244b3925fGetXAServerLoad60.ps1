$snapins  = Get-PSSnapin Citrix.XenApp.Commands -ea 0

if ($snapins -eq $null)
{
   Get-PSSnapin -Registered "Citrix.XenApp.Commands" | Add-PSSnapin
}

$FarmName = Get-XAFarm | select -ExpandProperty FarmName
$ScriptRunTime = (get-date).ToFileTime()

Get-XAServerLoad -ServerName $Env:ComputerName | foreach-object {

    $Load = $_
    $output = $Load | Get-Member -MemberType Properties | foreach-object {
        $Key = $_.Name
        $Value = $Load.$Key -join ";" 
        '{0}="{1}"' -f $Key,$Value
    }

    $output += '{0}="{1}"' -f "FarmName",$FarmName
    $output += '{0}="{1}"' -f "ScriptRunTime",$ScriptRunTime
    
    Write-Host ("{0:MM/dd/yyyy HH:mm:ss} GMT - {1}" -f ((get-date).ToUniversalTime()),( $output -join " " ))

} 