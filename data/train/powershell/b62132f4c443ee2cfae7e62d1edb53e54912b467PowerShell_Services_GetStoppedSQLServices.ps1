# ===================================================================
# Author: Thomas Stringer
# Created on: 5/21/2012
#
# Description: shows stopped SQL Server services on a particular 
# 	machine.  Defaults to localhost
#
# Params:
#	-m : (optional) the machine name to show stopped services of
# ===================================================================

param (
	[string]$m = "localhost"
)

Get-Service -ComputerName $m | 
	Where-Object {($_.Name -like "*sql*") -and ($_.Status -eq "Stopped")} |
	Select-Object Status, DisplayName | Format-Table -AutoSize