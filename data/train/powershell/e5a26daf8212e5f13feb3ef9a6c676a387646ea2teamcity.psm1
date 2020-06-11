if ($env:TEAMCITY_VERSION) {
	# When PowerShell is started through TeamCity's Command Runner, the standard
	# output will be wrapped at column 80 (a default). This has a negative impact
	# on service messages, as TeamCity quite naturally fails parsing a wrapped
	# message. The solution is to set a new, much wider output width. It will
	# only be set if TEAMCITY_VERSION exists, i.e., if started by TeamCity.
	$host.UI.RawUI.BufferSize = New-Object System.Management.Automation.Host.Size(8192,50)
}

function Log([string]$msg){
	if($env:TEAMCITY_VERSION){
		Write-Host "##teamcity[$msg]"
	}
}

function TeamCity-StartBlock([string]$name) {
	Log "blockOpened name='$name'"
}

function TeamCity-EndBlock([string]$name) {
	Log "blockClosed name='$name']"
}

function TeamCity-Log([string]$message, [string]$details){
	Log "message text='$message' errorDetails='$details' status='NORMAL'"
}

function TeamCity-Warn([string]$message, [string]$details){
	Log "message text='$message' errorDetails='$details' status='WARNING'"
}

function TeamCity-Failure([string]$message, [string]$details){
	Log "message text='$message' errorDetails='$details' status='FAILURE'"
}

function TeamCity-Error([string]$message, [string]$details){
	Log "message text='$message' errorDetails='$details' status='ERROR'"
}

function TeamCity-CompilationStarted([string]$name){
	Log "compilationStarted compiler='$name]"
}

function TeamCity-CompilationFinished([string]$name){
	Log "compilationFinished compiler='$name'"
}

function TeamCity-PublishArtifact([string]$path){
	Log "publishArtifacts '$path'"
}

function TeamCity-TestSuiteStarted([string]$name) {
	Log "testSuiteStarted name='$name'"
}

function TeamCity-TestSuiteFinished([string]$name) {
	Log "testSuiteFinished name='$name'"
}

function TeamCity-ProgressMessage([string]$message) {
	Log "progressMessage '$message'"
}

function TeamCity-ProgressStart([string]$message) {
	Log "progressStart '$message'"
}

function TeamCity-ProgressFinish([string]$message) {
	Log "progressFinish '$message'"
}

# See http://confluence.jetbrains.net/display/TCD5/Manually+Configuring+Reporting+Coverage
function TeamCity-ConfigureDotNetCoverage([string]$key, [string]$value) {
	Log "dotNetCoverage $key='$value'"
}

function TeamCity-ImportDotNetCoverageResult([string]$tool, [string]$path) {
	Log "importData type='dotNetCoverage' tool='$tool' path='$path'"
}

# See http://confluence.jetbrains.net/display/TCD5/FxCop_#FxCop_-UsingServiceMessages
function TeamCity-ImportFxCopResult([string]$path) {
	Log "importData type='FxCop' path='$path'"
}

function TeamCity-ImportNUnitResult([string]$path) {
	Log "importData type='nunit' path='$path'"
}

function TeamCity-ReportBuildStatus([string]$status, [string]$text='') {
	Log "buildStatus '$status' text='$text'"
}

function TeamCity-SetBuildNumber([string]$buildNumber) {
	Log "buildNumber '$buildNumber'"
}

function TeamCity-SetBuildStatistic([string]$key, [string]$value) {
	Log "buildStatisticValue key='$key' value='$value'"
}

function TeamCity-CreateInfoDocument([string]$buildNumber='', [boolean]$status=$true, [string[]]$statusText=$null, [System.Collections.IDictionary]$statistics=$null) {
	$doc=New-Object xml;
	$buildEl=$doc.CreateElement('build');
	
	if (![string]::IsNullOrEmpty($buildNumber)) {
		$buildEl.SetAttribute('number', $buildNumber);
	}
	
	$buildEl=$doc.AppendChild($buildEl);
	
	$statusEl=$doc.CreateElement('statusInfo');
	if ($status) {
		$statusEl.SetAttribute('status', 'SUCCESS');
	} else {
		$statusEl.SetAttribute('status', 'FAILURE');
	}
	
	if ($statusText -ne $null) {
		foreach ($text in $statusText) {
			$textEl=$doc.CreateElement('text');
			$textEl.SetAttribute('action', 'append');
			$textEl.set_InnerText($text);
			$textEl=$statusEl.AppendChild($textEl);
		}
	}	
	
	$statusEl=$buildEl.AppendChild($statusEl);
	
	if ($statistics -ne $null) {
		foreach ($key in $statistics.Keys) {
			$val=$statistics.$key
			if ($val -eq $null) {
				$val=''
			}
			
			$statEl=$doc.CreateElement('statisticsValue');
			$statEl.SetAttribute('key', $key);
			$statEl.SetAttribute('value', $val.ToString());
			$statEl=$buildEl.AppendChild($statEl);
		}
	}
	
	return $doc;
}

function TeamCity-WriteInfoDocument([xml]$doc) {
	$dir=(Split-Path $buildFile)
	$path=(Join-Path $dir 'teamcity-info.xml')
	
	$doc.Save($path);
}