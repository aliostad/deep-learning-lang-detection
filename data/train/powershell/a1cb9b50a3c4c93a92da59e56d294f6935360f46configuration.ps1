Set-ExecutionPolicy Unrestricted -Force

#---------------------------------------------
#Script Globals
#---------------------------------------------
$global:notification_executable = "c:\repositories\xspec\build\xspec.notifier.exe"
$global:solution ="c:\repositories\xspec\xspec.sln"
$global:dev_engine = "c:\Program Files (x86)\Microsoft Visual Studio 10.0\Common7\IDE\devenv.exe"
$global:build_engine = "C:\Windows\Microsoft.NET\Framework\v4.0.30319\msbuild"
$global:test_engine = "C:\Program Files (x86)\Microsoft Visual Studio 10.0\Common7\IDE\mstest"
#---------------------------------------------
#Script Functions
#---------------------------------------------
function Parse-BuildOutput{
	params(
		[string]$result = ""
	)
	
	#-- parse the msbuild output from the solution and determine whether or not to continue:
    $newline = [System.Environment]::NewLine;
	$content = "";
	$failed_build_triggered = $false;
	
	foreach( $line in $result )
	{
		if($line.StartsWith("Build Failed"))
		{
			$failed_build_triggered = $true;
		}
		
		if($line.trim() -ne "" )
		{
		 $content += [System.String]::Concat($content, $line, $newline);
		}
	}

	$title = "Build - OK";
	$level = "success"; 
	$message = "Success";
	
	if($content -ne "")
	{
		$title = "Build - Error";
		$level = "failure";
		$message = $content;
	}
	
	# -- send notification about build:	
	Generate-Notification `
		-level $level `
		-title $title `
		-message $message
}
function Parse-TestOutput{
	params(
		[string]$result = ""
	)
	
	#-- use xspec console test output parser:
	Parse-xSpecTestOutput `
	-result $result
}
#---------------------------------------------------------------------------------------  
# function to generate the user feedback notification for the build and test cycle.
#--------------------------------------------------------------------------------------- 
function Generate-Notification{
	params(
	[string]$level = "info", 
	[string]$title = "Title", 
	[string]$message = "Message"
	)
	
	UseXSpecNotifyForNotification `
    -level $level, `
	-title $title, `
	-message $message
}

# ---------- private functions ------------
function Parse-xSpecTestOutput{
	params(
		[string]$result = ""
		)
	
	$newline = [System.Environment]::NewLine;
	$content = "";
	
	foreach( $line in $result )
	{
		if($line.trim().StartsWith("it") -ne $false)
		{
            if(line.trim().Contains("FAILED") -ne $false)
            {
			 $content += [System.String]::Concat($content, ">>", $line, $newline);
            }
		}
	}
	
	$title = "Test - Success";
	$level = "success"; 
	$message = "Success";
	
	if($content -ne "")
	{
		$title = "Test - Failed";
		$level = "failure";
		$message = $content;
	}
	
	# -- send notification about test session:	
	Generate-Notification `
		-level $level `
		-title $title `
		-message $message
}

function UseXSpecNotifyForNotification{
	params(
	[string]$level = "info", 
	[string]$title = "Title", 
	[string]$message = "Message"
	)
	
	#-- using xspec notify for feedback to the user:
	Get-Executable-Names 
	| where { $_ -match "xspec.notifier.exe" } 
	| kill
	
	$xspec_notify = "$build_dir\xspec.notifier.exe"
	.xspec_notify "/level $level /title $title /message $message"
}
function UseGrowlForNotifications{
	params(
	[string]$level = "info", 
	[string]$title = "Title", 
	[string]$message = "Message"
	)
	
	# -- using growl notification for feedback to user:
	# $growl_notify = "C:\utils\growl for windows\growlnotify.exe"
	# .growl_notify "/i:$level.png /t:$title /m:$message"
}
#---------------------------------------------
#Script Start
#---------------------------------------------
Parse-BuildOutput `
-result "it should pass"