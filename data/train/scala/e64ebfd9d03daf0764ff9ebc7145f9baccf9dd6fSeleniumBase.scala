package uk.gov.hmrc.integration.cucumber.utils

import java.util.concurrent.TimeUnit

import org.openqa.selenium._
import uk.gov.hmrc.integration.cucumber.utils.TearDown

trait SeleniumBase extends TearDown {

  driver.getInstance().manage.timeouts.implicitlyWait(6, TimeUnit.SECONDS)

  def elementDisplayed(by: By): Boolean = {
    try {
      driver.getInstance().findElement(by)
      true
    } catch {
      case e: NoSuchElementException => false
    }
  }

  def clickOn(selector: By) = driver.getInstance().findElement(selector).click()

  def textFrom(selector: By) = driver.getInstance().findElement(selector).getText

}
