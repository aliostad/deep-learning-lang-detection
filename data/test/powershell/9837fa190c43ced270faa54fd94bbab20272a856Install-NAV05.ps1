# ----------------------------------------
# NAV_05: MANAGE THE SITE MAP
# ----------------------------------------

param([string]$LogFolderPath)

$UserStory = "NAV05"

$0 = $myInvocation.MyCommand.Definition
$CommandDirectory = [System.IO.Path]::GetDirectoryName($0)

$values = @{"User Story: " = $UserStory}
New-HeaderDrawing -Values $Values

# ================================================== #
# =========   TAXONOMY OPEN TERM COLUMN   ========== #
# ================================================== #


#$values = @{"Step: " = "#1 Setup open term creation for the pages library"}
#New-HeaderDrawing -Values $Values

#$Script = $CommandDirectory + '\Setup-Lists.ps1'
#& $Script 

# =============================== #
# =====   EVENT RECEIVERS   ===== #
# =============================== #

$values = @{"Step: " = "#3 Setup Event Receivers"}
New-HeaderDrawing -Values $Values

$Script = $CommandDirectory + '\Setup-EventReceivers.ps1'
& $Script