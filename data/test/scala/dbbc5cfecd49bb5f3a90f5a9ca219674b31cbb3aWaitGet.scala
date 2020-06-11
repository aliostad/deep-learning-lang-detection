package com.gu.automation.support.page

import java.util.concurrent.TimeUnit

import org.openqa.selenium.WebDriver

/**
 *
 * Waits for the presence of an element for other than the default time, useful if something is likely to be slow to
 * appear, or if something should be there already and you just want to check the presence.
 */
object WaitGet {

  val ImplicitWait = 2

  def apply[A](locator: => A, timeOutInSeconds: Int = 30)(implicit driver: WebDriver): A = {
    driver.manage().timeouts().implicitlyWait(timeOutInSeconds, TimeUnit.SECONDS)
    val actual = locator
    driver.manage().timeouts().implicitlyWait(WaitGet.ImplicitWait, TimeUnit.SECONDS)
    actual
  }
}