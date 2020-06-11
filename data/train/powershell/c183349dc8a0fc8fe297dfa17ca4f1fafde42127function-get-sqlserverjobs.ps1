function get-sqlserverjobs { 
<#
.SYNOPSIS
This function gets sqlserver jobs for a given sqlserver

.DESCRIPTION
Uses the sqlserver PSDrive to show sql agent jobs

To do:
- a switch to not do the refresh
- a switch to report all sqlservers in a list
  
This function is autoloaded by .matt.ps1

.PARAMETER ServerInstance
Specify the sqlserver

.INPUTS
None. You cannot pipe objects to this function

.EXAMPLE


#>
  [Alias ("gssj")]
  [CmdletBinding()]	
	Param( [String] $ServerInstance = $Global:ServerInstance ,
         [String][Alias ("include","job","jobname")] $filter = "*")

  if ($ServerInstance.IndexOf("\") -eq -1 )
  { 
    $ServerInstance = $ServerInstance + "\default" 
  }

  dir  Sqlserver:\sql\$ServerInstance\Jobserver\Jobs |
    foreach {$_.refresh() }

  dir Sqlserver:\sql\$ServerInstance\Jobserver\Jobs | 
    where-object name -like "*$filter*"
}




function show-sqlserverjobs { 
<#
.SYNOPSIS
This function shows sqlserver jobs for a given sqlserver

.DESCRIPTION
Uses the sqlserver PSDrive to show sql agent jobs

To do:
- a switch to not do the refresh
- a switch to report all sqlservers in a list

.PARAMETER ServerInstance
Specify the sqlserver

.PARAMETER Displaytype
Specify order and what is shown

.INPUTS
None. You cannot pipe objects to this function

.EXAMPLE



#>
  [CmdletBinding()]	
	Param( [String] $ServerInstance = "$Global:ServerInstance",
         [String] $DisplayType = "Alphabetical" )

  write-verbose "\$ServerInstance $ServerInstance"
  write-verbose "'$DisplayType $DisplayType"

  $JOBS = get-sqlserverjobs $ServerInstance |  where {$_.Category -ne 'Report Server'}
  write-verbose "got the jobs"
  write-output "Remember the show command excludes SSRS subscriptions"
  write-output "Use gjobs if you want them included back in"

  if ($DisplayType -eq "Alphabetical")
  {
    write-verbose "Doing an alphabetical list"
    $JOBS |
      ft @{Label ="Jobbie" ; 
           Expression={$_.name} ; 
           Width = 42 }, 
         @{Label="Last run" ; 
           Expression = {"{0:dd/MM/yy HH:mm}" -f $_.lastrundate} ; 
           width=14},  
         @{Label="Now"; 
           Expression = {$_.currentrunstatus} ; 
           Width = 5}, 
         lastrunoutcome
  }
  else

  { 
    write-verbose "Doing a chronological list"

    foreach ($J in $JOBS | sort-object -property lastrundate, name )
    {

      $duration = 0
      write-verbose "`$J.name $J.name"
      $SummedDurations =  $($J | select -expandproperty jobsteps | select lastrunduration | measure-object -property lastrunduration -sum | select sum)
      write-verbose "`$SummedDurations $($SummedDurations.sum)"

      $jobEndDate = $j.LastRunDate.AddSeconds($($SummedDurations.sum)).ToString()
      write-verbose "`$jobenddate $jobenddate"

      $J | ft @{Label ="Jobbie" ; 
             Expression={$_.name} ; 
             Width = 42 }, 
           @{Label="Last run" ; 
             Expression = {"{0:dd/MM/yy HH:mm}" -f $_.lastrundate} ; 
             width=14},  
           @{Label="Now"; 
             Expression = {$_.currentrunstatus} ; 
             Width = 5}, 
           lastrunoutcome

    }
  }
}
set-alias show-jobs show-sqlserverjobs
set-alias sjobs show-sqlserverjobs

set-alias get-jobs get-sqlserverjobs
set-alias gjobs get-sqlserverjobs


<#
vim: tabstop=2 softtabstop=2 shiftwidth=2 expandtab
#>


