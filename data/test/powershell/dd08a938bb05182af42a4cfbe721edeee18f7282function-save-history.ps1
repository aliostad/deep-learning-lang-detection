# ------------------------------
# save-history
# ------------------------------
function save-history { 
<#
.Synopsis
   Saves history to  \\$RepositoryServer\d$\dbawork\matt\history\history.txt

  This function is autoloaded by .matt.ps1
  
#>
    
  $folder = "c:\powershell\history\"
  foreach ($H in $(get-history -count 10000))
  {
     [datetime]$StartExecutionTime = $H.StartExecutionTime; 

     $FileName = $StartExecutionTime.ToString("yyyyMMdd")

     $FileName = "$FileName.txt"

     $H | select EndExecutionTime, ExecutionStatus, CommandLine | fl  >> $folder\$Filename

  }

}
set-alias shh save-history
