//package selenium
//
//import java.util.concurrent.TimeUnit
//
//import org.openqa.selenium.firefox.FirefoxDriver
//import org.scalatest.FlatSpec
//
///**
//  * Created by kunal on 11/3/16.
//  */
//class Login extends FlatSpec{
//
//  val baseUrl ="http://localhost:9000/home"
//
//  "User" should "not be able to login" in {
//    val driver = new FirefoxDriver()
//    driver.get(baseUrl)
//    driver.manage().timeouts().implicitlyWait(2, TimeUnit.SECONDS)
//    driver.findElementById("email").sendKeys("rishabh@gmail.com")
//    driver.findElementById("password").sendKeys("199992")
//    driver.findElementByClassName("btn-default").click()
//    driver.findElementByCssSelector("BODY").getText.contains("invalid")
//    Thread.sleep(2000)
//  }
//  "User" should "successfully hit Awards" in {
//    val driver = new FirefoxDriver()
//    driver.get(baseUrl)
//    driver.manage().timeouts().implicitlyWait(2, TimeUnit.SECONDS)
//    driver.findElementById("email").sendKeys("rishabh@gmail.com")
//    driver.findElementById("password").sendKeys("1992")
//    driver.findElementByClassName("btn-default").click()
//    driver.findElementByCssSelector("BODY").getText.contains("AWARDS")
//    driver.findElementById("awards").click()
//    Thread.sleep(2000)
//  }
//
//  "User" should "successfully hit programming" in {
//    val driver = new FirefoxDriver()
//    driver.get(baseUrl)
//    driver.manage().timeouts().implicitlyWait(2, TimeUnit.SECONDS)
//    driver.findElementById("email").sendKeys("rishabh@gmail.com")
//    driver.findElementById("password").sendKeys("1992")
//    driver.findElementByClassName("btn-default").click()
//    driver.findElementByCssSelector("BODY").getText.contains("PROGRAMMING")
//    driver.findElementById("prog").click()
//    Thread.sleep(2000)
//  }
//  "User" should "successfully language" in {
//    val driver = new FirefoxDriver()
//    driver.get(baseUrl)
//    driver.manage().timeouts().implicitlyWait(2, TimeUnit.SECONDS)
//    driver.findElementById("email").sendKeys("rishabh@gmail.com")
//    driver.findElementById("password").sendKeys("1992")
//    driver.findElementByClassName("btn-default").click()
//    driver.findElementByCssSelector("BODY").getText.contains("LANGUAGE")
//    driver.findElementById("lang").click()
//    Thread.sleep(2000)
//  }
//  "User" should "successfully assignment" in {
//    val driver = new FirefoxDriver()
//    driver.get(baseUrl)
//    driver.manage().timeouts().implicitlyWait(2, TimeUnit.SECONDS)
//    driver.findElementById("email").sendKeys("rishabh@gmail.com")
//    driver.findElementById("password").sendKeys("1992")
//    driver.findElementByClassName("btn-default").click()
//    driver.findElementByCssSelector("BODY").getText.contains("ASSIGNMENT")
//    driver.findElementById("assign").click()
//    Thread.sleep(2000)
//  }
//  "User" should "successfully logout" in {
//    val driver = new FirefoxDriver()
//    driver.get(baseUrl)
//    driver.manage().timeouts().implicitlyWait(2, TimeUnit.SECONDS)
//    driver.findElementById("email").sendKeys("rishabh@gmail.com")
//    driver.findElementById("password").sendKeys("1992")
//    driver.findElementByClassName("btn-default").click()
//    driver.findElementById("log").click()
//    Thread.sleep(2000)
//  }
//
//
//}
