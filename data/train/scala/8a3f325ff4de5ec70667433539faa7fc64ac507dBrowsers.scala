package drivers

import org.openqa.selenium.WebDriver
import org.scalatest.selenium.Chrome

object Browsers {

  def getOs = System.getProperty("os.name")

  lazy val systemProperties = System.getProperties
  lazy val isMac: Boolean = getOs.startsWith("Mac")
  lazy val isLinux: Boolean = getOs.startsWith("Linux")
  lazy val linuxArch = systemProperties.getProperty("os.arch")
  lazy val isWindows: Boolean = getOs.startsWith("Windows")

  def createChromeDriver: WebDriver = {
    if (isMac) systemProperties.setProperty("webdriver.chrome.driver", "drivers/chromedriver_mac64")
    else if (isLinux && linuxArch == "amd32") systemProperties.setProperty("webdriver.chrome.driver", "drivers/chromedriver_linux32")
    else if (isWindows) System.setProperty("webdriver.chrome.driver", "drivers//chromedriver.exe")
    else systemProperties.setProperty("webdriver.chrome.driver", "drivers/chromedriver_linux64")
    val driver = Chrome.webDriver
    driver.manage().window().maximize()
    driver.manage().deleteAllCookies()
    driver
  }

}

