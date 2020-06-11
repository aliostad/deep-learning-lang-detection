import cucumber.api.scala.{EN, ScalaDsl}
import cucumber.api.Scenario

import play.api.test._

import play.api._
import libs.ws.WS
import play.api.mvc._
import play.api.http._

import play.api.libs.iteratee._
import play.api.libs.concurrent._

import org.openqa.selenium._

import org.openqa.selenium.phantomjs.PhantomJSDriver
import org.openqa.selenium.phantomjs.PhantomJSDriverService
import org.openqa.selenium.remote.DesiredCapabilities

object Env extends ScalaDsl with EN {

  // This is for starting server and stop server.
  // Actually I'm not sure this is correct way.
  var testServer = TestServer(3333)

  private var scenario: Scenario  = null

  // for phantomjs
  val browser: TestBrowser = {
    val sCaps = new DesiredCapabilities()
    val phantomjsPath = {
      if(null != System.getenv("PHANTOMJS_PATH")){
        System.getenv("PHANTOMJS_PATH")
      } else {
        System.getProperty("PHANTOMJS_PATH")
      }
    }

    sCaps.setJavascriptEnabled(true);
    sCaps.setCapability("takesScreenshot", true);
    sCaps.setCapability(PhantomJSDriverService.PHANTOMJS_EXECUTABLE_PATH_PROPERTY, phantomjsPath)

    // Disable "web-security", enable all possible "ssl-protocols" and "ignore-ssl-errors" for PhantomJSDriver
    sCaps.setCapability(PhantomJSDriverService.PHANTOMJS_CLI_ARGS, Array(
      "--web-security=false",
      "--ssl-protocol=any",
      "--ignore-ssl-errors=true"
    ))

    val driver = new PhantomJSDriver(sCaps)
    // set timeout
    driver.manage().timeouts().implicitlyWait(5L, java.util.concurrent.TimeUnit.SECONDS)
    driver.manage().timeouts().pageLoadTimeout(10L, java.util.concurrent.TimeUnit.SECONDS)
    driver.manage().timeouts().setScriptTimeout(10L, java.util.concurrent.TimeUnit.SECONDS)
    TestBrowser(driver, None)
  }

  def takeScreenshot() = {
    browser.webDriver match {
      case driver: org.openqa.selenium.phantomjs.PhantomJSDriver => {
        scenario.embed(driver.getScreenshotAs(org.openqa.selenium.OutputType.BYTES), "image/png")
      }
      case _ => {}
    }
  }

  Before{ sc: Scenario =>
    scenario = sc
    testServer = TestServer(3333)
    testServer.start()
  }
  After{ sc: Scenario =>
    browser.quit()
    testServer.stop()
  }
}
