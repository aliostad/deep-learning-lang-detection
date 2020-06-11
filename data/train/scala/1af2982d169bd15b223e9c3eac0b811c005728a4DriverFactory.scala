package implementation.selenium

import java.util.concurrent.TimeUnit
import java.util.logging.Level

import implementation.utils.Configuration
import org.openqa.selenium.htmlunit.HtmlUnitDriver
import org.openqa.selenium.{WebDriver, WebDriverException}
import org.openqa.selenium.firefox.FirefoxDriver

object DriverFactory {

  def buildWebDriver = {

    val webDriver = System.getProperty("browser", "firefox") match {
      case "htmlunit" => createHtmlUnitDriver()
      case "firefox" => createFirefoxDriver()
    }

    webDriver.manage.timeouts.implicitlyWait(Configuration("defaultWait").toInt, TimeUnit.SECONDS)

    try {
      webDriver.manage.window.maximize()
    }
    catch {
      case e: WebDriverException => //Swallow exception
    }

    webDriver
  }

  def createHtmlUnitDriver(): WebDriver = {
    val htmlUnitDriver: HtmlUnitDriver = new HtmlUnitDriver()
    htmlUnitDriver.setJavascriptEnabled(false)
    System.setProperty("javascriptEnabled", "false")
    java.util.logging.Logger.getLogger("com.gargoylesoftware.htmlunit").setLevel(Level.OFF)
    htmlUnitDriver
  }

  def createFirefoxDriver(): WebDriver = {
    val firefoxDriver: FirefoxDriver = new FirefoxDriver()
    firefoxDriver
  }

}