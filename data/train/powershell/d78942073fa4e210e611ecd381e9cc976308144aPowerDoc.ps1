Function Convert-ToScriptDoc{
    <#
    .Synopsis
    Generates a PowerShell HTML Documentation
    #>

    [CmdletBinding()]
    param(
        [Parameter(Position=0, Mandatory=$true, HelpMessage='Enter path with all scripts')]
        [Alias('InputPath')]
        [String]        
        $strScriptPath,        
        
        [Parameter(Position=1, Mandatory=$true, HelpMessage='Enter path where doc gets stored')]
        [Alias('OutputPath')]
        [String]        
        $strDocPath
    )

    begin{

        $arrScripts = Get-ChildItem $strScriptPath
    
    }

    process{
    
    }

}
