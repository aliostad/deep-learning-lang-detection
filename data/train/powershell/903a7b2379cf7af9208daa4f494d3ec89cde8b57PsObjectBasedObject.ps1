function New-SapiVoice {
  $prototype = New-Prototype
  $prototype | Update-TypeName
  $prototype | Add-Function say {
    param([string]$message)
    $speaker = new-object -com SAPI.SpVoice
    ($speaker.Speak($message, 1)) | out-null
  }

  # Add a new property to this prototype
  $prototype | Add-Property Message1 "This is Message 1"
  $prototype | Add-ScriptProperty Message2 {"This is Message 2"}
  
  # Add a proxy property to this prototype
  $prototype | Add-ScriptProperty Message3 {$this.Message1} {param([String]$value); $this.Message1 = $value}
  
  # always return the base prototype
  $prototype
}

$voice = New-SapiVoice
#$voice.say($voice.Message1)
# says 'This is Message 1'

#$voice.say($voice.Message2)
# says 'This is Message 2'

#$voice.say($voice.Message3)
# says 'This is Message 1'

$voice.Message3 = "Rewriting Message 1 (via message 3)"

#$voice.say($voice.Message1)
# says 'Rewriting Message 1 (via message 3)'

#$voice.say($voice.Message3)
# 'says 'Rewriting Message 1 (via message 3)'