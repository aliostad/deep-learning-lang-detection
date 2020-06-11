$error.clear();
Set-StrictMode -Version:Latest
$GLOBAL:ErrorActionPreference               = "Stop"
# . "$PSCommandPath.vars.ps1"
."$PSCommandPath.vars.ps1"

try 
{
    Write-Verbose "BEGIN : NEUTRONS : TRY"
    ."$PSCommandPath.vars.ps1"

    import-module "$(RAILS_PATH_CORE)\write-commandlets\write-commandlets.ps1" -force  #leaving out noclobber, cause that's what this module is ALL about.

    $loaded = (import-module ( Resolve-Path "$SCRIPT:DIRECTORY_PATH_OF_pratom_ATOM_NUCLEUS_NEUTRONS\..\protons\protons.psm1" ) -force -DisableNameChecking) 
    set-alias pr_include Invoke-Expression
    
    pr_include (code_to_load_a_directory "$(RAILS_PATH_CORE)\logging\")
    pr_include (code_to_load_a_directory $(RAILS_PATH_ENV))
    pr_include (code_to_load_a_directory $(RAILS_PATH_LIB))
    Export-ModuleMember -function *
    Write-Verbose "END : NEUTRONS : TRY"   
}
finally
{
    Write-Verbose "END : NEUTRONS : FINALLY" 
}