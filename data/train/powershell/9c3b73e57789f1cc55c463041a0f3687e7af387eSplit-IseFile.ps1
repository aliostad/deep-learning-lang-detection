function Split-IseFile
{
    <#
    .Synopsis
        Splits up a large file containing many functions into many files with one function each
    .Description
        Splits up a large file containing many functions into many files with one function each
    .Example
        Split-IseFile $psise.CurrentFile        
    #>
    param(
    # The ISE file to break up into smaller files
    [Parameter(ValueFromPipeline=$true)]    
    [Microsoft.PowerShell.Host.ISE.ISEFile]
    $File,
    
    # If set, the files will automatically be saved in the current directory.
    [switch]
    $Save
    ) 
    
    process {
        Get-FunctionFromFile $file | 
            New-IseScript | 
            ForEach-Object {
                if ($Save) { 
                    $_ | Save-IseFileWithAutoName
                }
            }
   }    
}