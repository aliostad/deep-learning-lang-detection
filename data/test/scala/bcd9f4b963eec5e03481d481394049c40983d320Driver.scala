package orangebus.cucumber.utils.BrowserPackage

import org.openqa.selenium.WebDriver

import scala.util.Try


object Driver extends Browser {


  val instance: WebDriver = initialiseBrowser

  def initialiseBrowser: WebDriver = {

      val driver = createBrowser()
      driver.manage().window().maximize()

    driver
  }

  private def createBrowser(): WebDriver = {

    val browserProperty = System.getProperty("browser", "firefox-local")


      browserProperty match {
        case "firefox-local" => createFirefoxDriver
        case _ => throw new IllegalArgumentException(s"Browser type not recognised")
      }

  }

    sys addShutdownHook {
    Try(instance.quit())
  }

}
