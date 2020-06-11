<#
.SYNOPSIS
    Functions to manage powershell paths associated with rails
#>


<#
$path_exists = [Environment]::GetEnvironmentVariable("PSModulePath").Split(";")[0] 
$path_not_exists = "asdjofadsifjajosdf"

( exists_on_powershell_module_paths -path_to_check:$path_exists ) -eq $true
( exists_on_powershell_module_paths -path_to_check:$path_not_exists ) -eq $false
#>
<#
Function exists_on_powershell_module_paths
{
    [cmdletbinding()] 
    Param ( 
        [Parameter(Mandatory=$True)]   [string] $path_to_check
        )
    [string] $found_path = [Environment]::GetEnvironmentVariable("PSModulePath").Split(";") |  Where { $_.ToString() -eq $path_to_check}
    if ( $found_path -ne $null )
    {
        return $true
    }
    else {
        return $false
    }
}
#>

<#
    powershell_product_path -company_name:"comp_abc" -app_name:"my_super_app"
#>
<#
Function powershell_product_path
{
    [cmdletbinding()] 
    Param ( 
        [Parameter(Mandatory=$True)]    [string] $company_name
        , [Parameter(Mandatory=$True)]  [string] $app_name
    )
    $program_files_path = [System.Environment]::ExpandEnvironmentVariables("%ProgramFiles%") 
    $program_f_product_path = path_combine($program_files_path, "\$company_name\$app_name\Modules\" )
    return $program_f_product_path
}
#>

<#
    dev_code_path -company_name:"comp_abc" -app_name:"my_super_app"
    dev_code_path -company_name:"comp_abc" -app_name:"ready_bake"
#>
<#
Function dev_code_path 
{
    [cmdletbinding()] 
    Param ( 
        [Parameter(Mandatory=$True)]    [string] $company_name
        , [Parameter(Mandatory=$True)]  [string] $app_name
    )
    $pth = Get-Item -Path:([System.Environment]::ExpandEnvironmentVariables("%UserProfile%"))
    $root_path = $pth.Root
    $ret_dev_path = path_combine($root_path, "projects\$app_name\")
    return $ret_dev_path
}
#>

<#
    powershell_module_paths -dev_path:"f:\dev\scm_path"
#>
<#
Function powershell_module_paths
{
    [cmdletbinding()]  
    Param (  
       [Parameter(Mandatory=$True)]    [string] $dev_path
    )

    $user_profile_path = [System.Environment]::ExpandEnvironmentVariables("%UserProfile%") 
    $user_mod = path_combine ($user_profile_path, "Documents\WindowsPowerShell\Modules")

    $program_files_path = [System.Environment]::ExpandEnvironmentVariables("%ProgramFiles%") 

    $program_f_common = path_combine($program_files_path, "Common Files\Modules\")

    $dev_modules = path_combine( $dev_path,"modules" )
    $dev_common = path_combine( $dev_path ,"common" )

    $ret_ary = ( $user_mod  , $dev_modules  , $dev_common  , $program_f_common  )
    return $ret_ary
}

Function powershell_modules_paths_to_add
{
    [cmdletbinding()] 
    Param ( 
        [Parameter(Mandatory=$True)]    [string] $dev_path
        , [Parameter(Mandatory=$True)]  [string] $product_path
    )    

    [string] $ret_paths_to_add = ""

    powershell_module_paths($dev_path) | ForEach {
        [string]$path_maybe_add = $_
        if ( exists_on_powershell_module_paths($path_maybe_add) -eq $false )
        {
            $ret_paths_to_add = "$(ret_paths_to_add);$(path_maybe_add)" 
        }
    }

    if ( exists_on_powershell_module_paths($product_path) -eq $false )
    {
        $ret_paths_to_add = "$(ret_paths_to_add);$(product_path)"       
    }

    if ( $ret_paths_to_add -ne "" )
        {
            $ret_paths_to_add = $ret_paths_to_add.Substring(1,$ret_paths_to_add.length)
        }

    return $ret_paths_to_add
}

Function powershell_modules_add_path_to_machine_by_company_and_product
{
    [cmdletbinding()] 
    Param ( 
        [Parameter(Mandatory=$True)]    [string] $company_name
        , [Parameter(Mandatory=$True)]  [string] $app_name
    )  

    [string] $dev_path = powershell_module_path -company_name:$company_name -app_name:$app_name
    [string] $product_path = powershell_product_path -company_name:$company_name -app_name:$app_name

    return powershell_modules_add_path_to_machine -dev_path:$dev_path -product_path:$product_path
}

Function powershell_replace_module_path
{
    [cmdletbinding()] 
    Param ( 
            [Parameter(Mandatory=$True)]    [string] $new_module_path
        ) 

    [string]$current_module_path = [Environment]::GetEnvironmentVariable("PSModulePath")
    if ( $current_module_path -ne $new_module_path )
    {
        $null = [Environment]::SetEnvironmentVariable("PSModulePath",$new_module_path)
    }

    return $true
}

Function Main
{
    [cmdletbinding()] Param ()
    $paths_to_add = powershell_modules_add_path_to_machine_by_company_and_product -company_name:"xxxxxxxxx" -app_name:"xxxxxxxxx"
    [string]$new_module_path = "$(paths_to_add);$([Environment]::GetEnvironmentVariable("PSModulePath"))"
    powershell_replace_module_path -new_module_path:$new_module_path
}
#>
