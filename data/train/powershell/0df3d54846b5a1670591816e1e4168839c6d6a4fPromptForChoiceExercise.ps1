# -----------------------------------------------------------------------------
# Script: PromptForChoiceExercise.ps1
# Author: ed wilson, msft
# Date: 04/22/2012 18:13:13
# Keywords: exercise 19-1
# comments: solution
# PowerShell 3.0 Step-by-Step, Microsoft Press, 2012
# Chapter 19
# -----------------------------------------------------------------------------
$caption = "This is the caption"
$message = "This is the message"
$choices = [System.Management.Automation.Host.ChoiceDescription[]] `
 @("&choice1", "c&hoice2", "ch&oice3")
[int]$DefaultChoice = 2
$choiceRTN = $host.ui.PromptForChoice($caption,$message, $choices,$defaultChoice)
switch($choiceRTN)
 {
  0    { "choice1"  }
  1    { "choice2"  }
  2    { "choice3"  }
 }