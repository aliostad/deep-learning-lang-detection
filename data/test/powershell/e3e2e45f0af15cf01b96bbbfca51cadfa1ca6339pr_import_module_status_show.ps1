function pr_import_module_status_show
{
    [cmdletbinding()] Param ( [Parameter(Mandatory=$True)] $your_title ) 


    $show = ( pr_setting_import_module_status_show_per_file -calling_file:(Split-Path -Path:$MyInvocation.ScriptName -Leaf) )
    if ( $show -eq 'show' )
        {
            Write-Host ""
            Write-Host "================================================================="
            Write-Host $your_title
            Write-Host "----------> # of import-module calls = [$(pr_import_module_status_count_of_import_module_calls)]"  
            Write-Host "Calls per module"
            Write-Host "------------------------------"
            $mod_counts=pr_import_module_status_count_of_import_module_calls_per_module
            if ( $mod_counts.Count -eq 0 ) { Write-Host "-NONE-" }
            foreach ($module in ($mod_counts.GetEnumerator())) {
              write-host "$($module.name) loaded $($module.value)" 
            }
            Write-Host ""
            Write-Host "Calls per command"
            Write-Host "------------------------------"    
            $my_command_counts=pr_import_module_status_count_of_import_module_calls_per_command_name
            if ( $my_command_counts.Count -eq 0 ) { Write-Host "-NONE-" }
            foreach ($my_c in ($my_command_counts.GetEnumerator())) {
              write-host "$($my_c.name) loaded $($my_c.value)" 
            }  

            Write-Host ""
            Write-Host "Calls per file"
            Write-Host "------------------------------"    
            $files=pr_import_module_status_count_of_import_module_calls_per_file
            if ( $files.Count -eq 0 ) { Write-Host "-NONE-" }
            foreach ($file in ($files.GetEnumerator())) {
              write-host "$($file.name) loaded $($file.value)" 
            }     


            Write-Host ""
            Write-Host "Calls per function name"
            Write-Host "------------------------------"    
            $functions=pr_import_module_status_count_of_import_module_calls_per_function_name
            if ( $functions.Count -eq 0 ) { Write-Host "-NONE-" }
            foreach ($function in ($functions.GetEnumerator())) {
              write-host "$($function.name) loaded $($function.value)" 
            }  


            Write-Host $your_title    
            Write-Host "================================================================="
            Write-Host
        }

    return $null
}