package com.github.dnvriend.selenium

import java.util.concurrent.TimeUnit

import org.openqa.selenium.firefox.FirefoxDriver
import org.scalatest.FlatSpec
import play.api.test.FakeApplication
import play.api.test.Helpers.inMemoryDatabase
import play.api.test.Helpers.running
import play.api.test.TestServer
import play.api.test.Helpers.HTMLUNIT

class RebookingTest extends FlatSpec {

  running(TestServer(9001, FakeApplication(additionalConfiguration = inMemoryDatabase())), HTMLUNIT) { browser =>


    val driver = new FirefoxDriver()
    driver.manage().window().maximize()

    "Application" should "login,search using first name,last name,phone number,email" in {
      driver.get("http://52.40.107.142:9001/login")
      driver.findElementByName("userName").sendKeys("gaurav_knoldus")
      driver.findElementByName("password").sendKeys("gaurav")
      driver.findElementByCssSelector(".btn.btn-primary.login-button").click()
      driver.get("http://52.40.107.142:9001/search")
      driver.findElementById("firstName").sendKeys("gaurav")
      driver.findElementById("submit").click()
      driver.manage().timeouts().implicitlyWait(60, TimeUnit.SECONDS)
      driver.findElementByCssSelector("BODY").getText().contains("TRIP SEARCH RESULTS")
      driver.findElementByPartialLinkText("QUICK LOOK").click()
      driver.findElementByPartialLinkText("Know More...").click()
      driver.manage().timeouts().implicitlyWait(60, TimeUnit.SECONDS)
      driver.findElementByPartialLinkText("Itinerary").click()
      driver.findElementByPartialLinkText("Send Rebooking").click()
      driver.findElementByCssSelector("BODY").getText().contains("Are you sure?")


     /* driver.findElementByXPath("/html/body/section/div[1]/div[2]/div[1]/a").click()
      driver.findElementById("lastName").sendKeys("shukla")
      driver.findElementById("submit").click()
      driver.manage().timeouts().implicitlyWait(60, TimeUnit.SECONDS)
      driver.findElementByCssSelector("BODY").getText().contains("TRIP SEARCH RESULTS")
      driver.findElementByXPath("/html/body/section/div[1]/div[2]/div[1]/a").click()
      driver.findElementById("phone").sendKeys("+918505847053")
      driver.manage().timeouts().implicitlyWait(60, TimeUnit.SECONDS)
      driver.findElementById("submit").click()
      driver.manage().timeouts().implicitlyWait(60, TimeUnit.SECONDS)
      driver.findElementByCssSelector("BODY").getText().contains("TRIP SEARCH RESULTS")
      driver.findElementByXPath("/html/body/section/div[1]/div[2]/div[1]/a").click()
      driver.findElementById("email").sendKeys("gaurav@knoldus.com")
      driver.manage().timeouts().implicitlyWait(60, TimeUnit.SECONDS)
      driver.findElementById("submit").click()
      driver.manage().timeouts().implicitlyWait(60, TimeUnit.SECONDS)
      driver.findElementByCssSelector("BODY").getText().contains("TRIP SEARCH RESULTS")
      driver.findElementByLinkText("quick-look0").click()*/


      driver.close()
    }

    }
  }
