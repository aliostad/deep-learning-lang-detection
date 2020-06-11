package com.nthalk.SeleniumJQuery
import org.openqa.selenium.remote.RemoteWebDriver
import org.openqa.selenium.WebDriver
import org.openqa.selenium.By

class jQueryBrowser(val drv: RemoteWebDriver) extends jQueryFactory(drv) with WebDriver {
  def get(str: String) = drv.get(str)
  def getCurrentUrl = drv.getCurrentUrl()
  def getTitle = drv.getTitle()
  def findElements(by: By) = drv.findElements(by)
  def findElement(by: By) = drv.findElement(by)
  def getPageSource = drv.getPageSource
  def close = drv.close
  def quit = drv.quit
  def getWindowHandles = drv.getWindowHandles
  def getWindowHandle = drv.getWindowHandle
  def switchTo = drv.switchTo
  def navigate = drv.navigate
  def manage = drv.manage
}