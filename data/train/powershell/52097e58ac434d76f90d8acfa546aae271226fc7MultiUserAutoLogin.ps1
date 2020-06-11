#import selenium DLLs
cd "C:\"

Add-Type -Path "C:\SeleniumDotNet\net40\Selenium.WebDriverBackedSelenium.dll"
Add-Type -Path "C:\SeleniumDotNet\net40\ThoughtWorks.Selenium.Core.dll"
Add-Type -Path "C:\SeleniumDotNet\net40\WebDriver.dll"
Add-Type -Path "C:\SeleniumDotNet\net40\WebDriver.Support.dll"

$driver = New-Object OpenQA.Selenium.Chrome.ChromeDriver
$wait = New-TimeSpan -Seconds 10
$driver.Manage().Timeouts().ImplicitlyWait($wait)

$driver.Navigate().GoToUrl("https://www.playinitium.com/landing.jsp")

$changeToLoginLanding = $driver.FindElementByLinkText("Login").Click()

#ping localhost -n 2 | Out-Null
Start-Sleep -s 2

$MyAccount1 = ""
$MyPass1 = ""
$MyAccount2 = ""
$MyPass2 = ""
$MyAccount3 = ""
$MyPass3 = ""
$MyAccount4 = ""
$MyPass4 = ""
#######LOGIN#####
$account = $driver.FindElementsByName("email")
$enterAccountDetails = $account[1].SendKeys($MyAccount1)

$pass = $driver.FindElementsByName("password")
$enterPasswordDetails = $pass[1].SendKeys($MyPass1)

$loginButton = $driver.FindElementByLinkText("Login").Click()

###################3

$driver = New-Object OpenQA.Selenium.Chrome.ChromeDriver
$wait = New-TimeSpan -Seconds 10
$driver.Manage().Timeouts().ImplicitlyWait($wait)

$driver.Navigate().GoToUrl("https://www.playinitium.com/landing.jsp")

$changeToLoginLanding = $driver.FindElementByLinkText("Login").Click()

#ping localhost -n 2 | Out-Null
Start-Sleep -s 2

#######LOGIN#####
$account = $driver.FindElementsByName("email")
$enterAccountDetails = $account[1].SendKeys($MyAccount2)

$pass = $driver.FindElementsByName("password")
$enterPasswordDetails = $pass[1].SendKeys($MyPass2)

$loginButton = $driver.FindElementByLinkText("Login").Click()


##############################################

$driver = New-Object OpenQA.Selenium.Chrome.ChromeDriver
$wait = New-TimeSpan -Seconds 10
$driver.Manage().Timeouts().ImplicitlyWait($wait)

$driver.Navigate().GoToUrl("https://www.playinitium.com/landing.jsp")

$changeToLoginLanding = $driver.FindElementByLinkText("Login").Click()

#ping localhost -n 2 | Out-Null
Start-Sleep -s 2

#######LOGIN#####
$account = $driver.FindElementsByName("email")
$enterAccountDetails = $account[1].SendKeys($MyAccount3)

$pass = $driver.FindElementsByName("password")
$enterPasswordDetails = $pass[1].SendKeys($MyPass3)

$loginButton = $driver.FindElementByLinkText("Login").Click()
######################################

$driver = New-Object OpenQA.Selenium.Chrome.ChromeDriver
$wait = New-TimeSpan -Seconds 10
$driver.Manage().Timeouts().ImplicitlyWait($wait)

$driver.Navigate().GoToUrl("https://www.playinitium.com/landing.jsp")

$changeToLoginLanding = $driver.FindElementByLinkText("Login").Click()

#ping localhost -n 2 | Out-Null
Start-Sleep -s 2

#######LOGIN#####
$account = $driver.FindElementsByName("email")
$enterAccountDetails = $account[1].SendKeys($MyAccount4)

$pass = $driver.FindElementsByName("password")
$enterPasswordDetails = $pass[1].SendKeys($MyPass4)

$loginButton = $driver.FindElementByLinkText("Login").Click()
