package common.drivers

import org.openqa.selenium.WebDriver
import org.scalatest.selenium.{Chrome, Firefox}

object Browsers {

  def createFirefoxDriver: WebDriver = {
    Firefox.firefoxProfile.setAcceptUntrustedCertificates(true)
    val driver = Firefox.webDriver
    driver.manage().deleteAllCookies()
    driver.manage().window().maximize()
    driver
  }

  def createChromeDriver: WebDriver = {
    System.setProperty("webdriver.chrome.driver", "chrome/chromedriver.exe");
    val driver = Chrome.webDriver
    driver.manage().window().maximize()
    driver.manage().deleteAllCookies()
    driver
  }

}
