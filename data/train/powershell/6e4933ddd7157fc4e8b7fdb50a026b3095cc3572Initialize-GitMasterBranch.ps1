param(
    [switch]$debug
)

function Show-GitBranchesIfDebugging {
	if($debug){ 
	    . git branch -r
	}
}

function Show-GitRemotesIfDebugging {
	if($debug){ 
	    . git remote show origin
	}
}

function Report-TeamCityMessage ([string]$message) {
    write-host "##teamcity[message text=`'$message`']"
}

function Set-TeamCityBuildParameter ([string]$name, [string]$value) {
    write-host "##teamcity[setParameter name=`'$name`' value=`'$value`']"
}

function Initialize-GitMasterBranch {
	# https://github.com/Particular/GitFlowVersion/issues/21#issuecomment-26783071
	#call git remote set-branches origin --add master
	#call git fetch origin
	#call git branch --track master origin/master

	Show-GitBranchesIfDebugging
	Report-TeamCityMessage 'git pull'
	. git pull 
	Show-GitRemotesIfDebugging
	Show-GitBranchesIfDebugging

	$branches = . git branch
	if(-not($branches -match "^\s*master$")){
		Report-TeamCityMessage 'git branch --track master origin/master'
	  . git branch --track master origin/master
	  Show-GitBranchesIfDebugging
	}
}

$ErrorActionPreference = 'Stop'
Initialize-GitMasterBranch