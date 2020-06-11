<#
.SYNOPSIS
    Creates the Deploymentruleset.jar file for Java 
.DESCRIPTION
    Upon importing the module, the createDRS cmdlet can be run to create and sign the Deploymentruleset.jar.
.NOTES
    File Name : manage-java.psm1
    Version : 0.1.1
    Author : Tripp Watson and Erick Brashears
    Requires : Powershell v. 3 and Java JDK 7
#>

Set-StrictMode -Version Latest

#----------------------------------

function ConvertFromSecureToPlain {
    
    param( [Parameter(Mandatory=$true)][System.Security.SecureString] $SecurePassword)
    
    # Create a "password pointer".
    $PasswordPointer = [Runtime.InteropServices.Marshal]::SecureStringToBSTR($SecurePassword)
    
    # Get the plain text version of the password.
    $PlainTextPassword = [Runtime.InteropServices.Marshal]::PtrToStringAuto($PasswordPointer)
    
    # Free the pointer.
    [Runtime.InteropServices.Marshal]::ZeroFreeBSTR($PasswordPointer)
    
    # Return the plain text password.
    $PlainTextPassword
    
}

#----------------------------Creation of Deployment Rule Set folder-------------------------

#Creates the folder where the Deployment Rule Set jar file will be placed.
function createDRSFolder
{
	if(!(Test-Path C:\Windows\Sun\Java\Deployment))
	{
		New-Item -Path C:\Windows\Sun\Java\Deployment -Type Directory
	}
}

#----------------------------Creation of the ruleset.xml------------------------------------

