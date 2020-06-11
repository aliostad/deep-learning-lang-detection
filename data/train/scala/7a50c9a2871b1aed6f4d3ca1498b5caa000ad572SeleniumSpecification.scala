package com.uzabase.phosphorus

import org.specs2._
import org.openqa.selenium.firefox.FirefoxDriver
import org.specs2.specification._
import org.junit.runner.RunWith
import org.specs2.runner.JUnitRunner
import org.openqa.selenium.chrome.ChromeDriver
import org.openqa.selenium.support.ui.WebDriverWait
import java.util.concurrent.TimeUnit
import org.specs2.specification.AfterAll

@RunWith(classOf[JUnitRunner])
abstract class SeleniumSpecification extends Specification with CoreMatchers with HasDriverWait with BeforeAll with AfterAll{
	
	implicit lazy val driver = DriverFactory().create

	def cleanUp = driver.quit

	def title = driver.getTitle
	
	def createWait(secounds:Int=10) = new WebDriverWait(driver,secounds)

  def beforeAll() = {
    driver.manage().window().maximize()
    driver.get(Config().applicationUrl);
    driver.manage.timeouts.implicitlyWait(Config().waitTime, TimeUnit.SECONDS);
  }
  
  def afterAll() = {
    try {
      driver.quit
    }catch {
      case t: Throwable => println(t)
    }
  }
}