Function ConvertFrom-JSON {
    param(
        $json,
        [switch]$raw  
    )

    Begin
    {
      $script:startStringState = $false
      $script:valueState = $false
      $script:arrayState = $false 
      $script:saveArrayState = $false

      function scan-characters ($c) {
        switch -regex ($c)
        {
          "{" { 
            "(New-Object PSObject "
            $script:saveArrayState=$script:arrayState
            $script:valueState=$script:startStringState=$script:arrayState=$false       
              }
          "}" { ")"; $script:arrayState=$script:saveArrayState }

          '"' {
            if($script:startStringState -eq $false -and $script:valueState -eq $false -and $script:arrayState -eq $false) {
              '| Add-Member -Passthru NoteProperty "'
            }
            else { '"' }
            $script:startStringState = $true
          }

          "[a-z0-9A-Z@. ]" { $c }

          ":" {" " ;$script:valueState = $true}
          "," {
            if($script:arrayState) { "," }
            else { $script:valueState = $false; $script:startStringState = $false }
          } 
          "\[" { "@("; $script:arrayState = $true }
          "\]" { ")"; $script:arrayState = $false }
          "[\t\r\n]" {}
        }
      }
      
      function parse($target)
      {
        $result = ""
        ForEach($c in $target.ToCharArray()) {  
          $result += scan-characters $c
        }
        $result   
      }
    }

    Process { 
        if($_) { $result = parse $_ } 
    }

    End { 
        If($json) { $result = parse $json }

        If(-Not $raw) {
            $result | Invoke-Expression
        } else {
            $result 
        }
    }
}