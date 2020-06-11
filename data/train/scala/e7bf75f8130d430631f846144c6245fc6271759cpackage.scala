package com.automation

import java.util.concurrent.TimeUnit

import org.apache.logging.log4j.{LogManager, Logger}
import org.openqa.selenium.WebDriver
import org.openqa.selenium.chrome.ChromeDriver


package object driver {
  private[automation] val logger: Logger = LogManager.getRootLogger
  private val WEBDRIVER_GECKO_DRIVER: String = "webdriver.chrome.driver"
  private val GECKODRIVER_GECKODRIVER_EXE_PATH: String = ".\\..\\..\\chromedriver\\chromedriver.exe"

  def getDriver = {
    System.setProperty(WEBDRIVER_GECKO_DRIVER, GECKODRIVER_GECKODRIVER_EXE_PATH)
    val driver = new ChromeDriver
    driver.manage.timeouts.pageLoadTimeout(10, TimeUnit.SECONDS)
    driver.manage.timeouts.implicitlyWait(10, TimeUnit.SECONDS)
    driver.manage.window.maximize()
//    logger.info("Browser started")
    driver
  }

  def closeDriver(driver: WebDriver) = driver.quit()

}
