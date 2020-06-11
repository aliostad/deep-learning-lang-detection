<# セッションを起動する #>
function newSession($browser) {
  <# WebDriverのdllを指定 #>
  if ($PSVersionTable.PSCompatibleVersions.Major.Contains(4)) {
    Add-Type -Path "/path/to/selenium-dotnet\net40\WebDriver.dll";
  } else {
    Add-Type -Path "/path/to/selenium-dotnet\net35\WebDriver.dll";
  }

  <# chromedriverのパス #>
  $chromeDriverPath = "/path";

  <# The Internet Explorer Driver Serverのパス #>
  $ieDriverpath   = "/path";

  <# Microsoft Edge Driverのパス #>
  $edgeDriverPath = "/path"

  switch ($browser)
  {
    <# Mozilla Firefox #>
    "Firefox" {
            $driver = New-Object OpenQA.Selenium.Firefox.FirefoxDriver;
        }
    <# Google Chrome #>
    "chrome" {
            $driver = New-Object OpenQA.Selenium.Chrome.ChromeDriver($chromeDriverPath);
        }
    <# Internet Explorer Win32版 #>
    "ie" {
            $driver = New-Object OpenQA.Selenium.IE.InternetExplorerDriver($ieDriverPath);
        }
    "Edge" {
            $driver = New-Object OpenQA.Selenium.Edge.EdgeDriver($edgeDriverPath);
       }
    <# それ以外の場合は Google Chrome #>
    default {
            $driver = New-Object OpenQA.Selenium.Chrome.ChromeDriver($chromeDriverPath);
        }
  }

  Write-Output $driver
}


<# セッションを閉じる #>
function closeSession($driver) {
  $driver.Close();
  $driver.Dispose();
}


<# Windowを最大化 #>
function maximizeWindow($driver) {
  $driver.Manage().Window.Maximize();
}


<# URLへ移動 #>
function goURL($driver, $URL) {
  $driver.Url = $URL
}

<# タイトル取得 #>
function getTitle($driver) {
  Write-Output $driver.Title
}

<# タイトル表示待ち #>
<# タイトル1つ #>
function waitForTitle($driver, $title1) {
  do
  {
    Start-Sleep -s 1
  } until($driver.title.Contains($title1))
  Write-Output $title
}

<# タイトル2つ #>
function waitForTwoTitles($driver, $title1, $title2) {
  do
  {
    Start-Sleep -s 1
    $title = $driver.Title;
  } until($title.Contains($title1) -or $title.Contains($title2))
  Write-Output $title
}

<# 部品取得 #>
<# By name #>
function getElementByName($driver, $name) {
  Write-Output $driver.FindElementsByName($name)
}

<# By partial link text #>
function getElementByPartialLinkText($driver, $PartialLinkText) {
  Write-Output $driver.FindElementByPartialLinkText($PartialLinkText)
}

<# By css selector #>
function getElementByCSSselector($driver, $CSSselector) {
  Write-Output $driver.FindElementByCssSelector($CSSselector)
}

<# Click Element #>
function clickElement($element) {
  $element.Click();
}

<# Clear Element #>
function clearElement($element) {
  $element.Clear();
}

<# Send Keys to Element #>
function sendKeysToElement($element, $text) {
  $element.SendKeys($text);
}

<# Submit Element #>
function submitElement($element) {
  $element.Submit();
}
