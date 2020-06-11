package selenium

import java.util.concurrent.TimeUnit
import org.openqa.selenium.By
import org.openqa.selenium.interactions.Actions
import org.openqa.selenium.support.ui.ExpectedConditions
import org.scalatest.FlatSpec
import org.openqa.selenium.support.ui.Select

class CreateTestSuit extends FlatSpec with TestSetup{

  /**
    * for a successful automation there should be at least two mailing address
    */
  "A user" should "visit on flipcart.com" in {

    driver.manage().window().maximize()
    driver.get(BASE_URL)


  }

  "user" should "unable to logged in  with wrongcredentials " in {

    driver.manage().window().maximize()
    driver.get(BASE_URL)
    driver.findElementByCssSelector("ul._3Ji-EC > li:nth-child(9)").click()
    //driver.findElementByCssSelector("._1tz-RS .AsXM8z ._3Ji-EC ._2sYLhZ ._2k0gmp").click()

    driver.findElementByCssSelector("._39M2dM ._2zrpKA").sendKeys(INVALIDEMAIL)
    driver.findElementByCssSelector("._39M2dM ._2zrpKA._3v41xv").sendKeys(INVALIDPASSWORD)
    driver.findElementByCssSelector("._1avdGP ._2AkmmA._1LctnI._7UHT_c").click()
//    driver.findElementByCssSelector("._39M2dM ._2zrpKA").clear()
//    driver.findElementByCssSelector("._39M2dM ._2zrpKA._3v41xv").clear()


    driver.manage().timeouts().implicitlyWait(15, TimeUnit.SECONDS)
    Thread.sleep(5000)

  }
  "user" should "able to logged in with valid credentials"in{
    driver.manage().window().maximize()
    driver.get(BASE_URL)
    driver.findElementByCssSelector("ul._3Ji-EC > li:nth-child(9)").click()
    //driver.findElementByCssSelector("._1tz-RS .AsXM8z ._3Ji-EC ._2sYLhZ ._2k0gmp").click()

    driver.findElementByCssSelector("._39M2dM ._2zrpKA").sendKeys(EMAIl)
    driver.findElementByCssSelector("._39M2dM ._2zrpKA._3v41xv").sendKeys(password)
    driver.findElementByCssSelector("._1avdGP ._2AkmmA._1LctnI._7UHT_c").click()
    driver.manage().timeouts().implicitlyWait(15, TimeUnit.SECONDS)
    Thread.sleep(5000)

  }
  "user" should "able to add elements to cart" in{
    driver.manage().window().maximize()
    driver.get(BASE_URL)
    driver.findElementByCssSelector(".O8ZS_U .LM6RPg").sendKeys(firstelement)
    driver.findElementByCssSelector(".col-1-12 .vh79eN").click()
    driver.findElementByCssSelector("._3BTv9X ._1Nyybr._30XEf0").click()
    driver.findElementByCssSelector("ul.row > li:nth-child(1)").click()
    /**
      * second element to the cart
      */
    driver.findElementByCssSelector(".O8ZS_U .LM6RPg").sendKeys(secondelement)
    driver.findElementByCssSelector(".col-1-12 .vh79eN").click()
    driver.findElementByCssSelector("._3BTv9X ._1Nyybr._30XEf0").click()
    driver.findElementByCssSelector("ul.row > li:nth-child(1)").click()
    //webdriverwait.until(ExpectedConditions.visibilityOfAllElementsLocatedBy(By.cssSelector("._3NFO0d")))
    //driver.findElement(By.cssSelector("._3NFO0d")).click()

    driver.manage().timeouts().implicitlyWait(15, TimeUnit.SECONDS)
    Thread.sleep(5000)


  }
  "user" should "able to add a mailing add" in{
    driver.manage().window().maximize()
    driver.get(BASE_URL)
    driver.findElement(By.cssSelector("._3NFO0d")).click()
    driver.findElementByCssSelector("button._2AkmmA._3qVHVC._7UHT_c").click()
    //driver.findElementByCssSelector("div.pure-u-1-5 span.btn.btn-white.tmargin5.right_btn.lmargin20:contains('Change Address')").click()
    driver.findElementByCssSelector("span.add_address_btn.btn.btn-white-yellow").click()
    driver.findElementById("name").sendKeys(name)
    driver.findElementById("pincode").sendKeys(pincode)
    driver.findElementById("address").sendKeys(add)
    driver.findElementById("phone").sendKeys(phone)
    driver.findElementByCssSelector("td.tpadding15 input.btn.btn-large.btn-orange.address_submit").click()

    driver.manage().timeouts().implicitlyWait(15, TimeUnit.SECONDS)
    Thread.sleep(5000)
    driver.close()
  }

}
