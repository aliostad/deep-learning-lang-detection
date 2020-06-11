package common.drivers

import java.util.concurrent.TimeUnit

import org.apache.commons.lang3.StringUtils
import org.openqa.selenium.WebDriver
import org.openqa.selenium.chrome.{ChromeDriver, ChromeOptions}
import org.openqa.selenium.remote.DesiredCapabilities

object Browsers {

  def getOs = System.getProperty("os.name")

  lazy val systemProperties = System.getProperties
  lazy val isMac: Boolean = getOs.startsWith("Mac")
  lazy val isLinux: Boolean = getOs.startsWith("Linux")
  lazy val linuxArch = systemProperties.getProperty("os.arch")
  lazy val isWindows: Boolean = getOs.startsWith("Windows")

  def createChromeDriver(): WebDriver = {
    if (StringUtils.isEmpty(systemProperties.getProperty("webdriver.chrome.driver"))) {
      if (isMac)
        systemProperties.setProperty("webdriver.chrome.driver", "drivers/chromedriver_mac64")
      else if (isLinux && linuxArch == "amd32")
        systemProperties.setProperty("webdriver.chrome.driver", "drivers/chromedriver_linux32")
      else if (isWindows)
        System.setProperty("webdriver.chrome.driver", "drivers//chromedriver_win32.exe")
      else
        systemProperties.setProperty("webdriver.chrome.driver", "drivers/chromedriver_linux64")
    }

    val capabilities = DesiredCapabilities.chrome()
    capabilities.setJavascriptEnabled(true)

    val options = new ChromeOptions()
    capabilities.setCapability(ChromeOptions.CAPABILITY, options)
    val driver = new ChromeDriver(capabilities)
    driver.manage().window().maximize()
    driver.manage().timeouts().pageLoadTimeout(30, TimeUnit.SECONDS)
    driver.manage().timeouts().setScriptTimeout(30, TimeUnit.SECONDS)
    driver
  }

}
