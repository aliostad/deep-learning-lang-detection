package com.gu.automation.support

import org.openqa.selenium.{Cookie, WebDriver}

object CookieManager {

  def getCookieDomain(url: String) =
    """http(s?)://([^.]*(\.))?([^/]+).*$""".r.replaceAllIn(url, "$3$4")

  def addCookies(cookies: Seq[(String, String)])(implicit driver: WebDriver) {
    val baseUrl = Config().getTestBaseUrl()
    val loginDomain = getCookieDomain(baseUrl)

    driver.get(baseUrl) // have to be on the right url to add the cookies

    cookies.foreach {

      case (key, value) =>
        val isSecure = key.startsWith("SC_")
        val cookie = new Cookie(key, value, loginDomain, "/", null, isSecure, isSecure)
        driver.manage().addCookie(cookie)
    }
  }

  def addCookie(cookieName: String, cookieValue: String)(implicit driver: WebDriver){
    addCookies(List((cookieName,cookieValue)))
  }

  def getCookie(cookieName: String)(implicit driver: WebDriver): Cookie = {
    driver.manage().getCookieNamed(cookieName)
  }

  def removeCookie(cookieName: String)(implicit driver: WebDriver) = {
    driver.manage().deleteCookieNamed(cookieName)
  }

}
