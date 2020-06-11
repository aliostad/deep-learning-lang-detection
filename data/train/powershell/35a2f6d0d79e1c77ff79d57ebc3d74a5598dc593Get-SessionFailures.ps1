Function Get-SessionFailures
{
    <#
    #>
    Param
    (
        $Servers
    )
    
    Begin
    {
        foreach ($Server in $Servers)
        {
            $Computers = Get-WinEvent -LogName System -ComputerName $Server `
                |Where-Object {$_.ProviderName -eq "NETLOGON" -AND $_.Id -eq 5805} `
                |Select-Object -Property Message
            }
        $StartString = "The session setup from the computer "
        $EndString = " failed"
        }

    Process
    {
        foreach ($Computer in $Computers)
        {
            $ComputerName = ($Computer.Message).Replace($StartString,"")            
            (($Computer.Message).Replace($StartString,"")).IndexOf($EndString)
            Return $ComputerName
            }
        }

    End
    {
        
        }
}