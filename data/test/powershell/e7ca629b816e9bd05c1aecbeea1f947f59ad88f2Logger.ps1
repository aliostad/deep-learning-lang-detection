class Logger {
    [String]$FilePath

    [void]debug([String]$Message) { $this.log('DEBUG', $Message) }
    [void]info([String]$Message)  { $this.log('INFO',  $Message) }
    [void]warn([String]$Message)  { $this.log('WARN',  $Message) }
    [void]error([String]$Message) { $this.log('ERROR', $Message) }
    [void]fatal([String]$Message) { $this.log('FATAL', $Message) }


    hidden [void]log([String]$Level, [String]$Message) {
        $event = $this.format((Get-Date), $Level, $Message)
        if ($this.FilePath) {
            $event | Out-File -FilePath $this.FilePath -Append -Encoding utf8
        } else {
            Write-Host $event
        }
    }

    hidden [String]format([DateTime]$Timestamp, [String]$Level, [String]$Message) {
        return ("{0:s} {1,5} {2}" -f ($TimeStamp, $Level.ToUpper(), $Message))
    }
}