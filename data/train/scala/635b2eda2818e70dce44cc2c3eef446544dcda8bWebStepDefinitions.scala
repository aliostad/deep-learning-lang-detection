package cucumber

import java.util.concurrent.TimeUnit._

import cucumber.api.Scenario
import cucumber.api.scala.ScalaDsl
import cucumber.util.GlobalCucumberHooks
import org.openqa.selenium.OutputType._
import org.openqa.selenium.WebDriverException
import org.openqa.selenium.firefox.FirefoxDriver
import org.scalatest.selenium.WebBrowser

object WebStepDefinitions extends GlobalCucumberHooks {
  private lazy val webDriver = new FirefoxDriver()

  BeforeAll {
    webDriver.manage.timeouts.implicitlyWait(10, SECONDS)
  }

  Before { _ =>
    webDriver.manage.deleteAllCookies()
  }

  AfterAll {
    webDriver.quit()
  }
}

trait WebStepDefinitions extends ScalaDsl with WebBrowser {
  implicit protected def webDriver = WebStepDefinitions.webDriver

  private var scenario: Scenario = _

  Before { scenario =>
    this.scenario = scenario
  }

  protected def embedScreenShotInReport(): Unit =
    try {
      val screenShot = webDriver.getScreenshotAs(BYTES)
      scenario.embed(screenShot, "image/png")
    } catch {
      case somePlatformsDontSupportScreenShots: WebDriverException =>
        System.err.println(somePlatformsDontSupportScreenShots.getMessage)
    }
}
