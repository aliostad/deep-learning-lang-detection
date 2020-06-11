function Write-enhancedVerbose
{
    Param (
    [int]$MinimumVerboseLevel=1,

    [Parameter(Position=0)]
    [string]$Message

    )

    if ($verboselevel -ge $MinimumVerboseLevel)
    {
        if ($MinimumVerboseLevel -eq 1)
        {
            $message = "    " + $message
        }
        if ($MinimumVerboseLevel -eq 2)
        {
            $message = "        " + $message
        }
        if ($MinimumVerboseLevel -eq 3)
        {
            $message = "            " + $message
        }

        Write-verbose -Message $Message
    }

}

function get-SpecialFolder { 
  param([System.Environment+SpecialFolder]$Alias) 
  [Environment]::GetFolderPath([System.Environment+SpecialFolder]$alias) 
}
