Param
(
    # Warning Threshold 
    [Parameter(Mandatory=$false)]
    [int]
    $WarningThreshold = 80,

    # Error Threshold 
    [Parameter(Mandatory=$false)]
    [int]
    $ErrorThreshold = 90
)

$cpu = Get-CimInstance -ClassName CIM_Processor
$cpuUsageTotal = 0
$numberOfCPUs = 0
$metricObject = @{}

ForEach ($c in $cpu)
{
    # Add up the load percentage for each CPU
    $cpuUsageTotal += $c.LoadPercentage
    
    # Add the number of CPU's - didn't work with the $cpu.Lenght Property 
    $numberOfCPUs++

    # Add info on this CPU

    $metricObject."$($c.DeviceID.ToLower())_name" = $c.Name
    $metricObject."$($c.DeviceID.ToLower())_cores" = $c.NumberOfCores
    $metricObject."$($c.DeviceID.ToLower())_logicalprocessors" = $c.NumberOfLogicalProcessors
    $metricObject."$($c.DeviceID.ToLower())_loadpercentage" = $c.LoadPercentage
    $metricObject."$($c.DeviceID.ToLower())_availability" = $c.Availability
}

# Get average across all CPU's
$avgLoad = $cpuUsageTotal / $numberOfCPUs

if ($avgLoad -ge $ErrorThreshold)
{
    $sensu_status = 2
    $output = "CPU Average Load Percentage Over Error Threshold of $($ErrorThreshold)% - Currently $($avgLoad)%"
}
elseif ($avgLoad -gt $WarningThreshold)
{
    $sensu_status = 1
    $output = "CPU Average Load Percentage Over Warning Threshold of $($WarningThreshold)% - Currently $($avgLoad)%"
}
else
{
    $sensu_status = 0
    $output = "CPU Average Load Percentage OK - $($avgLoad)%"
}

$metricObject.output = $output
$metricObject.status = $sensu_status
$metricObject.cim_class_url = "https://msdn.microsoft.com/en-us/library/aa387978(v=vs.85).aspx"

return $metricObject
