Function global:ShowLoggedIn {
  # this is how you get the currently selected node
  $cur = [quest.powergui.hostfactory]::current.application.navigation.currentitem;
  # AddChild function adds a subnode and gives you the object back so you can set the label and the code
  $ch = $cur.AddChild()
  $cur.Expand()
  if ($logged)
  	{
		$ch.Name = "Logged in"
		$ch1 = $ch.AddChild()
		$ch1.Name = "Log Out"
		$ch1.script='$global:g_login=[Autodesk.DataManagement.Client.Framework.Vault.Forms.Library]::Logout($g_login)'
	}
  else
  	{
		$ch.Name = "Not logged in"
		$ch1 = $ch.AddChild()
		$ch1.Name = "Log In"
		$ch1.script='$global:g_login=[Autodesk.DataManagement.Client.Framework.Vault.Forms.Library]::Login($null)'
	}
	$ch.Expand()
  $_
	}

if ($g_login -eq $null)
	{Add-Type -Path "c:\Program Files (x86)\Autodesk\Autodesk Vault 2014 SDK\bin\Autodesk.DataManagement.Client.Framework.Vault.Forms.dll"
$global:logged=$false
	}
else
	{$global:logged=$true}
ShowLoggedIn
