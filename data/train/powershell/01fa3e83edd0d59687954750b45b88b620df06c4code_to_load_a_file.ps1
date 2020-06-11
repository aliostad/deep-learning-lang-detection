<#
The caller of this function is either in :
    code_to_load_a_directory
        code_to_load_a_directorys_child_files 
        code_to_load_a_directory
or it is in the caller of import-module
#>
Function code_to_load_a_file
{
    [cmdletbinding()]
    Param (
        [Parameter(Mandatory=$true)][string]    $file_path_and_name
        , [Parameter(Mandatory=$false)][bool]    $everytime = $false
        ) 
    [string]$ret_code = ""


    if ( $file_path_and_name.EndsWith('.ps1') -eq $true )
    {
       $ret_code = ". $file_path_and_name;$nl" 
    }
    else {
        if ( $everytime -eq $false )
        {
            if ( (RAILS_ENV) -eq (RAILS_ENV.DEVELOPMENT) ) 
            { 
                $ret_code = "$(pr_everytime -file_path_and_name:$file_path_and_name);$nl"
            }
            else {
                
            }        
        }
        else {
            $ret_code = "$(pr_everytime -file_path_and_name:$file_path_and_name);$nl"    
        }
    }
    find_importer
    return $ret_code
}

Function find_importer
{

    $loading_files = @('code_to_load_a_file.ps1', 'code_to_load_a_directory.ps1' )

    foreach($item in (Get-PSCallStack).GetEnumerator()){

        if ($item.ScriptName -ne $null) { $code_file = (split-path -path:($item.ScriptName) -Leaf ) }
        if ( ( $loading_files -contains $code_file ) )
        {
            continue
        }
        else 
        {

            [string]$function_name = $item.FunctionName
            if ( $function_name -eq $null -or  $function_name -eq '' ) { $function_name = "NULL" }
            $SCRIPT:pr_import_module_files["pr_import_module_count_per_function_name"][$function_name] += 1 

            [string]$loading_module_name = ""
            if ( $item.InvocationInfo.MyCommand -ne $null )
            {
              $loading_module_name = $item.InvocationInfo.MyCommand.ModuleName
            } 
            if ( $loading_module_name -eq $null -or  $loading_module_name -eq '' ) { $loading_module_name = "NULL" }
            $SCRIPT:pr_import_module_files["pr_import_module_count_per_module"][$loading_module_name] += 1 


            [string] $script_name = $item.ScriptName 
            if ( $script_name -eq $null -or  $script_name -eq '' ) { $script_name = "NULL" }
            $SCRIPT:pr_import_module_files["pr_import_module_count_per_file"][$script_name] += 1


            [string] $command_name = $item.Command.ToString() 
            if ( $command_name -eq $null -or  $command_name -eq '' ) { $command_name = "NULL" }
            $SCRIPT:pr_import_module_files["pr_import_module_count_per_command_name"][$command_name] += 1

            break
        }

    }
}
