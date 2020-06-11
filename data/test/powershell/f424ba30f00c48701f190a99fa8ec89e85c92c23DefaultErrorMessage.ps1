function Get-DefaultErrorMessage{
  param(
    [Parameter(Mandatory=$true,Position=0)]
    $ErrorObject
  )
    switch($ErrorObject.GetType().FullName){
      'System.Collections.ArrayList'{
        $tmpErrorObject = $ErrorObject[0]
      }
      'System.Management.Automation.ErrorRecord'{
        $tmpErrorObject = $ErrorObject
        break
      }
      default{
        throw "Unknown variable type"
      }
    }
    [String]$tmpLogMessage = $null;
    $tmpLogMessage = `
        $("{0} errored at line {1} char {2} with message: {3}" -f `
        $tmpErrorObject.InvocationInfo.ScriptName, `
        $tmpErrorObject.InvocationInfo.ScriptLineNumber, `
        $tmpErrorObject.InvocationInfo.OffsetInLine, `
        $tmpErrorObject.Exception.Message)
    return $tmpLogMessage
}

Export-ModuleMember -Function @(
    'Get-DefaultErrorMessage'
)