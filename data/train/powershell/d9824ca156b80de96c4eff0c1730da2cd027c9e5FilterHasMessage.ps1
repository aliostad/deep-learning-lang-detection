# ------------------------------------------------------------------------
# NAME: FilterHasMessage.ps1
# AUTHOR: ed wilson, Microsoft
# DATE: 2/17/2009
#
# KEYWORDS: Filter
#
# COMMENTS: This script illustrates a filter that passes
# along event log entries that have message content. 
#
#
# PowerShell Best Practices
# ------------------------------------------------------------------------
Filter HasMessage
{
 $_ |
 Where-Object { $_.message }
} #end HasMessage

Get-WinEvent -LogName Application | HasMessage | Measure-Object