#Main function that builds the rule set and saves it to a designate file and location
function buildRuleset([string] $whitelistLocation, [string] $destloc, [string] $defaultAction, [string] $defaultMessage)
{
	[xml]$ruleset = New-Object system.Xml.XmlDocument
	$ruleSet.LoadXml("<ruleset version=`"1.0+`"></ruleset>")
	addRulesByFile $ruleSet $whitelistLocation
	addDefaultRule $ruleSet $defaultAction $defaultMessage
	saveRuleSetFile $ruleSet $destloc
}

#Saves the new ruleset.xml file in the target directory (ex. C:\Windows\Sun\Java\Deployment)
function saveRuleSetFile([xml] $ruleSet, [string] $targetDir)
{
	$ruleSet.Save("$targetDir\ruleset.xml")
}

function deleteRuleSetFile([string] $targetDir)
{
	if (Test-Path '$targetDir\ruleset.xml')
	{
		remote-item '$targetDir\ruleset.xml'
	}
	else
	{
		echo "When trying to delete, the ruleset did not exist."
	}
}

#Gathers information from a designated file in order to create the ruleset.
function addRulesByFile([xml] $ruleSet, [string] $whitelistLocation)
{
	$whitelistContent = getWhitelistFile $whitelistLocation
	foreach($line in $whitelistContent)
	{
		$whitelistEntry = $line -split ',',0,"SimpleMatch"
		$location = $whitelistEntry[0]
		$action = $whitelistEntry[1]
		addRule $ruleSet $location $action
	}
}

function getWhitelistFile([string] $whitelistLocation)
{
	$whitelistContent = Get-Content $whitelistLocation
	$whitelistContent	
}

#Creates new rule for the ruleset.
function addRule([xml] $ruleSet, [string] $location, [string] $action)
{
	$newRule = $ruleSet.createelement("rule")
	addRuleID $ruleset $newRule $location
	addRuleAction $ruleSet $newRule $action
	$ruleSet.ruleset.AppendChild($newRule)
}

#Creates the ID node while designating a specific location.
function addRuleID([xml] $ruleset, [xml.XmlElement] $rule, [string] $location)
{
	$newnode = $ruleset.createelement("id")
	$newnode.SetAttribute('location',$location)
	$rule.AppendChild($newnode)
}

#Creates the ID node without designating a specific location. (Used Primarily by Default rule)
function addDefaultRuleID([xml] $ruleSet, [xml.XmlElement] $rule)
{
	$newnode = $ruleSet.createelement("id")
	$rule.AppendChild($newnode)
	
}

#Creates an action for a rule while designating a message. 
function addDefaultRuleAction([xml] $ruleSet, [xml.XmlElement] $rule, [string] $action, [string] $message)
{
	$newRuleAction=$ruleSet.createelement("action")
	$newRuleAction.SetAttribute('permission',$action)
	addMessage $ruleSet $newRuleAction $message
	$rule.AppendChild($newRuleAction)
}

#Creates an action for a rule without designating a message. 
function addRuleAction([xml] $ruleset, [xml.XmlElement] $rule, [string] $action)
{
	$newRuleAction=$ruleset.createelement("action")
	$newRuleAction.SetAttribute('permission',$action)
	$rule.AppendChild($newRuleAction)
}

#Creates the default rule for the ruleset.
function addDefaultRule([xml] $ruleSet, [string] $action, [string] $message)
{
	$newDefaultRule=$ruleSet.createelement("rule")
	addDefaultRuleID $ruleSet $newDefaultRule
	addDefaultRuleAction $ruleSet $newDefaultRule $action $message
	$ruleSet.ruleset.AppendChild($newDefaultRule)
}

#Adds a popup message to a rule.
function addMessage([xml] $ruleSet, [xml.XmlElement] $ruleAction, [string] $message)
{
	$newMessage = $ruleSet.createelement("message")
	$newMessage.set_InnerText($message)
	$ruleAction.AppendChild($newMessage)
}

#-------------------------Create Jar file from ruleset.xml---------------------------

function createJar([string] $tempDir, [string] $jarBinDir)
{
    Set-Location -Path $jarBinDir
	$command = "'$jarBinDir\jar.exe' -cvf '$tempDir\DeploymentRuleSet.jar' 'ruleset.xml'"
	iex "& $command"
}

#-------------------------Signing the Deployment Ruleset Jar file--------------------

function signJar([string] $jarBinDir, [string] $tempDir, [string] $alias, [string] $certificate)
{
	$command = "'$jarBinDir\jarsigner.exe' -verbose -keystore '$certificate' -storetype pkcs12 -storepass '$storepswd' -signedjar '$tempDir\DeploymentRuleSet.jar' '$tempDir\DeploymentRuleSet.jar' '$alias'"
	iex "& $command"
}

#-----------------------------------Main Function------------------------------------

function requestAlias( )
{
$selection =  Read-Host 'Enter Alias name'
if (!$selection) 
{
	Write-Host 'You must enter an alias from the Code Signing Certificate. To find the alias, use the following (Replace cert.pfx the path to the Code Signing Certificate): keytool -list -keystore cert.pfx -storetype PKCS12'
	requestAlias
}
$selection
}

function requestDefaultAction( )
{
$selection =  Read-Host 'Enter Default action ( Block )'
if (($selection.ToLower().compareTo("block") -eq 0) -or ($selection.ToLower().compareTo("default") -eq 0)) 
{
	$selection
}
elseif (!$selection)
{
	$selection = "Block"
}
else {
	Write-Host 'You must enter a valid default action to continue. The available default actions are Block or Default.'
	requestDefaultAction
}
$selection
}

function requestDefaultMessage( )
{
$selection =  Read-Host 'Enter Default Message'
if ($selection) 
{
	$selection
}
else {
	Write-Host 'You must enter a message to inform users who to contact if a website is not allowed to use Java and possibly needs to be added to the whitelist.'
	requestDefaultMessage
}
$selection
}

function requestWhitelist( )
{
$defaultPath = [Environment]::GetFolderPath('MyDocuments') + "\whitelist.txt"
$selection =  Read-Host "Enter the full path of the Whitelist ( $defaultPath )"
if ($selection) 
{
	if(!(Test-Path $selection))
	{
		Write-Host 'The whitelist could not be located at the given location.'
		requestWhitelist
	}
}
else {
	if(!(Test-Path $defaultPath))
	{
		Write-Host 'The whitelist could not be located at the default location.'
		requestWhitelist
	}
	else
	{
		$selection = $defaultPath
	}
}
$selection
}

function requestCertificate( )
{
$defaultPath = [Environment]::GetFolderPath('MyDocuments') + "\deploymentRulesetCert.pfx"
$selection =  Read-Host "Enter the full path of the certificate ( $defaultPath )"
if ($selection) 
{
	if(!(Test-Path $selection))
	{
		Write-Host 'The certificate could not be located at the given location.'
		requestCertificate
	}
}
else {
	if(!(Test-Path $defaultPath))
	{
		Write-Host 'The certificate could not be located at the default location.'
		requestCertificate
	}
	else
	{
		$selection = $defaultPath
	}
}
$selection
}

function createDRS()
{
	#createDRSFolder
Echo "******************************************************************************************"
Echo "*                                                                                        *"
Echo "* Please answer the following prompts (press Enter to accept default values shown):      *"
echo "*                                                                                        *"
echo "******************************************************************************************" 
 
$tempDir = 'C:\Windows\Sun\Java\Deployment'

if(Test-Path 'C:\Program Files (x86)\Java')
{
	$javaVersion = Get-ChildItem 'C:\Program Files (x86)\Java' -Directory -Name -Include jdk*|Sort-Object|select -last 1
	$jarBinDir = "C:\Program Files (x86)\Java\$javaVersion\bin"
}
elseif(Test-Path 'C:\Program Files\Java')
{
	$javaVersion = Get-ChildItem 'C:\Program Files\Java' -Directory -Name -Include jdk*|Sort-Object|select -last 1
	$jarBinDir = "C:\Program Files\Java\$javaVersion\bin"
}
else
{
	echo "Java Development Kit must be installed prior to running the Java Deployment Rule Set Builder."
	Break
}
	
	$defaultaction = requestDefaultAction
	$defaultMessage = requestDefaultMessage
	$whitelist = requestWhitelist
	$certificate = requestCertificate
	$alias = requestAlias
	$hiddendestpswd = Read-Host 'Enter Certificate Password' -AsSecureString
	$storepswd = ConvertFromSecureToPlain $hiddendestpswd
  
	
	createDRSFolder
	buildRuleset $whitelist $jarBinDir $defaultAction $defaultMessage
	createJar $tempDir $jarBinDir
	signJar $jarBinDir $tempDir $alias $certificate
}

#-------------------------------------End of Functions-------------------------------

Export-ModuleMember -Function createDRS

# Optional commands to create a public alias for the function
New-Alias -Name aliasFoo -Value Get-Foo
Export-ModuleMember -Alias aliasFoo
