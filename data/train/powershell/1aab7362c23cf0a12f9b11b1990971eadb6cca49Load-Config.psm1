function Load-Config {
    param(
        [Parameter(Mandatory=$true)]
        [ValidateScript({Test-Path $_})]
        [string]$path
    )
    $global:appSettings = @{}

    $config = [xml](Get-Content $path)

    foreach ($addNode in $config.configuration.appsettings.add) {
        if ($addNode.Value.Contains(',')) {
            # Array case
            $value = $addNode.Value.Split(',')
            for ($i = 0; $i -lt $value.length; $i++) { 
                $value[$i] = $value[$i].Trim() 
            }
        }
        else {
            # Scalar case
            $value = $addNode.Value
        }
        $global:appSettings[$addNode.Key] = $value
    }
}