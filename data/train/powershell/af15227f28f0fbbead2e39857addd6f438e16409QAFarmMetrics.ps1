Param(
[Parameter(Mandatory=$True)][String]$EvalServer
)

# Import QA Toolkit
Import-Module ".\XA65_QAv01.psm1" -ErrorAction SilentlyContinue
Add-PSSnapin Citrix* -ErrorAction SilentlyContinue


$CTXload = (Get-XAServerLoad -ServerName $EvalServer).Load

[Int]$FreeRAM = (Get-WmiObject -Class Win32_OperatingSystem -ComputerName $EvalServer | 
       Select -Property FreePhysicalMemory | Ft -HideTableHeaders |
       Out-String)
[Int]$FreeRAM = ([Math]::round($FreeRAM / 1000))
[String[]]$FreeRAM = ($FreeRAM).ToString() + "MB"

[String]$CPULoad = Get-WmiObject -Class Win32_Processor -ComputerName $EvalServer |
           Measure-Object -Property LoadPercentage -Average | Select Average |
           Ft -HideTableHeaders | Out-String
        $CPULoad = (($CPULoad) -replace '\s+','')
[String[]]$CPULoad = $CPULoad + "%"
[BigInt]$FreeHDD = (Get-WmiObject -Class Win32_LogicalDisk -ComputerName $EvalServer |
           Where-Object {$_.DeviceID -eq "C:"} | Select FreeSpace | 
           ft -HideTableHeaders | Out-String).Trim()
[Int]$FreeHDD = $FreeHDD / 1GB
[String[]]$FreeHDD = ($FreeHDD).ToString() + "GB"


$conn = Connect-MySQL -hostname mysqlHost -username DBuser -pass DBpass -database farm_monitor
$query = $null
$query2 = $null
$query3 = $null
$query4 = $null
[String]$query = "UPDATE ctx_info SET ctx_info.load=" + "'" + $CTXload + "'" + ' WHERE hostname=' + "'" + $EvalServer + "'" + ';'
[String]$query2 = "UPDATE system_info SET system_info.cpuload=" + "'" + $CPULoad + "'" + ' WHERE hostname=' + "'" + $EvalServer + "'" + ';'
[String]$query3 = "UPDATE system_info SET system_info.ramusage=" + "'" + $FreeRAM + "'" + ' WHERE hostname=' + "'" + $EvalServer + "'" + ';'
[String]$query4 = "UPDATE system_info SET system_info.hddusage=" + "'" + $FreeHDD + "'" + ' WHERE hostname=' + "'" + $EvalServer + "'" + ';'
WriteMySQLQuery -conn $conn -query $query
WriteMySQLQuery -conn $conn -query $query2
WriteMySQLQuery -conn $conn -query $query3
WriteMySQLQuery -conn $conn -query $query4