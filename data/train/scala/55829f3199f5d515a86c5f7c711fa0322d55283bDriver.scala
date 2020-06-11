/*
 * Copyright (C) 2017  Department for Business, Energy and Industrial Strategy
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

package driver

import java.util.concurrent.TimeUnit

import org.openqa.selenium.remote.DesiredCapabilities
import org.openqa.selenium.{Dimension, WebDriver}
import org.scalactic.TripleEquals._
import org.scalatest.selenium.{Chrome, Firefox, HtmlUnit}

import scala.util.Try

object Driver extends Driver

class Driver {

  val systemProperties = System.getProperties

  val implicitWait = 200

  private def withWaitTime[T](time: Long)(body: => T) = {
    webDriver.manage().timeouts().implicitlyWait(time, TimeUnit.MILLISECONDS)
    val t: T = body
    webDriver.manage().timeouts().implicitlyWait(implicitWait, TimeUnit.MILLISECONDS)
    t
  }

  def withoutDelay[T](body: => T) = withWaitTime(0)(body)

  val webDriver: WebDriver = {

    var selectedDriver: WebDriver = null

    sys addShutdownHook {
      Try(webDriver.quit())
    }

    def phantomjsDriver() = {
      val cap = new DesiredCapabilities()
      cap.setJavascriptEnabled(true)
      selectedDriver = PhantomJSDriverObject(cap)
      selectedDriver.manage().window().maximize()
    }

    def isEmpty(s: String) = s === null || s.trim === ""

    if (!isEmpty(systemProperties.getProperty("browser"))) {
      val targetBrowser = systemProperties.getProperty("browser")
      if (targetBrowser.equalsIgnoreCase("firefox")) {
        Firefox.firefoxProfile.setAcceptUntrustedCertificates(true)
        selectedDriver = Firefox.webDriver
      } else if (targetBrowser.equalsIgnoreCase("phone_mock")) {
        val d = new Dimension(320, 480)
        selectedDriver = Firefox.webDriver
        selectedDriver.manage().window().setSize(d)
      } else if (targetBrowser.equalsIgnoreCase("tablet_mock")) {
        val d = new Dimension(768, 1024)
        selectedDriver = Firefox.webDriver
        selectedDriver.manage().window().setSize(d)
      } else if (targetBrowser.equalsIgnoreCase("htmlunit")) {
        selectedDriver = HtmlUnit.webDriver
      } else if (targetBrowser.equalsIgnoreCase("chrome")) {
        val cap = new DesiredCapabilities()
        cap.setJavascriptEnabled(true)
        selectedDriver.manage().window().maximize()
        selectedDriver = Chrome.webDriver
      } else if (targetBrowser.equalsIgnoreCase("phantomjs")) {
        phantomjsDriver()
      }
    }

    if (selectedDriver == null) {
      phantomjsDriver()
    }

    selectedDriver.manage().timeouts().implicitlyWait(implicitWait, TimeUnit.MILLISECONDS)
    selectedDriver
  }
}
