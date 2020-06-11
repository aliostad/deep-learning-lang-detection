#http://blog.crayon.no/blogs/janegil/archive/2012/07/02/how_2D00_to_2D00_configure_2D00_a_2D00_function_2D00_parameter_2D00_to_2D00_belong_2D00_to_2D00_multiple_2D00_parameter_2D00_sets.aspx
Function Write-Error
{ 
    [CmdletBinding(DefaultParametersetName="Message")] 
    param(

        [Parameter(ParameterSetName='exception', Position=0, Mandatory = $true)]          [System.Exception]       $Exception 
        , [Parameter(ParameterSetName='error_record', Position=0, Mandatory = $true)]     [System.Management.Automation.ErrorRecord]       $ErrorRecord  

        , [Parameter(ParameterSetName='Message', Position=0, Mandatory = $false)]
        [Parameter(ParameterSetName='exception', Position=1, Mandatory = $false)]         [string]          $Message

        , [Parameter(ParameterSetName='Message', Position=1, Mandatory = $false)]
        [Parameter(ParameterSetName='exception', Position=2, Mandatory = $false)]         [System.Management.Automation.ErrorCategory]   $Category

        , [Parameter(ParameterSetName='Message', Position=2, Mandatory = $false)]
        [Parameter(ParameterSetName='exception', Position=3, Mandatory = $false)]         [string]          $ErrorId

        , [Parameter(ParameterSetName='Message', Position=3, Mandatory = $false)]
        [Parameter(ParameterSetName='exception', Position=4, Mandatory = $false)]         [Object]          $TargetObject

        , [Parameter(ParameterSetName='Message', Position=4, Mandatory = $false)]
        [Parameter(ParameterSetName='exception', Position=5, Mandatory = $false)]
        [Parameter(ParameterSetName='error_record', Position=1, Mandatory = $false)]      [string]          $RecommendedAction

        , [Parameter(ParameterSetName='Message', Position=5, Mandatory = $false)]
        [Parameter(ParameterSetName='exception', Position=6, Mandatory = $false)]
        [Parameter(ParameterSetName='error_record', Position=2, Mandatory = $false)]      [string]          $CategoryActivity

        , [Parameter(ParameterSetName='Message', Position=6, Mandatory = $false)]
        [Parameter(ParameterSetName='exception', Position=7, Mandatory = $false)]
        [Parameter(ParameterSetName='error_record', Position=3, Mandatory = $false)]      [string]          $CategoryReason

        , [Parameter(ParameterSetName='Message', Position=7, Mandatory = $false)]
        [Parameter(ParameterSetName='exception', Position=8, Mandatory = $false)]
        [Parameter(ParameterSetName='error_record', Position=4, Mandatory = $false)]      [string]          $CategoryTargetName

        , [Parameter(ParameterSetName='Message', Position=8, Mandatory = $false)]
        [Parameter(ParameterSetName='exception', Position=9, Mandatory = $false)]
        [Parameter(ParameterSetName='error_record', Position=5, Mandatory = $false)]      [string]          $CategoryTargetType

    )

    try {
        $var = (Snif-WriteVerb -the_write_verbs_bound_parameters:$PSBoundParameters  -write_noun:"ERROR" )    
    }
    catch [Exception]{
        Microsoft.PowerShell.Utility\Write-Warning "ERROR in sniffing verb.  [$($_.Exception.Message)] [$($_.InvocationInfo.PositionMessage)] [$($_.Exception.StackTrace)]"
    }

    switch ($PsCmdlet.ParameterSetName) 
    { 

        "Message"  {  return ( Microsoft.PowerShell.Utility\Write-Error $PSBoundParameters ) } 

        "exception"  { return ( Microsoft.PowerShell.Utility\Write-Error $PSBoundParameters )} 

        "error_record"  { return ( Microsoft.PowerShell.Utility\Write-Error $PSBoundParameters )} 

    }     
}