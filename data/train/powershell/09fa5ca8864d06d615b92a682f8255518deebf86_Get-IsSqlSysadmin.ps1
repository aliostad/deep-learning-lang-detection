<#
This script returns whether the account running the function is a sysadmin on the sql instance name passed to the function
#>

function Get-IsSqlSysadmin ([string]$instancename)
{
    #Load Asslemby
    [System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.SMO") | out-null
    
    ## CHECK IF USER RUNNING PROCESS IS SYSADMIN - ELSE DON'T RUN INVESTIGATION
    $is_sysadmin_query = "SELECT IS_SRVROLEMEMBER('sysadmin') AS isSysadmin;"

    $instanceconn = New-Object ('Microsoft.SqlServer.Management.Smo.Server') $instancename
    $finalconn= $instanceconn.Databases["master"]
                        
    $am_i_sysadmin_results = $finalconn.ExecuteWithResults($is_sysadmin_query)

    foreach ($is_sysadmin in $am_i_sysadmin_results.Tables)
    {
        $am_i_sysadmin = $false; #default to false
        $am_i_sysadmin = $is_sysadmin.isSysadmin
    }

    return $am_i_sysadmin

}
