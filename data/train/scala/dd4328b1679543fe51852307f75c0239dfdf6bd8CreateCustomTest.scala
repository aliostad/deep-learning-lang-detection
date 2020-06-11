import java.util.concurrent.TimeUnit
import org.openqa.selenium.By
import org.openqa.selenium.interactions.Actions
import org.openqa.selenium.support.ui.ExpectedConditions
import org.scalatest.FlatSpec
import org.openqa.selenium.support.ui.Select

class CreateCustomTest extends FlatSpec with TestSetUp {

  "A user" should "visit on Flipkart.com " in {

    driver.manage().window().maximize()
    driver.get(BASE_URL)
    val title = driver.getTitle()
    val page_source = driver.getPageSource().length
    if (driver.getCurrentUrl == BASE_URL) {
      println("WELCOME TO Flipkart.com  with title : " + title)
      println("the length of the pagesource is: " + page_source)
    } else {
      println("something went wrong")
    }
  }

  "user" should "logged in " in {

    driver.manage().window().maximize()
    driver.get(BASE_URL)
    driver.findElementByCssSelector("div.AsXM8z li:nth-child(9) a._2k0gmP").click()
    driver.findElementByCssSelector("div.Km0IJL div div:nth-child(1) input:nth-child(1)").sendKeys(EMAIl)
    driver.findElementByCssSelector("div.Km0IJL div div:nth-child(2) input._2zrpKA._3v41xv").sendKeys(password)
    driver.findElementByCssSelector("div._1avdGP button:nth-child(1)").click()

    driver.manage().timeouts().implicitlyWait(10, TimeUnit.SECONDS)

    val your_orders = driver.findElementByCssSelector("a._1AHrFc._2k0gmP")

    val mouseHover = new Actions(driver)
    mouseHover.moveToElement(your_orders)
    mouseHover.build().perform()

    webdriverwait.until(ExpectedConditions.visibilityOfElementLocated(By.cssSelector("ul._1u5ANM li:nth-child(2) a._2k0gmP")))
    driver.findElementByCssSelector("ul._1u5ANM li:nth-child(2) a._2k0gmP").click()
    //.sleep(5000)
    driver.manage().timeouts().implicitlyWait(30, TimeUnit.SECONDS)

    driver.close()
  }

  //  "user" should "select a category from the list" in{
  //
  //    driver.manage().window().maximize()
  //    driver.get(BASE_URL)
  //    val dropDown = new Select(driver.findElementByCssSelector("#navbar #nav-belt .nav-fill #nav-search .nav-searchbar .nav-left .nav-search-scope.nav-sprite #searchDropdownBox"))
  //    dropDown.selectByVisibleText("Clothing & Accessories")
  //    driver.close()
  //  }
}
