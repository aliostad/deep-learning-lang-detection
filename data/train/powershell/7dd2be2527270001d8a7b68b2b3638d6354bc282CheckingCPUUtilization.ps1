#example 1:

Get-Counter "\Processor(_Total)\% Processor Time" -Continuous

#example 2:

Get-WmiObject Win32_Processor | select LoadPercentage

#example 3:

function Get-ProcessorUsage {
  param(
    [Parameter(
      Position=0,
      ValueFromPipelineByPropertyName=$true,
      Mandatory=$true)]
    [String]$Name   
  )
  
  process {
   $CPU = (Get-Counter "\Processor(_total)\% Processor Time" `
   -ComputerName $Name).CounterSamples[0].CookedValue.ToString('N2')
  
   New-Object PSObject -Property @{
    Server = $Name
    "CPU Usage (%)" = [int]$CPU
   }
  }
}


#example 4:

Get-ExchangeServer | Get-ProcessorUsage

#example 5:

while($true) {
  Get-ExchangeServer | Get-ProcessorUsage
  Start-Sleep -Seconds 5
}


#example 6:

Get-WmiObject Win32_Processor | 
  Measure-Object -Average LoadPercentage | 
    select -expand Average


#example 7:

foreach($server in Get-ExchangeServer) {
  Get-WmiObject Win32_Processor -ComputerName $server.Name | 
    Measure-Object -Average –Property LoadPercentage | 
      select @{n="Server";e={$server.Name}},
             @{n="CPU Usage (%)";e={$_.Average}}
}


#example 8:

function Get-ProcessorUsage {
  param(
    [Parameter(
      Position=0,
      ValueFromPipelineByPropertyName=$true,
      Mandatory=$true)]
    [String]$Name   
  )
  
  process {
   [int]$CPU = Get-WmiObject Win32_Processor `
    -ComputerName $Name | 
      Measure-Object -Average –Property LoadPercentage | 
        Select-Object -ExpandProperty Average
    
   New-Object PSObject -Property @{
    Server = $Name
    "CPU Usage (%)" = $CPU
   } 
  }   
}
