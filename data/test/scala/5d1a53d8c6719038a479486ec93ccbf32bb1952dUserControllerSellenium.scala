package sellenium

import java.util.concurrent.TimeUnit

import org.openqa.selenium.firefox.FirefoxDriver
import org.scalatest.FlatSpec
import org.scalatest.selenium.Firefox

/**
  * Created by knoldus on 11/3/16.
  */
class UserControllerSellenium extends FlatSpec {

    val portNo=9000

  val baseUrl="http://localhost:"+portNo+"/users/login"


  "intern" should "successfully hit the url" in {

    val driver=new FirefoxDriver()
    driver.get(baseUrl)
    driver.manage().timeouts().implicitlyWait(10,TimeUnit.SECONDS)
  }

}
