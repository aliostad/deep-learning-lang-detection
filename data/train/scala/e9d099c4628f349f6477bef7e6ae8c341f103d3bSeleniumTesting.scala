import java.util.concurrent.TimeUnit

import com.knoldus.edu.Credential
import org.openqa.selenium.By
import org.openqa.selenium.interactions.Actions
import org.openqa.selenium.support.ui.{ExpectedConditions, Select}
import org.scalatest.FlatSpec

class SeleniumTesting extends FlatSpec with Credential{
  "A user" should "visit on flipkart.com" in {

    driver.manage().window().maximize()
    driver.get(BASE_URL)
    val title = driver.getTitle()
    val page_source = driver.getPageSource().length
    if (driver.getCurrentUrl == BASE_URL) {
      println("WELCOME TO Flipcart.com  with title : " + title)
      println("the length of the pagesource is: " + page_source)
    } else {
      println("something went wrong")
    }
  }

  "user" should "logged in " in {

    driver.manage().window().maximize()
    driver.get(BASE_URL)
   // driver.findElementsByCssSelector(".AsXM8z ul._3Ji-EC li._2sYLhZ:nth-child(9) a")
    driver.findElement(By.cssSelector("div.AsXM8z ul._3Ji-EC li._2sYLhZ:nth-child(9) a")).click()
    driver.findElementByCssSelector("._39M2dM:nth-child(1) input").sendKeys(EMAIl)
    driver.findElementByCssSelector("._39M2dM:nth-child(2) input").sendKeys(password)
    driver.findElementByCssSelector("._1avdGP button").click()
    driver.manage().timeouts().implicitlyWait(10, TimeUnit.SECONDS)

  }
  "user" should "search a product and buy it" in {

    driver.manage().window().maximize()
    driver.get(BASE_URL)
    driver.findElementByCssSelector(".O8ZS_U input").sendKeys("dslr")
    driver.findElement(By.cssSelector(".vh79eN")).click()
    driver.manage().timeouts().implicitlyWait(20, TimeUnit.SECONDS)
    driver.findElement(By.cssSelector("._3yI_5w:nth-child(2) div._3liAhj:nth-child(1) a")).click()
    driver.findElement(By.cssSelector("._2AkmmA")).click()
    driver.findElement(By.cssSelector("._2OJxl5 a")).click()

  }
  "user" should "place order" in{
    driver.manage().window().maximize()
    driver.get(BASE_URL)
    driver.findElement(By.cssSelector(".Y5-ZPI div.AsXM8z a._3NFO0d")).click()
    driver.findElement(By.cssSelector("._1QdAN_ button:nth-child(2)")).click()
    //driver.findElement(By.cssSelector(".co-body ul li.ng-scope:nth-child(2) div.co-panel div.panel-heading div.rposition a")).click()
  //  driver.findElement(By.cssSelector(".co-body ul.content li.ng-scope:nth-child(2) div.panel-body div.add-address a")).click()
     Thread.sleep(2000)
    driver.findElementById("name").sendKeys("jatin")
    driver.findElementById("pincode").sendKeys("110085")
    driver.findElementById("address").sendKeys("Any fake address")
    driver.findElementById("phone").sendKeys("9999999999")
    driver.findElement(By.cssSelector(".pure-g-r div.pure-u-2-3 table tbody tr:nth-child(9) td:nth-child(2) input")).click()
   // driver.findElement(By.cssSelector(".pure-g-r div.pure-u-1 table
    // tbody tr:nth-child(9) td:nth-child(2) input")).click()
   //   driver.findElementById("#os_emailId").sendKeys("fake@gmail.com")
   //   driver.findElement(By.cssSelector(".pure-u-1-2 a")).click()
    // driver.findElement(By.cssSelector(".div.ng-isolate-scope:nth-child(2) div.pure-u-1-3 a")).click()
    Thread.sleep(2000)
     driver.findElement(By.cssSelector(".pure-u-1-2 a")).click()


  }
  "user" should "logout" in{
    driver.manage().window().maximize()
    driver.get(BASE_URL)
    val logout=driver.findElement(By.cssSelector("._1AHrFc"))
    val mouseHover = new Actions(driver)
        mouseHover.moveToElement(logout)
    mouseHover.build().perform()
    Thread.sleep(2000)
    driver.findElement(By.cssSelector("._3Ji-EC li:nth-child(8) li:nth-child(10)")).click()
        Thread.sleep(5000)
    driver.close()
  }

}

