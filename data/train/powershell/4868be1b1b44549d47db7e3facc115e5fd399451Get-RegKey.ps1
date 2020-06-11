### Create log files 

New-Item -ItemType file -Path .\Log\ConnectionFailure.txt -Value $null -Force
New-Item -ItemType file -Path .\Log\AuthenticationFailure.txt -Value $null -Force 
New-Item -ItemType file -Path .\Log\GenericFailure.txt -Value $null -Force
New-Item -ItemType file -Path .\Log\WMINull.txt -Value $null -Force

foreach ($server in $servers) {
 

 write-host "$server"

$credential = Get-ManageCredential -PasswordProxyWS $ws -CI $server



try {

$wmi = get-wmiobject -class "StdRegProv" -namespace root\default -computername $server -credential $credential -list

}

catch [System.Runtime.InteropServices.COMException] {

$server | Add-Content .\ConnectionFailure.txt
Write-Debug "Connection Failure"

}

catch [System.UnauthorizedAccessException] {

$server | Add-Content .\AuthenticationFailure.txt
Write-Debug "Authentication Failure"
}


catch {

$server | add-content .\GenericFailure.txt
Write-Debug "Generic Failure"
}


finally {

try {




$hklm = 2147483650
$key = "SYSTEM\CurrentControlSet\Control\Class\{4D36E972-E325-11CE-BFC1-08002BE10318}"
$valueList = 'TxPathValidationEnabled', 'RxPathValidationTime', 'TeamType'

$SubKeys = ($wmi.EnumKey($hklm,$key)) | select -ExpandProperty sNames



$array = @()
$arrayFailed = @()





foreach ($value in $valueList) {



        $wmiObj = ($wmi.GetDWORDValue($hklm,$key,$value)) | select uValue, ReturnValue
               
        write-host "$($wmiObj.ReturnValue) for $value in $key"


            if ($wmiObj.ReturnValue -ne 0) {



            }

            if (($wmiObj.ReturnValue -eq 0) -and ($value -eq 'TxPathValidationEnabled' -and $wmiObj.uValue -eq 1) -or ($value -eq 'RxPathValidationTime' -and $wmiObj.uValue -eq 1) -or ($value -eq 'TeamType' -and $wmiObj.uValue -eq 11)) {


                $object = New-Object -TypeName psobject
                $object | Add-Member -MemberType NoteProperty -Name Key -Value $null
                $object | Add-Member -MemberType NoteProperty -Name Value -Value $null
                $object | Add-Member -MemberType NoteProperty -Name Server -Value $null


                $object.Key = $value
                $object.Value = $wmiObj | select -ExpandProperty uValue
                $object.Server = $server
                $object.Value
                $array += $object
               }

             if ($wmiObj.ReturnValue -ne 0) {

                $object = New-Object -TypeName psobject
                $object | Add-Member -MemberType NoteProperty -Name Key -Value $null
                $object | Add-Member -MemberType NoteProperty -Name ReturnValue -Value $null
                $object | Add-Member -MemberType NoteProperty -Name Server -Value $null

                $object.Key = $value
                $object.ReturnValue = $wmiObj | select -ExpandProperty ReturnValue
                $object.Server = $server
                $object.Value
                $arrayFailed += $object

            }







    foreach ($Skey in $SubKeys) {

        $keyUp = $key + "\$Skey"

        <#

        $object = WMIQuery $hklm $keyUp $value

        $array += $object

        #>


        
        $wmiObj = ($wmi.GetDWORDValue($hklm,$keyUp,$value)) | select uValue, ReturnValue
               
        write-host "$($wmiObj.ReturnValue) for $value in $skey"




            if (($wmiObj.ReturnValue -eq 0) -and ($value -eq 'TxPathValidationEnabled' -and $wmiObj.uValue -eq 1) -or ($value -eq 'RxPathValidationTime' -and $wmiObj.uValue -eq 1) -or ($value -eq 'TeamType' -and $wmiObj.uValue -eq 11)) {


                $object = New-Object -TypeName psobject
                $object | Add-Member -MemberType NoteProperty -Name Key -Value $null
                $object | Add-Member -MemberType NoteProperty -Name Value -Value $null
                $object | Add-Member -MemberType NoteProperty -Name Server -Value $null
                $object | Add-Member -MemberType NoteProperty -Name Path -Value $null

                $object.Key = $value
                $object.Value = $wmiObj | select -ExpandProperty uValue
                $object.Server = $server
                $object.Value
                $object.Path = $keyUp
                $array += $object

            } 

            if ($wmiObj.ReturnValue -ne 0) {

                $object = New-Object -TypeName psobject
                $object | Add-Member -MemberType NoteProperty -Name Key -Value $null
                $object | Add-Member -MemberType NoteProperty -Name ReturnValue -Value $null
                $object | Add-Member -MemberType NoteProperty -Name Server -Value $null
                $object | Add-Member -MemberType NoteProperty -Name Path -Value $null

                $object.Key = $value
                $object.ReturnValue = $wmiObj | select -ExpandProperty ReturnValue
                $object.Server = $server
                $object.Value
                $object.Path = $keyUp
                $arrayFailed += $object

            }



                
           

    }
}





}



catch [System.Management.Automation.RuntimeException] {
Write-Debug "WMI call returned null"
$server | Add-Content .\WMINull.txt
}

}

}


$array2 = $arrayFailed | select Server | Group-Object


diff -ReferenceObject $array2 -DifferenceObject $array1 | Export-Csv -Path .\failed.csv
$array | export-csv -Path .\RegValues.csv

<# Paths

TxPathValidationEnabled  - eq 1 
RxPathValidationTime     - eq 1
TeamType      - eq b (11 in decimal)
#>


<#

$hklm = 2147483650
$key = 'SYSTEM\CurrentControlSet\Control\Class\{4D36E972-E325-11CE-BFC1-08002BE10318}\0008'
$valueList = 'TxPathValidationEnabled'

($wmi.GetDWORDValue($hklm,$key,$value))
#>