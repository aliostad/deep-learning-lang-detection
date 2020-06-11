# Editing this file is not recommended.

$BaseInteractivityCodeChange = {
# Start with the basics, name the command
    $Verb = "New"
    $Noun = $BaseType.Name
    
    # Give it a little bit of help
    $help.Synopsis = "Creates a new $($BaseType.FullName)" 
    $help.Description = "Creates a new $($BaseType.FullName)"
    $help.Example = @()
    $help.Example += "New-$Noun"

    
    # The first thing the command will need to do is construct the object
    $null = $ProcessBlocks.AddFirst({
        $controlProperties = @{} + $psBoundParameters
    })
    $null = $ProcessBlocks.AddAfter($ProcessBlocks.First, ([ScriptBlock]::Create("
        try {
        `$Object = New-Object $($BaseType.FullName) 
        Set-Property -inputObject `$Object -property `$controlProperties
        } catch {
            Write-Error `$_
            return
        } ")))
    
   
    # The last thing the command should do is output the object
    $null = $ProcessBlocks.AddLast(([ScriptBlock]::Create("
        `$Object")))
    
    
    # Collect all of the parameters for the type and add them to the parameters to the command    
    $params = @(ConvertTo-ParameterMetaData -type $BaseType)
    foreach ($p in $params) {
        $null = $parameters.AddLast($p)
    }   
}

# This file contains a series of rules which will help convert the types WPF
# interacts with the most to Script Cmdlets in PowerShell.  The rules are processed 
# in the order that they appear
Add-CodeGenerationRule -Type ([Windows.Forms.Control]) -Change $BaseInteractivityCodeChange
Add-CodeGenerationRule -Type ([windows.Forms.TreeNode]) -Change $BaseInteractivityCodeChange

$AddShowParameterCodeChange = {
    $help.Parameter.Show = "If Set, this will display the form and will output the object stored in the .Tag property, if one is present"    
    $help.Example += "New-$Noun -Show"
    if (-not $script:ShowParameter) {
        $script:ShowParameter = 
            New-Object Management.Automation.ParameterMetaData "Show",([Switch]) 
    }
    $null = $parameters.AddLast($Script:ShowParameter)
    if (-not $script:ShowParameterScriptBock) {
        $script:ShowParameterScriptBock = {
        if ($show) {                
            $showResult = $object.ShowDialog()
            if ($object.Tag) {
                $Object.Tag
            }
            return
        }}
    }
    
    
    $null = $processBLocks.AddFirst({ 
        if ($psBoundParameters.ContainsKey("Show")) {
        $null=$psBoundParameters.Remove("Show")
        }
    }) 
    $null = $processBlocks.AddBefore($processBlocks.Last, $script:ShowParameterScriptBock)
}

Add-CodeGenerationRule -Type ([Windows.Forms.Form]) -Change $addShowParameterCodeChange