/*
 * Copyright (C) 2013-2015 by Michael Hombre Brinkmann
 */

package net.twibs.testutil

import org.openqa.selenium.{Dimension, Point}
import org.scalatest.BeforeAndAfterAll

trait TwibsSeleniumTest extends TwibsTest with SeleniumTestUtils with BeforeAndAfterAll {
  def windowPosition = new Point(20, 20)

  def windowDimension = new Dimension(1400, 768)

  override protected def beforeAll(): Unit = {
    SeleniumDriver.initWebDriver()
    driver.manage().window().setPosition(windowPosition)
    driver.manage().window().setSize(windowDimension)
  }

  override protected def afterAll(): Unit = SeleniumDriver.discardWebDriver()
}
