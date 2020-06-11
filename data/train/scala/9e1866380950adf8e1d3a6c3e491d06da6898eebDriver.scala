package utils

import java.util.concurrent.TimeUnit

import org.openqa.selenium.{By, WebDriver, WebElement}
import org.openqa.selenium.chrome.ChromeDriver
import org.openqa.selenium.support.ui.{ExpectedConditions, FluentWait, Wait}
import org.scalatest.selenium.WebBrowser
import org.scalatest.{BeforeAndAfterAll, FunSpec}

class Driver extends FunSpec with BeforeAndAfterAll with WebBrowser{
  implicit val driver = new ChromeDriver()
  driver.manage().window().maximize()
  driver.manage().timeouts().implicitlyWait(5,TimeUnit.SECONDS)

  override def afterAll(): Unit = driver.close()

  var fluentWait: Wait[WebDriver] = new FluentWait[WebDriver](driver)
    .withTimeout(35, TimeUnit.SECONDS)
    .pollingEvery(1, TimeUnit.SECONDS)


  def waitAndGet(locator: By): WebElement = fluentWait.until(ExpectedConditions.visibilityOf(driver.findElement(locator)))

}
