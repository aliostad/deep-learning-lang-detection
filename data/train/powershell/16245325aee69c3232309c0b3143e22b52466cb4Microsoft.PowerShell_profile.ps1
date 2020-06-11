#### Functions Used to Load VS Command Prompt #####
 
function Get-Batchfile ($file) {
    $cmd = "`"$file`" & set"
    cmd /c $cmd | Foreach-Object {
        $p, $v = $_.split('=')
        Set-Item -path env:$p -value $v
    }
}
 
function VsDevCmd()
{
    $vs110comntools = (Get-ChildItem env:VS110COMNTOOLS).Value    
    $batchFile = [System.IO.Path]::Combine($vs110comntools, "VsDevCmd.bat")
    Get-Batchfile $batchFile
    [System.Console]::Title = "Visual Studio " + $version + " Windows Powershell"
}
 
###### Functions Used to Load VS Command Prompt #####
 
###### Function Used to Set Background to Light Blue If not Admin ######
 
function AmIAdmin()
{
  $wid=[System.Security.Principal.WindowsIdentity]::GetCurrent()
  $prp=new-object System.Security.Principal.WindowsPrincipal($wid)
  $adm=[System.Security.Principal.WindowsBuiltInRole]::Administrator
  $IsAdmin=$prp.IsInRole($adm)
  $title = [System.Console]::Title
  if (!$IsAdmin)
  { 
    $title = $title + " (Non-Administrator)"
    #(Get-Host).UI.RawUI.Backgroundcolor="DarkGray"
  }
  else
  {
    $title = $title + " (Administrator)"
  }
  [System.Console]::Title = $title
}
 
 
###### Run Functions on Startup ######
VsDevCmd
AmIAdmin

