Describe "Invoke-JavaScriptExecution" {
    #NEED TO ADD ASYNC TESTS
    Context "Test sync and async execution" {
        #setup the driver
        $htmlUnitCaps = [OpenQA.Selenium.Remote.DesiredCapabilities]::HtmlUnitWithJavaScript()
        $driver = New-Object OpenQA.Selenium.Remote.RemoteWebDriver -ArgumentList @($htmlUnitCaps)
        $driver.Navigate().GoToUrl("file:///C:/Users/Matt/dotNet/PowerShellDriver/Test/Resources/testpage.html")   #load the test page
        $driver.Manage().Timeouts().SetScriptTimeout([System.TimeSpan]::FromSeconds(2))

        It "executes javascript w/o parameters synchronously" {
            $result_dotNet = ([OpenQA.Selenium.IJavaScriptExecutor]$driver).ExecuteScript("return document.title")
            $result_poSh = $driver | Invoke-JavaScriptExecution "return document.title"
            $result_poSh | Should Be $result_dotNet
        }
        <#It "executes javascript w/o parameters asynchronously" {
            $result_dotNet = ([OpenQA.Selenium.IJavaScriptExecutor]$driver).ExecuteAsyncScript("return document.title")
            $result_poSh = $driver | Invoke-JavaScriptExecution "return document.title" -Async
            $result_poSh | Should Be $result_dotNet
        }#>
        $elem = $driver.FindElementByTagName("h1")
        It "executes javascript w/ parameters synchronously" {
            $driver | Invoke-JavaScriptExecution "arguments[0].color='blue'" @($elem)
            $elem.GetCssValue("color") | Should Be "blue"
        }
        <#It "executes javascript w/ parameters asynchrously" {
            $driver | Invoke-JavaScriptExecution "arguments[0].color='red'" @($elem) -Async
            $elem.GetCssValue("color") | Should Be "red"
        }#>
        $driver.Quit()
    }

    Context "specifying -PassThru parameter" {
        #setup the driver
        $htmlUnitCaps = [OpenQA.Selenium.Remote.DesiredCapabilities]::HtmlUnitWithJavaScript()
        $driver = New-Object OpenQA.Selenium.Remote.RemoteWebDriver -ArgumentList @($htmlUnitCaps)
        $driver.Navigate().GoToUrl("file:///C:/Users/Matt/dotNet/PowerShellDriver/Test/Resources/testpage.html")   #load the test page
        $driver.Manage().Timeouts().SetScriptTimeout([System.TimeSpan]::FromSeconds(2))

        It "writes to the script_result variable" {
            $driver | Invoke-JavaScriptExecution "return document.title" -PassThru
            $script_result | Should Be $driver.ExecuteScript("return document.title")
        }
        It "passes the driver through" {
            $elem = $driver | Invoke-JavaScriptExecution "return document.title" -PassThru | Find-WebElement "h1" -ByTagName
            $elem_dotNet = $driver.FindElementByTagName("h1")
            $elem | Should Be $elem_dotNet
        }
        $driver.Quit()
    }
}