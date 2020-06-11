<#

.SYNOPSIS

Performs file download / copy using BITS.

.DESCRIPTION

The Get-SBDownLoad function checks that BITS is loaded, if it is not will load it.

To use the function, you need to pass two parameters. The Source of the file, and 

the Destination of the file.

If the BITS Module was not present when this function was called, it will be removed

following completion of the download.

.PARAMETER source 

A file name, or wildcard match for the file to be retreived.

.PARAMETER destination

The destination for the file(s) to be downloaded to.

.EXAMPLE

Get-SBDownLoad \\server\share\*.* c:\temp\

.NOTES

Download a copy of all files in "\\server\share\" and save them to "C:\temp"

The destination folder must exist.

#>

function Get-SBDownLoad {

param (

[string]$source,

[string]$destination

)

$Flag = 0

if (!(get-module -Name bitstransfer))

{

write-host "Installing BITS Module" ;

import-module "$PSHOME\Modules\BitsTransfer" ;

$Flag = 1

}

write-host "Now downloading $source to $destination."

Start-BITSTransfer -Source $source -Destination $destination -ProxyUsage override -ProxyList http://172.16.1.89:8080

if ($Flag = 1)

{

write-host "Removing BITS Module" ;

Remove-Module BitsTransfer

}

}