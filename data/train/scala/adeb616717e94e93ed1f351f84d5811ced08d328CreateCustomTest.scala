package knoldus

import org.openqa.selenium.By
import org.openqa.selenium.interactions.Actions
import org.openqa.selenium.support.ui.ExpectedConditions
import org.scalatest.FlatSpec

class CreateCustomTest extends FlatSpec with TestSetUp {

  "A user" should "visit on flipkart.com" in {

    driver.manage().window().maximize()
    driver.get(BASE_URL)
    val title = driver.getTitle()
    val page_source = driver.getPageSource().length
    if (driver.getCurrentUrl == BASE_URL) {
      println("WELCOME TO Flipkart in with title : " + title)
      println("the lenght of the pagesource is: " + page_source)
    } else {
      println("something went wrong")
    }
  }

  "user" should "logged in with Wrong credentials " in {
    driver.manage().window().maximize()
    driver.get(BASE_URL)
    driver.findElement(By.cssSelector("a[href*='login?ret']")).click()
    driver.findElement(By.cssSelector("._39M2dM input[type=text]")).sendKeys("aaa")
    driver.findElement(By.cssSelector("._39M2dM input[type=password]")).sendKeys("bbb")
    driver.findElement(By.cssSelector("._1avdGP button[type=submit]")).click()

  }

  "user" should "logged in with correct credentials " in {
    driver.manage().window().maximize()
    driver.get(BASE_URL)
    driver.findElement(By.cssSelector("a[href*='login?ret']")).click()
    driver.findElement(By.cssSelector("._39M2dM input[type=text]")).clear()
    driver.findElement(By.cssSelector("._39M2dM input[type=text]")).sendKeys(email)
    driver.findElement(By.cssSelector("._39M2dM input[type=password]")).clear()
    driver.findElement(By.cssSelector("._39M2dM input[type=password]")).sendKeys(password)
    driver.findElement(By.cssSelector("._1avdGP button[type=submit]")).click()

  }

  "user" should "select the Electronics category and buy apple phone" in{
    driver.manage().window().maximize()
    driver.get(BASE_URL)
    webdriverwait.until(ExpectedConditions.visibilityOfAllElementsLocatedBy(By.cssSelector("a._1QZ6fC")))
    val dropDown = driver.findElementByCssSelector("a._1QZ6fC")
    val mouseHover = new Actions(driver)
    mouseHover.moveToElement(dropDown)
    mouseHover.build().perform()
    webdriverwait.until(ExpectedConditions.visibilityOfAllElementsLocatedBy(By.cssSelector("li._1KCOnI a[title~=Apple]")))
    driver.findElement(By.cssSelector("li._1KCOnI a[title~=Apple]")).click()
    webdriverwait.until(ExpectedConditions.visibilityOfAllElementsLocatedBy(By.cssSelector("div._1OCn9C > div")))
    driver.findElement(By.cssSelector("div._1OCn9C > div")).click()
    webdriverwait.until(ExpectedConditions.visibilityOfAllElementsLocatedBy(By.cssSelector("._19RW-r")))
    driver.findElement(By.cssSelector("._19RW-r")).click()
  }

  "user" should "search for timex watch and add it to the cart" in{
    driver.manage().window().maximize()
    driver.get(BASE_URL)
    webdriverwait.until(ExpectedConditions.visibilityOfAllElementsLocatedBy(By.cssSelector("div.O8ZS_U")))
    val searchbar = driver.findElement(By.cssSelector(".O8ZS_U"))
    val focus = new Actions(driver)
    focus.moveToElement(searchbar)
    focus.click()
    focus.sendKeys("Timex watch")
    focus.build().perform()
    driver.findElementByClassName("vh79eN").click()
    webdriverwait.until(ExpectedConditions.visibilityOfAllElementsLocatedBy(By.cssSelector("div.MP_3W3 > div")))
    driver.findElement(By.cssSelector("div.MP_3W3 > div")).click()
    webdriverwait.until(ExpectedConditions.visibilityOfAllElementsLocatedBy(By.cssSelector("._19RW-r")))
    driver.findElement(By.cssSelector("._19RW-r")).click()
  }


  "user" should "checkout to cart by providing mailing address" in{
    driver.manage().window().maximize()
    driver.get(BASE_URL)
    webdriverwait.until(ExpectedConditions.visibilityOfAllElementsLocatedBy(By.cssSelector("._3NFO0d")))
    driver.findElement(By.cssSelector("._3NFO0d")).click()
    webdriverwait.until(ExpectedConditions.visibilityOfAllElementsLocatedBy(By.cssSelector("._7UHT_c")))
    driver.findElement(By.cssSelector("._7UHT_c")).click()
    webdriverwait.until(ExpectedConditions.visibilityOfAllElementsLocatedBy(By.cssSelector(".add_address_btn")))
    driver.findElement(By.cssSelector(".add_address_btn")).click()
    driver.findElementById("name").sendKeys("kunal sethi")
    driver.findElementById("pincode").sendKeys("125055")
    driver.findElementById("address").sendKeys("sec-15, Noida")
    driver.findElementById("phone").sendKeys("9876543210")

   // driver.close()
  }



}