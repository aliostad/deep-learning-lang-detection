<#
.SYNOPSIS
    Expands a compressed archive (*.zip file) using the native facilities
    shipped with Windows and available out of the box.
.DESCRIPTION
    This will expand a compressed archive using the Windows shell, optionally
    showing either PowerShell or Windows (native UI) progress.
.EXAMPLE
    Expand-Zip 'C:\Users\Some User\somefile.zip'
.EXAMPLE
    Expand-Zip 'C:\Users\Some User\somefile.zip' 'C:\Users\Some User\Expanded\'
.PARAMETER ZipPath
    The path to the compressed archive to expand.
.PARAMETER Destination
    The path to the directory where the compressed files are expanded.
.PARAMETER StandardUI
    Use Windows' native UI for progress information and error dialogs.
.PARAMETER Force
    Answer "Yes to All" for any prompts that might be displayed.
.NOTES
    Original Author: M. Shawn Dillon
#Requires -Version 2.0
#>
function Expand-Zip
{
    param (
        [Parameter(Mandatory = $true)]
        [String] $ZipPath,
        [Parameter(Mandatory = $false)]
        [String] $Destination = (Join-Path `
            ([IO.Path]::GetDirectoryName([IO.Path]::GetFullPath($ZipPath))) `
            ([IO.Path]::GetFileNameWithoutExtension($ZipPath))),
        [Switch] $StandardUI,
        [Switch] $Force
    )

    begin
    {
        # Make sure we're using full paths rather than relative paths.
        $Path = [IO.Path]::GetFullPath($ZipPath)
        $Destination = [IO.Path]::GetFullPath($Destination)

        # Create the destination if it does not exist.
        if ((Test-Path $Destination -PathType Container) -eq $false)
        {
            New-Item $Destination -ItemType Directory | Out-Null
        }

        $shellApplication = New-Object -COM Shell.Application
        $sourceFolder = $shellApplication.NameSpace($Path)
        $destinationFolder = $shellApplication.NameSpace($Destination)

        $FolderOptions = 0

        if ($Force -eq $true)
        {
            ## Respond with "Yes to All" for any dialog box that is displayed.
            $FolderOptions = $FolderOptions + 16
        }

        if ($StandardUI -eq $false)
        {
            ## Suppress the native UI and any error dialogs.
            $FolderOptions = $FolderOptions + 1028
        }
    }

    process
    {
        if ($StandardUI -eq $true)
        {
            ## Let Windows manage the operation.
            $destinationFolder.CopyHere($sourceFolder.Items(), $FolderOptions)
        }
        else
        {
            $fileMap = New-Object 'System.Collections.Generic.Dictionary[System.Object,System.Object]'
            $stack = New-Object 'System.Collections.Generic.Stack[Object]'
            $nsMap = New-Object 'System.Collections.Generic.KeyValuePair[System.Object,System.Object]' @($sourceFolder,$destinationFolder)

            $stack.Push($nsMap)

            Write-Progress `
                -Activity 'Expanding compressed archive' `
                -Status $Path

            while ($stack.Count -gt 0)
            {
                $nsMap = $stack.Pop()

                $sourceNamespace = $nsMap.Key
                $destNamespace = $nsMap.Value

                foreach ($item in $sourceNamespace.Items())
                {
                    $destPath = $item.Path.Replace($Path, $Destination)

                    if ($item.IsFolder -eq $true)
                    {
                        if ((Test-Path $destPath -PathType Container) -eq $false)
                        {
                            New-Item $destPath -ItemType Directory | Out-Null
                        }

                        $sourceDirNamespace = $shellApplication.NameSpace($item)
                        $destDirNamespace = $shellApplication.NameSpace($destPath)

                        $nsMap = New-Object 'System.Collections.Generic.KeyValuePair[System.Object,System.Object]' @($sourceDirNamespace,$destDirNamespace)

                        $stack.Push($nsMap)
                    }
                    else
                    {
                        $destNamespace.CopyHere($item, $FolderOptions)
                    }

                    Write-Progress `
                        -Activity 'Expanding compressed archive' `
                        -Status $Path `
                        -CurrentOperation ($item.Path.Replace($Path, [String]::Empty).Substring(1))
                }
            }

            Write-Progress `
                -Activity 'Expanding compressed archive' `
                -Status $Path `
                -Completed
        }
    }

    end
    {
        $destinationFolder = $null
        $sourceFolder = $null
        $shellApplication = $null
        
        [GC]::Collect()
    }
}