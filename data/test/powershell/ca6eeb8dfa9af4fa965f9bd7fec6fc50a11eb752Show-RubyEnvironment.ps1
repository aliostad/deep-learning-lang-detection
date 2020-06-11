<#
  .SYNOPSIS
  Displays the current Ruby configurartion.
#>
function Show-RubyEnvironment{
  $registeredRubies = Get-RegisteredRubies
  $defaultRuby = Get-DefaultRuby
  $currentRuby = Get-CurrentRuby

  write-host "CURRENT RUBY: $currentRuby"
  write-host "DEFAULT RUBY: $defaultRuby"
  write-host "EXECUTABLES"
  Get-Command ruby | Select -Expand Path
  Get-Command gem | Select -Expand Path
  write-host "REGISTERED RUBIES:"
  $registeredRubies | foreach {write-host $_}

  write-host ""
  write-host "Run 'gem env' to see gem's picture of the Ruby Environment." -ForegroundColor Yellow
}
