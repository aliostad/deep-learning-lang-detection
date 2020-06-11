
#running a VBScript from powershell
# extension showing passing parameters into the script and firing the script off based on the parameters

# parameter needed by this script..
param(  [string]$pathToVBS,
        [string]$param1, 
        [string]$param2)

# for purposes of demo, show the values of the parameters just passed..
Write-Host '$pathToVBS is [' $pathToVBS ']'
Write-Host '$param1 is [' $param1 ']'
Write-Host '$param2 is [' $param2 ']'

# for purposes of demo, show the lengths of the parameters just passed..
Write-Host '$pathToVBS.length is [' $pathToVBS.length ']'
Write-Host '$param1.length is [' $param1.length ']'
Write-Host '$param2.length is [' $param2.length ']'


if ( ($pathToVBS.Length -gt 0) -and ($param1.Length -gt 0) -and ($param2.Length -gt 0) )
{
    # start the VBScript to show the call.
    cscript $pathToVBS\SimpleVBScriptExample.wsf  $param1 $param2
}
else
{
    "Requires three parameters:"
    "    RunVBScriptWithParams.ps1 <path to the VBScript> <param1> <param2>"
    "    example:"
    "      RunVBScriptWithParams.ps1 c:\mypath <param1> <param2>"
}

