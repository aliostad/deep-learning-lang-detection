package selenium

import java.util.concurrent.TimeUnit

import org.openqa.selenium.WebDriver.Timeouts

import org.openqa.selenium.firefox.FirefoxDriver
import org.scalatest.FlatSpec
import play.api.test.WithBrowser

/**
  * Created by knodus on 11/3/16.
  */
class UserControllerTest extends FlatSpec{

  //val port=9000
  val baseUrl="http://localhost:9000/users/login"


    "intern" should "successfully hit the url" in {

      val driver=new FirefoxDriver()
      driver.get(baseUrl)
      driver.manage().timeouts().implicitlyWait(10,TimeUnit.SECONDS)
      driver.findElementByClassName("btn").click()

    }

}
