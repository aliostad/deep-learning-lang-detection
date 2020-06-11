#################################################################################
# ManageResources.ps1
# ed wilson, msft, 10/20/2007
#
# Uses get-wmiobject and the root\mscluster namespace and the 
# mscluster_cluster wmi class
# Removes a cluster
# *** remove and removeall gives generic failure BUT SHOULD work ***
#################################################################################
param(
      $computer="localhost",
      $namespace="root\mscluster",
      $name,
      [switch]$remove,
      [switch]$removeall,
      [switch]$fail,
      [switch]$offline,
      [switch]$online,
      [switch]$list,
      [switch]$whatif,
      [switch]$help
     )

function funHelp()
{
$helpText=@"
DESCRIPTION:
NAME: ManageResources.ps1
Manages resources on a cluster

PARAMETERS: 
-computer  name of the computer
-namespace name of the wmi namespace
-name      name of resource to manage
-remove    removes the named resource
-removeAll removes all resources 
-fail      initiates failure of resource
-offline   makes resource unavailable
-list      displays resource info
-whatif    prototypes the command
-help      prints help file

SYNTAX:
ManageResources.ps1 
Displays a parameter is required, and 
calls help

ManageResources.ps1 -list
Lists cluster configuration info

ManageResources.ps1 -remove

Removes the cluster 

ManageResources.ps1 -remove -whatif

Displays the following: what if: Perform operation 
Remove cluster

ManageResources.ps1 -help

Prints the help topic for the script

"@
 $helpText
 exit
} #end function funhelp

function funList()
 {
  $class = "mscluster_resource"
  $objWMI = Get-WmiObject -class $class `
            -computername $computer `
            -namespace $namespace
   $objWMI
  exit
  } #end function funList

function funRemoveAll()
 {
  $class = "mscluster_resource"
  $objWMI = Get-WmiObject -class $class `
            -computername $computer `
            -namespace $namespace |
            where-object { $_.name -match $name }
  foreach($objres in $objWMI)
   {
    $objres.deleteResource()
   }
  exit
  } #end function funRemoveAll

function funRemove()
 {
  $class = "mscluster_resource"
  $objWMI = Get-WmiObject -class $class `
            -computername $computer `
            -namespace $namespace |
            where-object { $_.name -match $name }
  foreach($objres in $objWMI)
   {
    $objres.deleteResource()
   }
   exit
  } #end function funRemove

function funfail()
 {
  $class = "mscluster_resource"
  $objWMI = Get-WmiObject -class $class `
            -computername $computer `
            -namespace $namespace |
            where-object { $_.name -match $name }
  foreach($objres in $objWMI)
   {
    $objres.failresource()
   }
    exit
  } #end function funfail

function funoffline()
 { 
  $class = "mscluster_resource"
  $objWMI = Get-WmiObject -class $class `
            -computername $computer `
            -namespace $namespace |
            where-object { $_.name -match $name }
  foreach($objres in $objWMI)
   {
    $objres.takeoffline()
   }
    exit
  } #end function funoffline

function funonline()
 { 
  $class = "mscluster_resource"
  $objWMI = Get-WmiObject -class $class `
            -computername $computer `
            -namespace $namespace |
            where-object { $_.name -match $name }
  foreach($objres in $objWMI)
   {
    $objres.bringOnline()
   }
    exit
  } #end function funonline

function funwhatif()
{
 if($removeall)
  { 
   "what if: Perform operation Remove all resources"
  }
 if($remove)
  {
   "what if: Perform operation Remove resource $name"
  }
  exit
}

if($help)      { "obtaining help" ; funhelp }
if($whatif)    { funwhatif }
if($remove)    { funRemove }
if($removeall) { funremoveall }
if($list)      { funlist }
if($fail)      { funfail }
if($online)    { funonline }
if($offline)   { funoffline }
if(!$remove -or !$removeall -or !$list -or !$fail -or !$offline)
  {
   "Missing parameter." ; funhelp
  }