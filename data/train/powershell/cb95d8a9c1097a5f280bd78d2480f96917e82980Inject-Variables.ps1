[CmdletBinding()]
Param(
  [string] $ConfigPath = "./Web.Config",
  $ConfigPathOut = $ConfigPath
)

function CheckPath {
    if (!(Test-Path $ConfigPath)){
        Throw ("Parameter -ConfigPath {0} does not exist" -f $ConfigPath)
    }
}

function LoadConfig {
    return Get-Content $ConfigPath
}

function ReplaceVariables {
    param($config, $envvariables)

    Foreach ($ev in $envvariables){
        $name = $ev.Name
        $value = $ev.Value
        $config = $config.replace("{{$name}}", $value)
    }
    return $config
}

function CheckForMissedTokens {
    param($config)

    $missedTokens = (Select-String -InputObject $config -Pattern "(?<={{)[^}]*(?=}})" -AllMatches | % {$_.Matches} | % {$_.Value })
    echo $missedTokens
    Foreach ($missedToken in $missedTokens){
        Throw ("Variable '{0}' in {1} that has not been replaced" -f $missedToken,$ConfigPath)
    }
}

CheckPath
$config = LoadConfig
$replacedConfig = ReplaceVariables $config (Get-ChildItem Env:)
CheckForMissedTokens $replacedConfig
Set-Content -Path $ConfigPathOut -Value $replacedConfig