
$pathToCSV = $args[0]

function loadDataFromCSV($path)
    {
    import-csv -path "$pathToCSV" | foreach-object {createPrinter $_.ipAddress $_.driverPath $_.driverName $_.printerName}
    }

Function createPrinter($printerIPAddress, $driverPath, $driverName, $printerName)
    {
    createPort "$printerIPAddress"
    
    rundll32 printui.dll,PrintUIEntry /if /f "$driverPath" /r "IP_$printerIPAddress" /m "$driverName" /b "$printerName" /z /u
    }
    
Function createPort($portIPAddress)
    {
    $port = [wmiclass]"Win32_TcpIpPrinterPort" 
    $port.psbase.scope.options.EnablePrivileges = $true 
    $newPort = $port.CreateInstance() 
    $newport.name = "IP_$portIPAddress" 
    $newport.Protocol = 1 
    $newport.HostAddress = $portIPAddress 
    $newport.PortNumber = "9100" 
    $newport.SnmpEnabled = $false 
    $newport.Put()
    }

loadDataFromCSV "$pathToCSV"