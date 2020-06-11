<# 
Return the last -lineCount Lines in the Console Buffer
Can be great for logging purposes
 #>

if($includes_ps1_ui -ne $true)
{
    # included types
    Add-Type -AssemblyName Microsoft.VisualBasic
    
    Set-Variable includes_ps1_ui -option Constant -value $true
    Set-Variable RawUI -option Constant -value $Host.UI.RawUI

        
    <# 
    .SYNOPSIS
        Show a Dialog Box with optional button combinations via Windows Com Shell
    .DESCRIPTION
        Show a Dialog Box with optional button combinations via Windows Com Shell. The Following Table describes the optional buttons
        That can be shown using the -DialogType argument
        
    DEC.    HEX.    BEHAVIOR                                            RESULT VALUES ( all return -1 if wait time is exceeded ) 
    -----------------------------------------------------------------------------------------------------------------
    0       0x0     Show OK button.                                     OK: 1                                     
    1       0x1     Show OK and Cancel buttons.                         OK: 1           CANCEL: 2                  
    2       0x2     Show Abort, Retry, and Ignore buttons.              ABORT: 3        RETRY:4,        IGNORE: 5  
    3       0x3     Show Yes, No, and Cancel buttons.                   YES:6           NO:7,           CANCEL:2   
    4       0x4     Show Yes and No buttons.                            YES:6           NO:7                       
    5       0x5     Show Retry and Cancel buttons.                      RETRY: 4        CANCEL: 2                  
    6       0x6     Show Cancel, Try Again, and Continue buttons.       CANCEL: 2       TRYAGAIN:10,    CONTINUE:11

    Also See:  http://msdn.microsoft.com/en-us/library/x83z1d9f(v=vs.84).aspx

    #>
    function Show-Alert()
    {
        param(
            [Parameter(Mandatory = $true)]
            [string]$Message,
            
            [Parameter(Mandatory = $true)]
            [string]$Title,
            
            [Parameter(Mandatory=$false)]
            [int]$SecondsToWait = 0,
            
            [Parameter(Mandatory=$false)]
            [uint32]$DialogType = 0x0
        )
        
        # Write-Console -Message "Operation => $Message" -Color $DARKGREEN -WriteToLog
        
        [int]$result = $SHELL.Popup("$Message",$SecondsToWait,"$Title",$DialogType)
        Log-Message -Message "[Show-Alert] Result was $result" -Level $global:LOG_LEVEL.Verbose
        return $result
    }

    #############################################################################################################################
    <#
    .SYNOPSIS
        Open a Folder Browser Dialog to select a path
    .DESCRIPTION
        Open a Folder Browser Dialog to select a path
    .NOTES
        File Name      : perforce.ps1
        Author         : Bow Archer
        Prerequisite   : PowerShell V2
    .LINK

    .EXAMPLE
      Read-FolderBrowserDialog -Message "Select a folder" -InitialDirectory "C:\" -NoNewFolderButton
    .EXAMPLE

    #>
    function Read-FolderBrowserDialog([string]$Message, [string]$InitialDirectory, [switch]$NoNewFolderButton)
    {     
        $browseForFolderOptions = 0
        
        if ($NoNewFolderButton) { 
            $browseForFolderOptions += 512 
        }       
        
        # Write-Console -Message "Browse Operation => $Message" -Color $DARKGREEN -Ticker $true -TickInterval 2  -WriteToLog
        
        $folder = $APPLICATION.BrowseForFolder(0, $Message, $browseForFolderOptions, $InitialDirectory)     
        
        if ($folder) { 
            $selectedDirectory = $folder.Self.Path 
        } 
        else { 
            $selectedDirectory = "" 
        }     
        
        Write-Debug "Read-FolderBrowserDialog $selectedDirectory"
        return $selectedDirectory
    }
    #############################################################################################################################
    <#
    .SYNOPSIS
        Input Based Dialog Box
    .DESCRIPTION
        Alters a Windows System or User Level environment Variable
    .NOTES
        File Name      : utilities.ps1
        Author         : Bow Archer
        Prerequisite   : PowerShell V2
    .EXAMPLE
      $textEntered = Read-InputBoxDialog -Message "Enter the word 'Banana'" -WindowTitle "Input Box Example" -DefaultText "Apple"
      if ($textEntered -eq $null) 
      { 
          Write-Host "You clicked Cancel" 
      } 
      elseif ($textEntered -eq "Banana") 
      { 
          Write-Host "Thanks for typing Banana" 
      } else 
      { 
          Write-Host "You entered $textEntered" 
      }
    #>

    function Read-InputBoxDialog([string]$Message, [string]$WindowTitle, [string]$DefaultText)
    {     
        # Write-Console -Message "User Text Input Operation => $Message" -Color $DARKGREEN -Ticker $true -TickInterval 2 -WriteToLog
        $inputValue = [Microsoft.VisualBasic.Interaction]::InputBox($Message, $WindowTitle, $DefaultText)
        Write-Debug "Read-InputBoxDialog $inputValue"
        return $inputValue
    }


    function Get-Console-Buffer
    {
      param(
            [int]$lineCount
        )

        [int]$end = $RawUI.CursorPosition.Y
        [int]$start = $end - $lineCount

        if ($start -le 0) { $start = 0 }

        $width      = $RawUI.BufferSize.Width
        $height     = $end - $start
        $dims       = 0,$start,($width-1),($end-1)
        $rect       = new-object Management.Automation.Host.Rectangle -argumentList $dims
        $cells      = $RawUI.GetBufferContents($rect)

        # inner function to translate a console colour to an html/css one
        $line  = ""

        $lines = @()
        for ([int]$row=0; $row -lt $height; $row++ ) {

            for ([int]$col=0; $col -lt $width; $col++ ) {
              $cell = $cells[$row,$col]
              $line += $cell.Character
            }

            $lines += $line
            $line=""
        }

        $lines
    }



    function Change-OutputColor-For-ScriptBlock
    {
        param(
            [Parameter(Mandatory=$true)]
            $ScriptBlock,
            
            [Parameter(Mandatory=$true)]
            [string]$Color
        )
        
        
        
        $t = $host.ui.RawUI.ForegroundColor
        $RawUI.ForegroundColor = $Color
        
        # execute script block
        $result = & $ScriptBlock
        
        $RawUI.ForegroundColor = $t
        
        return $result
    }
}
