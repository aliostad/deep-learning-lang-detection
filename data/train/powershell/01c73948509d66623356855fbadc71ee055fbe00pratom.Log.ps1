<#
.SYNOPSIS
    If you want to type just log or l or prl in YOUR code, YOU feel free to alias pratom.Log
.EXAMPLE
    pratom.Log "this is my message to log"
.EXAMPLE
    pratom.Log -to_log:"this is my message to log"
.EXAMPLE
    pratom.Log "info" "this is my message to log"
.EXAMPLE
    pratom.Log "i didn't mean this to be the category, but it is anyways" "this is my message to log"
.EXAMPLE
    pratom.Log -log_category:"info" -to_log:"this is my message to log"

TODO: pratom setting to turn off writing to the meta log
#>
Function pratom.Log 
{
    [CmdletBinding(DefaultParametersetName="Just_Message")]
    Param (
                [Parameter(ParameterSetName='By_Log'          , Position=0, Mandatory=$false)]
                [Parameter(ParameterSetName='CAT_MESSAGE'     , Position=0, Mandatory=$false)]
                                        [String]    $log_category

              , [Parameter(ParameterSetName='By_Log'        , Position=1, Mandatory=$false)]  
                [Parameter(ParameterSetName='CAT_MESSAGE'   , Position=1, Mandatory=$false)]                                        
                [Parameter(ParameterSetName='Just_Message'  , Position=0, Mandatory=$false)] 
                                        [string] $to_log  

              , [Parameter(ParameterSetName='By_Log'                 , Position=2, Mandatory=$true)]
                                [string] $log_file_path

          )  
    

    [string]$target_log_file = pratom_PATH_LOG_FILE_MAIN                    
    switch ($PsCmdlet.ParameterSetName) 
        { 
            "Just_Message"      { [string]$log_category = "INFO"; } 
            "CAT_MESSAGE"       { } 
            "By_Log"            { $target_log_file = $log_file_path }
        } 

    if ( ( $log_category -eq $null ) -or ( $log_category -eq "") )
    {
        $log_category = "INFO"    
    }
    $log_category = pratom_logging_category_formatted -log_category:$log_category

    if ( $to_log -eq $null )
    {
        $to_log = ""
    }

    $SCRIPT:pratom_logger_line_id += 1
    [string]$log_line_dtt = get_sortable_datetime
    $object = New-Object pratom.LogLine( ($SCRIPT:pratom_logger_line_id), $log_line_dtt, $log_category ) 

    $object.Data = $to_log
    $simple_to_log = $object.Formatted
    Add-Content ($target_log_file) -Value:$simple_to_log

    return $object
}
