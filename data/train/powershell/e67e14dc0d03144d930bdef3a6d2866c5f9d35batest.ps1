#Copyright (c) 2014 Serguei Kouzmine
#
#Permission is hereby granted, free of charge, to any person obtaining a copy
#of this software and associated documentation files (the "Software"), to deal
#in the Software without restriction, including without limitation the rights
#to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
#copies of the Software, and to permit persons to whom the Software is
#furnished to do so, subject to the following conditions:
#
#The above copyright notice and this permission notice shall be included in
#all copies or substantial portions of the Software.
#
#THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
#IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
#AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
#LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
#OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
#THE SOFTWARE.


Param (
        [switch] $browser
)

# http://stackoverflow.com/questions/8343767/how-to-get-the-current-directory-of-the-cmdlet-being-executed
function Get-ScriptDirectory
{
    $Invocation = (Get-Variable MyInvocation -Scope 1).Value;
    if($Invocation.PSScriptRoot)
    {
        $Invocation.PSScriptRoot;
    }
    Elseif($Invocation.MyCommand.Path)
    {
        Split-Path $Invocation.MyCommand.Path
    }
    else
    {
        $Invocation.InvocationName.Substring(0,$Invocation.InvocationName.LastIndexOf("\"));
    }
}

# http://poshcode.org/1942
function Assert {
  [CmdletBinding()]
  param(
   [Parameter(Position=0,ParameterSetName='Script', Mandatory=$true)]
   [ScriptBlock]$Script,
   [Parameter(Position=0,ParameterSetName='Condition', Mandatory=$true)]
   [bool]$Condition,
   [Parameter(Position=1,Mandatory=$true)]
   [string]$message )
     
  $message = "ASSERT FAILED: $message"
  if($PSCmdlet.ParameterSetName -eq 'Script') {
    try {
      $ErrorActionPreference = 'STOP'
      $success = &$Script
    } catch {
      $success = $false
      $message = "$message`nEXCEPTION THROWN: $($_.Exception.GetType().FullName)"        
    }
  } 
  if($PSCmdlet.ParameterSetName -eq 'Condition') {
    try {
      $ErrorActionPreference = 'STOP'
      $success = $Condition
    } catch {
      $success = $false
      $message = "$message`nEXCEPTION THROWN: $($_.Exception.GetType().FullName)"        
    }
  } 

  if(!$success) {
    throw $message
  }
}

$shared_assemblies =  @(
    'WebDriver.dll',
    'WebDriver.Support.dll',
    'Selenium.WebDriverBackedSelenium.dll',
    'ThoughtWorks.Selenium.Core.dll',
    'ThoughtWorks.Selenium.UnitTests.dll',
    'ThoughtWorks.Selenium.IntegrationTests.dll',
    'Moq.dll'
)
$env:SHARED_ASSEMBLIES_PATH =  'C:\temp\mstest'
$env:SCREENSHOT_PATH =  'C:\temp\mstest' 


$shared_assemblies_path = $env:SHARED_ASSEMBLIES_PATH
$screenshot_path = $env:SCREENSHOT_PATH
pushd $shared_assemblies_path
$shared_assemblies | foreach-object { Unblock-File -Path $_ ; Add-Type -Path  $_ } 
popd

$phantomjs_executable_folder = 'D:\tools\phantomjs'

if ($PSBoundParameters['browser']) {

Try { 
    $connection = (New-Object Net.Sockets.TcpClient)
    $connection.Connect('127.0.0.1',4444)
    $connection.Close()
    }
catch {

  $selemium_driver_folder = 'D:\java\selenium'
  start-process -filepath 'C:\Windows\System32\cmd.exe' -argumentlist "start cmd.exe /c ${selemium_driver_folder}\hub.cmd"
  start-process -filepath 'C:\Windows\System32\cmd.exe' -argumentlist "start cmd.exe /c ${selemium_driver_folder}\node.cmd"
  start-sleep 10

}
  $capability = [OpenQA.Selenium.Remote.DesiredCapabilities]::Firefox()
  $uri = [System.Uri]('http://127.0.0.1:4444/wd/hub')
  $driver = new-object OpenQA.Selenium.Remote.RemoteWebDriver($uri , $capability)
} else {
  $driver = new-object OpenQA.Selenium.PhantomJS.PhantomJSDriver($phantomjs_executable_folder)
  # currently unused 
  $options = new-object OpenQA.Selenium.PhantomJS.PhantomJSOptions
  $options.AddAdditionalCapability("phantomjs.executable.path", $phantomjs_executable_folder);

}  


  $driver.Capabilities.SetCapability('ssl-protocol', 'any' )

  $driver.Capabilities.SetCapability('loggingPrefs', 'webdriver.logging.Level.ALL' )
  $driver.Capabilities.SetCapability('timeout', '300000' )
  $driver.Capabilities.SetCapability('nodeTimeout', '120' )
  $driver.Capabilities.SetCapability('maxSession', '1' )

  $driver.Capabilities.SetCapability('ignore-ssl-errors', $true);
  $driver.capabilities.SetCapability("takesScreenshot", $false );
  $driver.capabilities.SetCapability("userAgent", "Mozilla/5.0 (Windows NT 6.1) AppleWebKit/534.34 (KHTML, like Gecko) PhantomJS/1.9.7 Safari/534.34")


# http://selenium.googlecode.com/git/docs/api/dotnet/index.html
[void]$driver.Manage().Timeouts().ImplicitlyWait( [System.TimeSpan]::FromSeconds(120 )) 
[string]$baseURL = $driver.Url = 'http://www4.uatcarnival.com/';
$driver.Navigate().GoToUrl(('{0}/' -f $baseURL ))

start-sleep 10
$driver.FindElement([OpenQA.Selenium.By]::LinkText('Cruise Details')).Click()
$title =  $driver.Title
# -browser "browserName=safari,version=6.1,platform=OSX,javascriptEnable=true"
# keep going
# assert -Script { ($title.IndexOf('Cruise Deals and Last Minute') -gt -1 ) } -message $title 
<# 
[OpenQA.Selenium.Remote.RemoteWebElement] $queryBox = $driver.FindElement([OpenQA.Selenium.By]::Id('MainBody'))
$queryBox.Clear()
$queryBox.SendKeys('Selenium')
$queryBox.SendKeys([OpenQA.Selenium.Keys]::ArrowDown)
$queryBox.Submit()
#>

# Take screenshot identifying the browser
# $driver.Navigate().GoToUrl("https://www.whatismybrowser.com/")
[OpenQA.Selenium.Screenshot]$screenshot = $driver.GetScreenshot()

$screenshot.SaveAsFile(('{0}\{1}' -f $screenshot_path, 'a.png' ), [System.Drawing.Imaging.ImageFormat]::Png)

# Cleanup
try {
  $driver.Quit()
} catch [Exception] {
  # Ignore errors if unable to close the browser
}
