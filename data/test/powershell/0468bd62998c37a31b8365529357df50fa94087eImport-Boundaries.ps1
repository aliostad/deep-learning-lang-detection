[Threading.Thread]::CurrentThread.CurrentCulture = 'en-US'
$XLSX = New-Object -ComObject "Excel.Application"

$BoundariesXLSXFile = "C:\Users\klarson\Downloads\Import-Boundaries\CM_Boundaries.xlsx"
$Path = (Resolve-Path $BoundariesXLSXFile).Path
$SavePath = $Path -replace ".xl\w*$",".csv"

$WorkBook = $XLSX.Workbooks.Open($Path)
$WorkBook.SaveAs($SavePath,6)
$WorkBook.Close($False)
$XLSX.Quit()

$Boundaries = Import-Csv $SavePath

foreach($Item in $Boundaries)
{
    Switch($item.'Boundary Type')
    {
        
        "IP Subnet" {$Type = 0}
        "Active Directory Site" {$Type = 1}
        "IPv6" {$Type = 2}
        "Ip Address Range" {$Type = 3}

    }
    
    $Arguments = @{DisplayName = $Item.'Display Name'; BoundaryType = $Type; Value = $Item.Value}

    Set-WmiInstance -Namespace "Root\SMS\Site_MHC" -Class SMS_Boundary -Arguments $Arguments -ComputerName MHCSCCM
}

