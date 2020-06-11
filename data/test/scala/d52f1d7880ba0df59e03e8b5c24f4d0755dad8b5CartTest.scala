import java.util.concurrent.TimeUnit

import org.openqa.selenium.By
import org.openqa.selenium.support.ui.ExpectedConditions
import org.scalatest.FlatSpec

class CartTest extends FlatSpec with TestSetup {

  "A user" should "visit flipkart.com" in {

    driver.manage.window.maximize()
    driver.get(Base_URL)
    val title = driver.getTitle
    val pageSource = driver.getPageSource
    if (driver.getCurrentUrl == Base_URL) {
      println(s"Title: $title")
      println(s"Length of Page Source: ${pageSource.length}")
      println("first test case passed")
    }
    else {
      println(s"Connection URL:${driver.getCurrentUrl} and Base URL: $Base_URL")
      println("Error in testing")
    }

  }

  "A user" should "log in to flipkart.com " in {

    /*driver.manage.window.maximize()
    driver.get(Base_URL)*/
    driver.findElementByCssSelector("#container > div > header > div._1tz-RS > div._1H5F__ > div > ul > li:nth-child(9) > a").click()
    driver.findElementByCssSelector("body > div.mCRfo9 > div > div > div > div > div.Km0IJL.col.col-3-5 > div > form > div:nth-child(1) > input").sendKeys(Email)
    driver.findElementByCssSelector("body > div.mCRfo9 > div > div > div > div > div.Km0IJL.col.col-3-5 > div > form > div:nth-child(2) > input").sendKeys(Password)
    driver.findElementByCssSelector("body > div.mCRfo9 > div > div > div > div > div.Km0IJL.col.col-3-5 > div > form > div._1avdGP > button").click()
    driver.manage.timeouts.implicitlyWait(10, TimeUnit.SECONDS)

  }

  "A user" should "select Electronics and then add vike k5 to cart" in {

    driver.manage.window.maximize()
    driver.get(Base_URL)
    driver.findElement(By.cssSelector("div._3Ed3Ub ul._114Zhd li.Wbt_B2:nth-child(1) a")).click()
    webDriverWait.until(ExpectedConditions.visibilityOfElementLocated(By.cssSelector("ul._3GtRpC")))
    driver.findElement(By.cssSelector("div._3Ed3Ub ul li ul li ul li ul li:nth-child(4) a")).click()
    driver.manage().timeouts().implicitlyWait(10, TimeUnit.SECONDS)
    driver.findElementByCssSelector("#fk-mainbody-id > div > div:nth-child(3) > div:nth-child(2) > div > div > div > div > a").click()
    driver.findElementByCssSelector("#container > div > div._3Q31_D > div._1XdvSH._17zsTh > div > div._2xw3j- > div:nth-child(3) > div > div:nth-child(1) > a").click()
    driver.findElementByCssSelector("#container > div > div:nth-child(3) > div > div > div._1GRhLX._3N5d1n > div > div._2fCBwf._3S6yHr > div > div > div._1oaFsP._3YvPug > ul > li:nth-child(1) > button").click()
    driver.findElementByCssSelector("#container > div > header > div._1tz-RS > div.Y5-ZPI > div > div > a").click()
    driver.findElementByCssSelector("div._1QdAN_ a").click()
    driver.manage().timeouts().implicitlyWait(50, TimeUnit.SECONDS)

  }

  /*"A user" should "remove k5 vibe from cart" in {

    driver.manage.window.maximize()
    driver.get(Base_URL)
    driver.findElementByCssSelector("a._3NFO0d").click()
    driver.findElementByCssSelector("div._2xVwyr:nth-child(2) span span").click()

  }
*/
  "A user" should " add another element to cart " in {

    driver.manage.window.maximize()
    driver.get(Base_URL)
    driver.findElement(By.cssSelector("div._3Ed3Ub ul._114Zhd li.Wbt_B2:nth-child(1) a")).click()
    webDriverWait.until(ExpectedConditions.visibilityOfElementLocated(By.cssSelector("ul._3GtRpC")))
    driver.findElement(By.cssSelector("div._3Ed3Ub ul li ul li ul li ul li:nth-child(4) a")).click()
    driver.manage().timeouts().implicitlyWait(10, TimeUnit.SECONDS)
    driver.findElementByCssSelector("#fk-mainbody-id > div > div:nth-child(3) > div:nth-child(1) > div > div > ul > li:nth-child(2) > a").click()
    driver.findElementByCssSelector("#fk-mainbody-id > div > div:nth-child(3) > div:nth-child(2) > div > div > div > div > div > div > a").click()
    driver.findElementByCssSelector("#container > div > div._3Q31_D > div._1XdvSH._17zsTh > div > div._2xw3j- > div:nth-child(3) > div > div:nth-child(1) > a").click()
    driver.findElementByCssSelector("#container > div > div:nth-child(3) > div > div > div._1GRhLX._3N5d1n > div > div._2fCBwf._3S6yHr > div > div > div._1oaFsP._3YvPug > ul > li:nth-child(1) > button").click()
    driver.findElementByCssSelector("#container > div > header > div._1tz-RS > div.Y5-ZPI > div > div > a").click()
    driver.findElementByCssSelector("div._1QdAN_ a").click()
    driver.manage().timeouts().implicitlyWait(50, TimeUnit.SECONDS)

  }

  "A user" should "checkout items from cart" in {

    driver.manage.window.maximize()
    driver.get(Base_URL)
    driver.findElementByCssSelector("#container > div > header > div._1tz-RS > div.Y5-ZPI > div > div > a").click()
    driver.findElementByCssSelector("#container > div > div._4dkTmQ > div > div.TFpAof > div._2qUgWb.HAZdhB > div > div > form > button").click()
    driver.findElementByCssSelector("#ng-app > div > div.co-body > ul > li:nth-child(2) > div > div.panel-body.collapse.in > div.select-address > div.add-address > a").click()
    driver.findElementByCssSelector("#name").sendKeys(Name)
    driver.findElementByCssSelector("#pincode").sendKeys(Pincode)
    driver.findElementByCssSelector("#address").sendKeys(Address)
    driver.findElementByCssSelector("#city").sendKeys(City)
    driver.findElementByCssSelector("#state > option:nth-child(11)").click()
    driver.findElementByCssSelector("#phone").sendKeys(Phone)
    driver.findElementByCssSelector("#createAddress > div > div > table > tbody > tr:nth-child(9) > td.tpadding15 > input").click()
    webDriverWait.until(ExpectedConditions.visibilityOfElementLocated(By.cssSelector("#order_summary_panel > div.panel-body.collapse.in")))
    driver.findElementByCssSelector("#order_summary_panel > div.panel-body.collapse.in > div.tpadding10.os-footer > form > div.nav-bar.ng-isolate-scope > div > div.pure-u-1-3 > a").click()
    driver.findElementByCssSelector("body > div.co-header > div > div > div:nth-child(1) > a").click()

  }

  "A user" should "close window " in {

    driver.close()

  }

}
