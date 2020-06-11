package selenium.util

import java.net.URL
import java.util.{Date}
import io.github.bonigarcia.wdm.ChromeDriverManager
import org.openqa.selenium.chrome.ChromeDriver
import org.openqa.selenium.remote.{DesiredCapabilities, RemoteWebDriver}
import org.openqa.selenium.{Cookie, WebDriver}

object Driver {

  def apply(): WebDriver = driver

  private lazy val driver: WebDriver = createDriver

  def createDriver: WebDriver =
    if (Config.webDriverRemoteUrl.isEmpty)
      instantiateLocalBrowser()
    else
      instantiateRemoteBrowser()

  // Used in dev to run tests locally
  private def instantiateLocalBrowser(): WebDriver = {
    ChromeDriverManager.getInstance().setup()
    new ChromeDriver()
  }

  // Used by Travis to run tests in SauceLabs
  private def instantiateRemoteBrowser(): WebDriver = {
    val caps = DesiredCapabilities.chrome()
    caps.setCapability("platform", "Windows 8.1")
    caps.setCapability("name", "support-frontend")
    caps.setCapability("version", "60")
    new RemoteWebDriver(new URL(Config.webDriverRemoteUrl), caps)
  }

  def reset(): Unit = {
    driver.get(Config.paypalSandbox)
    driver.manage.deleteAllCookies()

    driver.get(Config.contributionFrontend)
    driver.manage.deleteAllCookies()

    driver.get(Config.identityFrontendUrl)
    driver.manage.deleteAllCookies()

    driver.get(Config.supportFrontendUrl)
    driver.manage.deleteAllCookies()
  }

  def quit(): Unit = driver.quit()

  def addCookie(name: String, value: String, domain: Option[String] = None, path: String = "/", date: Option[Date] = None): Unit = {
    driver.manage.addCookie(new Cookie(name, value, domain.orNull, path, date.orNull))
  }

  val sessionId = driver.asInstanceOf[RemoteWebDriver].getSessionId.toString

}
