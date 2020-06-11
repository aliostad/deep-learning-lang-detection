package selenium

import java.util.concurrent.TimeUnit

import org.openqa.selenium.firefox.FirefoxDriver
import org.scalatest.FlatSpec
/**
  * Created by prabhat on 11/3/16.
  */
class AdminPanel extends FlatSpec {

  val baseUrl = "http://localhost:9000/"

  "User" should "hit Admin Panel page" in{
    val driver = new FirefoxDriver()
    driver.get(baseUrl)
    driver.manage().timeouts().implicitlyWait(10,TimeUnit.SECONDS)
    driver.findElementById("email").sendKeys("prabhatkashyap33@gmail.com")
    driver.findElementById("password").sendKeys("test123")
    driver.findElementByClassName("btn-default").click()
    driver.findElementByClassName("glyphicon-warning-sign").click()
    driver.findElementByCssSelector("BODY").getText().contains("Admin Panel")
    Thread.sleep(1000)
    driver.kill()
  }

  "User" should "open certificate" in{
    val driver = new FirefoxDriver()
    driver.get(baseUrl)
    driver.manage().timeouts().implicitlyWait(10,TimeUnit.SECONDS)
    driver.findElementById("email").sendKeys("prabhatkashyap33@gmail.com")
    driver.findElementById("password").sendKeys("test123")
    driver.findElementByClassName("btn-default").click()
    driver.findElementByClassName("glyphicon-warning-sign").click()
    driver.findElementByClassName("certificate").click()
    Thread.sleep(2000)
    driver.kill()
  }

  "User" should "open assignment" in{
    val driver = new FirefoxDriver()
    driver.get(baseUrl)
    driver.manage().timeouts().implicitlyWait(10,TimeUnit.SECONDS)
    driver.findElementById("email").sendKeys("prabhatkashyap33@gmail.com")
    driver.findElementById("password").sendKeys("test123")
    driver.findElementByClassName("btn-default").click()
    driver.findElementByClassName("glyphicon-warning-sign").click()
    driver.findElementByClassName("assignment").click()
    Thread.sleep(2000)
    driver.kill()
  }

  "User" should "open language" in{
    val driver = new FirefoxDriver()
    driver.get(baseUrl)
    driver.manage().timeouts().implicitlyWait(10,TimeUnit.SECONDS)
    driver.findElementById("email").sendKeys("prabhatkashyap33@gmail.com")
    driver.findElementById("password").sendKeys("test123")
    driver.findElementByClassName("btn-default").click()
    driver.findElementByClassName("glyphicon-warning-sign").click()
    driver.findElementByClassName("language").click()
    Thread.sleep(2000)
    driver.kill()
  }

  "User" should "open programming language" in{
    val driver = new FirefoxDriver()
    driver.get(baseUrl)
    driver.manage().timeouts().implicitlyWait(10,TimeUnit.SECONDS)
    driver.findElementById("email").sendKeys("prabhatkashyap33@gmail.com")
    driver.findElementById("password").sendKeys("test123")
    driver.findElementByClassName("btn-default").click()
    driver.findElementByClassName("glyphicon-warning-sign").click()
    driver.findElementByClassName("programming").click()
    Thread.sleep(2000)
    driver.kill()
  }

}