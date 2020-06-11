## ===================================================================
##                          Encode Data URI
## ===================================================================
## File:           Encode-DataURI.ps1
## Purpose:        Converts a file into a Data URI
## Author:         David Barsam
## URL:            https://github.com/dbarsam/.ps1
## ===================================================================

Param([string]$path, [string]$data="image", [string]$type, [switch]$clipboard)

# Determine the data type from the user or file extension
$extension = $type
if ($type)
{
    $extension = $type
}
else
{
    $extension = [System.IO.Path]::GetExtension($path)
    if ($extension)
    {
        $extension = $extension.Replace(".", "")
    }
}

if ($extension)
{
    $image  = "data:" + $data + "/" + $extension + ";base64,"  + [convert]::ToBase64String((get-content $path -encoding byte))
    if ($clipboard)
    {
        Out-Clipboard $image;
        $message = "Sent " + $path + " to clipboard..."
    }
    else
    {
        $message = $image
    }
}
else
{
    $message = "Could not determine file type of " + $path
}

Write-Host $message

