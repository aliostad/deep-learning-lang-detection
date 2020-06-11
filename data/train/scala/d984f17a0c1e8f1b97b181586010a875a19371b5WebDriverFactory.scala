package uk.gov.dvla.vehicles.presentation.common.helpers.webbrowser

import java.util
import java.util.concurrent.TimeUnit

import org.openqa.selenium.WebDriver.{Navigation, Options, TargetLocator}
import org.openqa.selenium.chrome.ChromeDriver
import org.openqa.selenium.firefox.{FirefoxDriver, FirefoxProfile}
import org.openqa.selenium.htmlunit.HtmlUnitDriver
import org.openqa.selenium.ie.InternetExplorerDriver
import org.openqa.selenium.phantomjs.{PhantomJSDriver, PhantomJSDriverService}
import org.openqa.selenium.remote.DesiredCapabilities
import org.openqa.selenium.safari.SafariDriver
import org.openqa.selenium.{By, WebDriver, WebElement}
import uk.gov.dvla.vehicles.presentation.common.ConfigProperties._
import uk.gov.dvla.vehicles.presentation.common.views.widgetdriver.Wait

object WebDriverFactory {
  private val systemProperties = System.getProperties

  def browserType = browserTypeDefault()

  def browserTypeDefault(default: String = "htmlunit") = sys.props.getOrElse("browser.type", default)

  def webDriver: WebDriver = {
    val targetBrowser = browserType
    webDriver(
      targetBrowser = targetBrowser,
      javascriptEnabled = false // Default to off.
    )
  }

  def webDriver(targetBrowser: String, javascriptEnabled: Boolean): WebDriver = {
    val selectedDriver: WebDriver = {

      targetBrowser match {
        case "chrome" => chromeDriver
        case "ie" => new InternetExplorerDriver()
        case "internetexplorer" => new InternetExplorerDriver()
        case "safari" => new SafariDriver()
        case "firefox" => firefoxDriver
        case "phantomjs" => phantomjsDriver(javascriptEnabled)
        case _ => htmlUnitDriver(javascriptEnabled) // Default
      }
    }

    lazy val implicitlyWait = try {
      getProperty[Int]("browser.implicitlyWait")
    } catch {
      case _:Throwable => 100
    }
//    val implicitlyWait = getProperty("browser.implicitlyWait", 5000)
    selectedDriver.manage().timeouts().implicitlyWait(implicitlyWait, TimeUnit.MILLISECONDS)
    selectedDriver.manage().window().setSize(new org.openqa.selenium.Dimension(1200, 800))
    Wait.until(Wait.windowSizeGreaterThan(1199, 799))(selectedDriver)

    selectedDriver
  }

  def webDriver(javascriptEnabled: Boolean): WebDriver = {
    webDriver(browserType, javascriptEnabled)
  }

  def testUrl: String = TestConfiguration.testUrl

  lazy val defaultBrowserPhantomJs: WebDriver = new WebDriverProxy(webDriver(browserTypeDefault("phantomjs"), true))

  def defaultBrowserPhantomJsNoJs: WebDriver = webDriver(browserTypeDefault("phantomjs"), false)

  private def chromeDriver = {
    val webDriverProperty: String = try {
      getProperty[String]("webdriver.chrome.driver")
    } catch {
      case _:Throwable => s"test/resources/drivers/chromedriver"
    }

    systemProperties.setProperty(
      "webdriver.chrome.driver",
      webDriverProperty)

    new ChromeDriver()
  }

  private def htmlUnitDriver(javascriptEnabled: Boolean) = {
    val driver = new HtmlUnitDriver()
    driver.setJavascriptEnabled(javascriptEnabled) // TODO HTMLUnit blows up when navigating live site due to JavaScript errors!

    driver
  }

  private def firefoxDriver = {
    val firefoxProfile = new FirefoxProfile()
    firefoxProfile.setAcceptUntrustedCertificates(true)
    new FirefoxDriver(firefoxProfile)
  }

  private def phantomjsDriver(javascriptEnabled: Boolean) = {

    val capabilities = new DesiredCapabilities
    capabilities.setJavascriptEnabled(javascriptEnabled)
    capabilities.setCapability("takesScreenshot", false)
    capabilities.setCapability(
      PhantomJSDriverService.PHANTOMJS_CLI_ARGS,
      Array("--ignore-ssl-errors=yes", "--web-security=false", "--ssl-protocol=any")
    )

    new PhantomJSDriver(capabilities)
  }

  private val driverSuffix: String = sys.props.get("os.name") match {
    case Some(os) if os.contains("mac") => "macosx"
    case _ => "linux64"
  }

  private class WebDriverProxy(driver: WebDriver) extends WebDriver {
    override def getPageSource: String = driver.getPageSource

    override def findElements(by: By): util.List[WebElement] = driver.findElements(by)

    override def getWindowHandle: String = driver.getWindowHandle

    override def get(url: String): Unit = driver.get(url)

    override def manage(): Options = driver.manage()

    override def getWindowHandles: util.Set[String] = driver.getWindowHandles

    override def switchTo(): TargetLocator = driver.switchTo()

    override def close(): Unit = driver.manage().deleteAllCookies()

    override def quit(): Unit = driver.manage().deleteAllCookies()

    override def getCurrentUrl: String = driver.getCurrentUrl

    override def navigate(): Navigation = driver.navigate()

    override def getTitle: String = driver.getTitle

    override def findElement(by: By): WebElement = driver.findElement(by)
  }
}
