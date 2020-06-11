#requires -version 2.0
Set-Alias sudo Invoke-RunAs

function Invoke-RunAs {
  <#
    .NOTES
        Author: greg zakharov
  #>
  param(
    [Parameter(Mandatory=$true, Position=0)]
    [String]$Program,
    
    [Parameter(Position=1)]
    [String]$Arguments,
    
    [Parameter(Position=2)]
    [Switch]$LoadProfile = $false,
    
    [Security.SecureString]$UserName = (Read-Host "Admin name" -as),
    [Security.SecureString]$Password = (Read-Host "Enter pass" -as)
  )
  
  begin {
    function get([Security.SecureString]$str) {
      return [Runtime.InteropServices.Marshal]::PtrToStringAuto(
        [Runtime.InteropServices.Marshal]::SecureStringToBSTR($str)
      )
    }
  }
  process {
    $psi = New-Object Diagnostics.ProcessStartInfo
    $psi.Arguments = $Arguments
    $psi.Domain = [Environment]::UserDomainName
    $psi.FileName = $Program
    $psi.LoadUserProfile = $LoadProfile
    $psi.Password = $Password
    $psi.UserName = (get $UserName)
    $psi.UseShellExecute = $false
    
    [void][Diagnostics.Process]::Start($psi)
  }
  end {}
}
