package com.mblund.autoBrowser.tests

import org.scalatest.{BeforeAndAfterAll, FunSuite}
import org.openqa.selenium.htmlunit.HtmlUnitDriver

import org.openqa.selenium.{By, WebDriver}
import java.util.concurrent.TimeUnit

class CheckGoogleTest extends FunSuite with BeforeAndAfterAll {

  private var driver: WebDriver = new HtmlUnitDriver();

  override def beforeAll() {
    driver.manage().timeouts().implicitlyWait(10, TimeUnit.SECONDS);
  }

  override def afterAll() {
    driver.close()
  }

  test("Check google") {
    driver.get("http://www.google.se")
    expect("Google") {
      driver.getTitle
    }
  }
}