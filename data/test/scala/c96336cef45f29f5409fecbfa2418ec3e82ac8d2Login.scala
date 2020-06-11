package selenium

import java.util.concurrent.TimeUnit

import org.openqa.selenium.firefox.FirefoxDriver
import org.scalatest.FlatSpec
/**
  * Created by prabhat on 11/3/16.
  */
class Login extends FlatSpec{

  val baseUrl = "http://localhost:9000/login"

  "User" should "successfully hit the Url of web application" in{

    val driver = new FirefoxDriver()
    driver.get(baseUrl)
    driver.manage().timeouts().implicitlyWait(10,TimeUnit.SECONDS)
    driver.findElementByCssSelector("BODY").getText().contains("Login")
    Thread.sleep(2000)
    driver.kill()
  }

  "User" should "successfully login" in{

    val driver = new FirefoxDriver()
    driver.get(baseUrl)
    driver.manage().timeouts().implicitlyWait(10,TimeUnit.SECONDS)
    Thread.sleep(1000)
    driver.findElementById("email").sendKeys("prabhatkashyap33@gmail.com")
    driver.findElementById("password").sendKeys("test123")
    driver.findElementByClassName("btn-default").click()
    Thread.sleep(5000)
    driver.findElementByCssSelector("BODY").getText().contains("Welcome")
    Thread.sleep(2000)
    driver.kill()
  }

  "User" should "unsuccessful login" in{

    val driver = new FirefoxDriver()
    driver.get(baseUrl)
    driver.manage().timeouts().implicitlyWait(10,TimeUnit.SECONDS)
    Thread.sleep(1000)
    driver.findElementById("email").sendKeys("prabhatkashyap33@gmail.com")
    driver.findElementById("password").sendKeys("test1231")
    driver.findElementByClassName("btn-default").click()
    Thread.sleep(5000)
    driver.findElementByCssSelector("BODY").getText().contains("Login")
    Thread.sleep(2000)
    driver.kill()
  }

}
