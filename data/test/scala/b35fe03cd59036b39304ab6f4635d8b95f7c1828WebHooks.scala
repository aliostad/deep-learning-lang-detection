package common.hooks

import common.drivers.Driver
import cucumber.api.Scenario
import cucumber.api.java.{After, Before}
import org.openqa.selenium.{OutputType, TakesScreenshot, WebDriver, WebDriverException}

trait WebHooks {

  implicit val driver: WebDriver = Driver.webDriver

  @Before //(Array("@wip"))
  def initialize() = {
    println("Before this running!!!")
    driver.manage().deleteAllCookies()
    driver.manage().window().maximize()
  }

  @After //(Array("@wip"))
  def tearDown(result: Scenario) = {
    println("After this running!!!")
    if (result.isFailed) {
      driver match {
        case screenshot: TakesScreenshot => {
          try {
            val screenshotTaken = screenshot.getScreenshotAs(OutputType.BYTES)
            result.embed(screenshotTaken, "image/png")
          } catch {
            case somePlatformDontSupportScreenshots: WebDriverException => System.err.println(somePlatformDontSupportScreenshots.getMessage)
          }
        }
        case _ => println("unknown case")
      }
    }
  }
}
