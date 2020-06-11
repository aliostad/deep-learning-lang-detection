Class CeleryBroker {
    [ref]$App
    [hashtable] $Conf = @{}


    CeleryBroker($App)
    {
        Write-Verbose "CeleryBroker Constructor"
        if ($this.GetType() -eq [CeleryBroker])
        {
            throw("The CeleryBroker Class must be inherited")
        }

        #Add reference to Parent App
        $this.App = $App
    }

    [hashtable] create_task_message(
        [string]$task_id                      = $null,
        [string]$name                         = $null,
        [Object[]]$taskArgs                   = $null,
        [hashtable]$kwargs                    = $null
    )
    {
        Throw "this method must be implemented $($this.create_task_message)"
        return @{}
    }

    [Object] send_task_message($message, $options)
    {
        Throw "this method must be implemented  $($this.send_task_message)"
    }

    on_message_received($request)
    {
        
    }

}