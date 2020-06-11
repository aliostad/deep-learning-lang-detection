package steps

import cucumber.api.scala.{EN, ScalaDsl}
import org.openqa.selenium.chrome.ChromeDriver
import org.openqa.selenium.firefox.{FirefoxDriver, FirefoxProfile}
import org.openqa.selenium.{WebDriver}
import org.scalatest.Matchers
import scala.util.Try

trait Env extends ScalaDsl with EN with Matchers {

  val driver: WebDriver = createWebDriver
  lazy val createWebDriver: WebDriver = {
      val targetBrowser = System.getProperty("browser", "firefox-local").toLowerCase
      targetBrowser match {
        case "chrome-local" => createChromeDriver
        case "firefox-local" => createFirefoxDriver
        case _ => throw new IllegalArgumentException(s"target browser $targetBrowser not recognised")
      }
    }

  def createChromeDriver(): WebDriver = {
    val driver = new ChromeDriver()
    driver.manage().window().maximize()
    driver
  }

  def createFirefoxDriver(): WebDriver = {
    val profile = new FirefoxProfile
    profile.setAcceptUntrustedCertificates(true)
    new FirefoxDriver(profile)
  }

  def shutdown() = {
    Try(driver.quit())
  }

  Before { scenario =>
    driver.manage().deleteAllCookies()
  }
}

object Env extends Env
