SAS SYSADMIN CONSOLE funcitons
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000

$START SIDTRANSLATE Button$

	If($SIDtxt.text -eq "")
	{
		[System.Windows.Forms.MessageBox]::Show("Please Enter a SID to Continue","Don't be THAT guy!",0)
	}
		$Translated = $SIDtxt.Text
		$objSID = New-Object system.security.principal.SecurityIdentifier ($Translated)
		$objUser = $objSID.Translate([System.Security.Principal.NTAccount])
		$TranslateTxt.Text = $objUser.value 
		If ($SIDtxt.text -ne "" -and $TranslateTxt.Text -eq "")
		{
			[System.Windows.Forms.MessageBox]::Show("No results found. Please check your SID and try again.","Sorry Buddy",0)
		}

$END SIDTRANSLATE Button$

4444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444

$START SAS ACCOUNT LOCKOUT 


	$START Button - Get locked Users 333333333333333333333333333333333333333333333333333

		If(-not $Append) 
		{
			$LockedBox.items.Clear()
		}
			$LockedUsers = Search-ADAccount -LockedOut | Select -Expand 'SAMAccountName'
			#$NoLockout =  [System.Windows.Forms.MessageBox]::Show("No SAS Users locked out at this time. Hooray!!!!!!","Remembering Passwords For the Win!",0)	
				If ($LockedUsers -eq $Null)
				{
					 [System.Windows.Forms.MessageBox]::Show("No SAS Users locked out at this time. Hooray!!!!!!","Remembering Passwords For the Win!",0)	
				}	
				Else 
				{
					foreach($Forgetter in $LockedUsers)
					{	
						$LockedBox.Items.Add($Forgetter)
					}
				}
				
	$END Button - Get locked Users 33333333333333333333333333333333333333333333333333333

	$START button UNLOCK ALL 33333333333333333333333333333333333333333333333333333333


	
		$Account = $LockedBox.Text
		$Confirm = [System.Windows.Forms.MessageBox]::Show("Would you like to Unlock All Locked Out Accounts?", "Are you sure?",4)
		If ($Confirm -eq "YES")
			{
				Foreach($Forgetter2 in $LockedBox.items)
					{
						Unlock-ADAccount -Identity $Forgetter2
						
					}
				$Complete = [System.Windows.Forms.MessageBox]::Show("$Account Unlocked!" , "Complete!",0)
				$Complete	
				$LockedBox.Items.Clear()
			}
			
	$END Button UNLOCK ALL 33333333333333333333333333333333333333333333333333333333333
	
	$START Button UNLOCK SINGLE 333333333333333333333333333333333333333333333333333333
	
		If ($LockedBox.SelectedIndex -ge 0)
			{
				$Account = $LockedBox.Text
				$Confirm = [System.Windows.Forms.MessageBox]::Show("Would you like to Unlock Account: $Account" , "Are you sure?",4)
		
				If ($Confirm -eq "YES" -and $LockedBox.SelectedIndex -ge 0)
				{
					$Name = $LockedBox.SelectedItem
					Unlock-ADAccount $Name
					$Complete = [System.Windows.Forms.MessageBox]::Show("$Account Unlocked!" , "Complete!",0)
					$Complete
				}
			}
		Elseif ($LockedBox.SelectedIndex -lt 0)
			{
				[System.Windows.Forms.MessageBox]::Show("No Item Selected!","Unh Unh Unh, You didn't say the magic word!",0,[Windows.Forms.MessageBoxIcon]::Warning)
			}
		
	$END Button UNLOCK SINGLE 33333333333333333333333333333333333333333333333333333333
	
$END SAS ACCOUNT LOCKOUT

4444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444	
	
	$IAVM Current and Update
	Current (RDR)
	
		. "<<Computer>>\desktop\SASscripts\TPTestbed\TPVariables.ps1"
		$RDRTxt.Text = $RequiredVersionRDR
		
	UPGR(RDR) Defined function -> call function
	
	Function RDRUpdate {
	. "<<Computer>>\desktop\SASscripts\TPTestbed\TPVariables.ps1"
	If ($RDRtxt.Text -ne "") {
		(Get-Content .\TPVariables.ps1) |  foreach-object {$_.replace($RequiredVersionRDR,$RDRtxt.Text)} | set-content .\TPVariables.ps1
	}
	
	Call
	{
		RDRUpdate
	}
	
44444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444
		
$START SAS LOCAL ADMINS SEARCH MACHINES 3333333333333333333333333333333333333333333333333333333333

IF(-not $Append)
		{
			$AdminBox.items.clear()
		}
	
	
	$SASmach = $LocalAdmintxt.text 
	$Result = @()	
	
	If (Test-Connection -comp $SASmach -count 1)
		{
			
			$computer = [ADSI]("WinNT://"+ $SASmach + ",computer")
			$Group = $computer.psbase.children.find("Administrators")
			function getAdmins
			{
				$members = ($Group.psbase.invoke("Members") | %{$_.GetType().invokemember("Adspath",'GetProperty',$null,$_,$null)}) -replace ('WinNT://DOMAIN/' + $SASmach + '/'), ''-replace ('WinNT://DOMAIN/','DOMAIN\') -replace ('WinNT://','') 
				$members}
				$Result += (getAdmins)
										
				<#Foreach ($Result2 in $members)
				{
					$Adminbox.Items.add($Result2)
				}
			#>
			
		}
	Else 
		{
			[System.Windows.Forms.MessageBox]::Show("SAS Machine is Offline or cannot be found. Please check your spelling and try again.","Hmmm...Nothing Found",0)
		}
	Foreach ($user in $Result)
		{
			$AdminBox.Items.Add($User)
		}
	
$END SAS LOCAL ADMINS SEARCH MACHINES 333333333333333333333333333333333333333333333333333333

444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444

$START SAS System Uptime

	$Computer = $UptimeNametxt.Text

	If (Test-Connection -comp $Computer  -count 1)
	{
		$lastbootime = (Get-WMIObject -class Win32_OperatingSystem -computername $Computer).LastbootUpTime
		$sysuptime = (Get-Date) - [System.Management.ManagementDateTimeconverter]::ToDateTime($lastbootime)
		$totaluptime = "  $Computer has been up for: ",$sysuptime.days ,"days ",$sysuptime.hours,"hours ",$sysuptime.minutes, "minutes",$sysuptime.seconds,"seconds"
		$totaluptimetxt.Text = $totaluptime
	}
	else
		{
			[System.Windows.Forms.MessageBox]::Show("SAS Machine is Offline or cannot be found. Please check your spelling and try again.","Hmmm...Nothing Found",0)
		}
$END SAS System Uptime
	