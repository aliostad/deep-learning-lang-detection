package common.hooks

import common.drivers.Driver
import cucumber.api.Scenario
import cucumber.api.java.{After, Before}
import org.openqa.selenium.{OutputType, TakesScreenshot, WebDriver, WebDriverException}

trait WebHooks {

  implicit val driver: WebDriver = Driver.webDriver

  @Before
  def initialize() = {
    driver.manage().deleteAllCookies()
    driver.manage().window().maximize()
  }

  @After
  def tearDown(result: Scenario) = {
    if (result.isFailed) {
      driver match {
        case screenshot: TakesScreenshot =>
          try {
            val screenshotTaken = screenshot.getScreenshotAs(OutputType.BYTES)
            result.embed(screenshotTaken, "image/png")
          } catch {
            case somePlatformDontSupportScreenshots: WebDriverException => System.err.println(somePlatformDontSupportScreenshots.getMessage)
          }
        case _ => println("unknown case")
      }
    }
  }
}
