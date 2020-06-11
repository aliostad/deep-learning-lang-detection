#-- Public Loading Module Parameters (Recommend to use ($PSSumoLogicAPI.defaultconfigurationfile) for customization) --#

# credential
$PSSumoLogicAPI.credential = @{
    user                           = "INPUT YOUR Email Address to logon"
}

$PSSumoLogicAPI.sourceParameter    = @{
    alive                          = [bool]$true
    states                         = [string]""
    automaticDateParsing           = [bool]$true
    timeZone                       = [string](Check-PSSumoLogicTimeZone -TimeZone Asia/Tokyo)
    multilineProcessingEnabled     = [bool]$true
}

# RunSpace Pool size
$PSSumoLogicAPI.runSpacePool = @{
    minPoolSize                    = 1
    maxPoolSize                    = ([int]$env:NUMBER_OF_PROCESSORS * 30)
}

# Project Name for SumoLogic Source Explanation
$PSSumoLogicAPI.Project = "INPUT PROJECT NAME for source explanation"
