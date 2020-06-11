function Save-IseFileWithAutoName
{
    <#
    .Synopsis
        Saves a file within the Integrated Scripting Enviroment with an automatically generated name
    .Description
        Saves a file within the Integrated Scripting Enviroment with an automatically generated name.
        The Name of the file will be the first function found .ps1
    .Example
        Get-FunctionFromFile $psise.CurrentFile        
    #>
    param(
    # The File in the Windows PowerShell Integrated Scripting Environment
    # (i.e. $psise.CurrentFile)
    [Parameter(ValueFromPipeline=$true)]    
    [Microsoft.PowerShell.Host.ISE.ISEFile]
    $File
    ) 
    
    process {
        $tokens = Get-TokenFromFile -file $file
        if (-not $tokens) { return } 
        for ($i = 0; $i -lt $tokens.Count; $i++) {
            if ($tokens[$i].Content -eq "function" -and 
                $tokens[$i].Type -eq "Keyword") {
                    $functionName = $tokens[$i + 1].Content
                break
            }
        }
        if ($functionName) {
            $fileName = Join-Path $pwd "$functionName.ps1"
            $file.SaveAs($fileName)
        } else { $file.Save() } 
    }   
}