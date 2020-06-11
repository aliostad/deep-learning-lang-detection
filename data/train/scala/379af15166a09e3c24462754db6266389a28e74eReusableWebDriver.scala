package uk.org.lidalia
package webdriver

import org.openqa.selenium.{By, WebDriver}
import uk.org.lidalia.net.Host.localhost
import uk.org.lidalia.net.Scheme.http
import uk.org.lidalia.net.Port
import uk.org.lidalia.net.Url
import uk.org.lidalia.scalalang.Reusable

object ReusableWebDriver {
  def apply(delegate: WebDriver) = new ReusableWebDriver(delegate)
}

class ReusableWebDriver private (delegate: WebDriver) extends Reusable {

  def getPageSource = delegate.getPageSource

  def findElements(by: By) = delegate.findElements(by)

  def getWindowHandle = delegate.getWindowHandle

  def get(url: String) = delegate.get(url)

  def manage() = delegate.manage()

  def getWindowHandles = delegate.getWindowHandles

  def switchTo() = delegate.switchTo()

  def getCurrentUrl = delegate.getCurrentUrl

  def navigate() = delegate.navigate()

  def findElement(by: By) = delegate.findElement(by)

  def getTitle = delegate.getTitle

  override def reset() = manage().deleteAllCookies()
}

object WebDriverWithBaseUrl {

  def apply(webDriver: ReusableWebDriver, baseUrl: Url): WebDriverWithBaseUrl = new WebDriverWithBaseUrl(webDriver, baseUrl)

  def apply(webDriver: ReusableWebDriver, port: Port): WebDriverWithBaseUrl = apply(webDriver, http `://` localhost.withPort(port))
}

class WebDriverWithBaseUrl private (reusableWebDriver: ReusableWebDriver, baseUrl: Url) {
  def at[P <: Page[P]](pageFactory: PageFactory[P]): P = {
    def page = pageFactory(reusableWebDriver)
    assert(page.isCurrentPage, s"Expected to be at $page")
    page
  }

  def to[P <: Page[P]](pageFactory: PageFactory[P]): P = {
    reusableWebDriver.get(baseUrl.resolve(pageFactory.url).toString)
    at(pageFactory)
  }
}
