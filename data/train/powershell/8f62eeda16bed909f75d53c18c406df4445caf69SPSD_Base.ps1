###############################################################################
# SharePoint Solution Deployer (SPSD)
# Version          : 4.1.2.2805
# Url              : http://spsd.codeplex.com
# Creator          : Matthias Einig
# License          : GPLv2
###############################################################################
#region Base
	#region InitializeScript
	# Desc: Initializes constants and directories
	Function InitializeScript(){
	    $Script:SPSD = @{
	                        Version = [System.Version]"4.1.2.2805"
                            DisplayName ="SharePoint Solution Deployer (SPSD)"
                            StatusWidth = 79
	                        LogTypes = @{
	                            Error       = 0
	                            Warning     = 1
	                            Information = 2
	                            Verbose     = 3
	                            VerboseExtended = 4
	                        }
	                        Commands = @{
	                            Deploy      = 0
	                            Retract     = 1
	                            Redeploy    = 2
	                            Update      = 3 
	                        }
	                        DeploymentTypes = @{
	                            All         = 0
	                            Solutions   = 1
	                            Structures  = 2
	                        }
	                    }
	    $Script:LogIndentVal      = 0
	    $Script:baseDir = GetDirOrCreateIt -dir (Split-Path $scriptDir -Parent)
	    $Script:envDir  = GetDirOrCreateIt -dir ($baseDir + "\Environments")
	    $Script:logDir  = GetDirOrCreateIt -dir ($baseDir + "\Logs")
        $Script:RemoteSessions = @{}
	    #region Set parameters
	    [int]$Script:DeploymentCommand  = ParseParameter -value $Command    -values $SPSD.Commands        -default $SPSD.Commands.Deploy
	    [int]$Script:DeploymentType     = ParseParameter -value $Type       -values $SPSD.DeploymentTypes -default $SPSD.DeploymentTypes.All
	    [int]$Script:LogLevel           = ParseParameter -value $Verbosity  -values $SPSD.LogTypes        -default $SPSD.LogTypes.Verbose
	    #endregion

	}
    #endregion
	#region LoadSettings
	# Desc: Loads the settings specified in the configuration file to variables
    #       has to be executed after the environment configuration is loaded
    Function LoadSettings(){
    	[int]$Script:DefaultTimeout = $conf.Settings.DeploymentTimeout
	    [int]$Script:DeploymentRetries = $conf.Settings.DeploymentRetries
	    $Script:WaitAfterDeployment = $conf.Settings.WaitAfterDeployment
        [bool]$Script:AllowGACDeployment = [System.Convert]::ToBoolean($conf.Restrictions.AllowGACDeployment)
        [bool]$Script:AllowCASPolicies = [System.Convert]::ToBoolean($conf.Restrictions.AllowCASPolicies)
        [bool]$Script:AllowFullTrustBinDeployment = [System.Convert]::ToBoolean($conf.Restrictions.AllowFullTrustBinDeployment)
        [bool]$Script:CreateULSLogfile = [System.Convert]::ToBoolean($conf.Settings.CreateULSLogfile)
        
        [Array]$Script:servers = $env:COMPUTERNAME
        # get multiple servers if configured, keeps downward compatibility to deprecated setting "IncludeAllServersInFarm"
        if([System.Convert]::ToBoolean($conf.Settings.IncludeAllServersInFarm) -or
           $conf.Settings.RunOnMultipleServersInFarm -ieq "All" ){
           $Script:servers = Get-SPServer | Where-Object {$_.Role -ine "Invalid"} | ForEach-Object {$_.Address}
        }
        elseif ($conf.Settings.RunOnMultipleServersInFarm -ieq "WebFrontEnd" -or
                $conf.Settings.RunOnMultipleServersInFarm -ieq "Application") {
                #include also SingleServer farms in any case
            $Script:servers = Get-SPServer | Where-Object {$_.Role -ieq $conf.Settings.RunOnMultipleServersInFarm -or $_.Role -ieq "SingleServer"} | ForEach-Object {$_.Address}
        }
    }
    #endregion
	#region Setting solution directory
	# Desc: Sets the directory where the solutions to be deployed are stored 
    Function SetSolutionDir(){
     	Log -message ("Getting solutions directory") -type $SPSD.LogTypes.Information -Indent

		If ($solutionDirectory -and $solutionDirectory.Length -gt 0 -and (Test-Path $solutionDirectory)){
            Log -message "Absolute custom directory specified" -type $SPSD.LogTypes.Verbose
	        $Script:solDir  = $solutionDirectory
        }
        elseif($solutionDirectory -and $solutionDirectory.Length -gt 0 -and (Test-Path $solutionDirectory)){
            Log -message "Relative custom directory specified" -type $SPSD.LogTypes.Verbose
            $Script:solDir  = (Get-Item $($baseDir + "\" +$solutionDirectory)).FullName
        }
        else {
       	    Log -message "Custom directory not configured or does not exist. Using default" -type $SPSD.LogTypes.Verbose
        	$Script:solDir  = GetDirOrCreateIt -dir ($baseDir + "\Solutions")
        }
   	    Log -message ("Solutions directory: "+ (Get-Item $Script:solDir).FullName) -type $SPSD.LogTypes.Verbose
        LogOutdent
    }
    #endregion
	#region StartUp
	# Desc: Writes the startup header, starts tracing and loads the required PS Addins
	Function StartUp(){
	    InitializeScript
        $Host.UI.RawUI.WindowTitle = $SPSD.DisplayName + " - Version: " + $SPSD.Version
	    StartTracing
	    Log -message ("*"*$SPSD.StatusWidth) -type $SPSD.LogTypes.Information
	    Log -message (GetStatusLine -text $SPSD.DisplayName ) -type $SPSD.LogTypes.Information
	    Log -message (GetStatusLine -text ("Version          : "+$($SPSD.Version))) -type $SPSD.LogTypes.Information
        Log -message (GetStatusLine -text ("Url              : http://spsd.codeplex.com")) -type $SPSD.LogTypes.Information
        Log -message (GetStatusLine -text ("Started on       : "+$(get-date))) -type $SPSD.LogTypes.Information
        Log -message (GetStatusLine -text "") -type $SPSD.LogTypes.Information
        Log -message (GetStatusLine -text ("Command          : "+$Command)) -type $SPSD.LogTypes.Information
        Log -message (GetStatusLine -text ("Type             : "+$Type)) -type $SPSD.LogTypes.Information
        Log -message (GetStatusLine -text ("Machine          : $env:COMPUTERNAME")) -type $SPSD.LogTypes.Information
        Log -message (GetStatusLine -text ("User             : $env:USERDOMAIN\$env:USERNAME")) -type $SPSD.LogTypes.Information
	    Log -message ("*"*$SPSD.StatusWidth) -type $SPSD.LogTypes.Information
	    Log -message ""

	    Log -message "Load Addins" -type $SPSD.LogTypes.Information -Indent
	    LoadSharePointPS
	    LoadWebAdminPS
	    LogOutdent
        SetSolutionDir
	}
    #endregion
	#region GetStatusLine
	# Desc: Gets a status line in a fixed with *  (text)   *
    Function GetStatusLine($text){
        $width = ($SPSD.StatusWidth-3-$text.Length)
        if($width -lt 0){
            $width = 0
        }
        return "* $text"+(" "*$width)+"*"
    }
    #endregion
	#region ErrorSummary
	# Desc: Writes an error summary into a separate logfile
    Function ErrorSummary(){
        Log -message "One or multiple errors occured while excecuting SPSD" -type $SPSD.LogTypes.Information -NoIndent 
        $errNum = 0;
        $error | foreach { 
            Log -message ("Error "+$errNum+": "+$_) -type $SPSD.LogTypes.Error -NoIndent 
            $errNum = $errNum +1
            }

        $errorLog = $logFile.Substring(0, $logFile.Length -4 ) + "-Errors.log"
        Log -message ("More details can be found in "+(GetRelFilePath -filePath $errorLog)) -type $SPSD.LogTypes.Information -NoIndent 
        $Error > $errorLog

    }
    #endregion
	#region FinishUp
	# Desc: Writes the finalization text, elapsed time and log file location
	Function FinishUp(){
        CloseAllPSSessions
	    Log -NoIndent -message ""
	    Log -NoIndent -message ("*"*$SPSD.StatusWidth) -type $SPSD.LogTypes.Information 
	    Log -NoIndent -message (GetStatusLine -text "SPSD completed!") -type $SPSD.LogTypes.Information
	    Log -NoIndent -message (GetStatusLine -text "") -type $SPSD.LogTypes.Information
        Log -NoIndent -message (GetStatusLine -text ("Ended on         : "+$(get-date))) -type $SPSD.LogTypes.Information
        Log -NoIndent -message (GetStatusLine -text ("Elapsed Time     : "+$Script:ElapsedTime.Elapsed)) -type $SPSD.LogTypes.Information
        Log -NoIndent -message (GetStatusLine -text ("Log file         : "+(GetRelFilePath -filePath $LogFile))) -type $SPSD.LogTypes.Information
	    if($saveEnvXml){
            Log -NoIndent -message (GetStatusLine -text ("Environment file : "+(GetRelFilePath -filePath $resultXmlFile))) -type $SPSD.LogTypes.Information
	    }
	    Log -NoIndent -message ("*"*$SPSD.StatusWidth) -type $SPSD.LogTypes.Information
	    StopTracing
	}
    #endregion
#endregion
