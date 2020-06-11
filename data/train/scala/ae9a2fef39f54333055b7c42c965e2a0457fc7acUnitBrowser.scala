package com.yukimt.scrape
package browser

import collection.JavaConversions._
import scala.concurrent.duration._
import org.openqa.selenium.Cookie

trait UnitBrowserLike extends Browser[UnitBrowser] {

  protected val driver = new FixedHtmlUnitDriver

  /************Set up***********/
  customHeaders.foreach{
    case (key, value) =>
      driver.setHeader(key, value)
  }
  driver.setHeader("User-Agent", userAgent.toString)
  basicAuth.foreach(b => driver.setHeader(b.key, b.encode))
  driver.get(url)

  /************Cookie***********/
  override def addCookie(key: String, value: String) = {
    driver.manage.addCookie(new Cookie(key, value))
    this
  }
  override def removeCookie(key: String) = {
    val c = driver.manage.getCookieNamed("key")
    driver.manage.deleteCookie(c)
    this
  }
  override def clearCookie = {
    driver.manage.deleteAllCookies
    this
  }
  override def cookies:Map[String, String] = {
    driver.manage.getCookies.map(c => c.getName -> c.getValue).toMap
  }
  override def cookie(key: String): Option[String] = {
    Option(driver.manage.getCookieNamed(key)).map(_.getValue)
  }

  def setJsEnabled(flg: Boolean): UnitBrowser = {
    driver.setJavascriptEnabled(flg)
    this
  }
  /************Response Header***********/
  def responseHeaders = driver.headers
  def statusCode = driver.statusCode
}

class UnitBrowser(
  val url: String,
  val userAgent: UserAgent = new UserAgent(Device.Mac, BrowserType.Chrome),
  val basicAuth: Option[BasicAuth] = None,
  val customHeaders: Map[String, String] = Map.empty)
  extends UnitBrowserLike with WindowManager[UnitBrowserLike, UnitBrowser]
