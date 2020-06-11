package net.test2

import java.util.concurrent.TimeUnit
import org.openqa.selenium.{By, WebDriver}
import org.openqa.selenium.firefox.FirefoxDriver

/**
 * Created by 1 on 25.08.2015.
 */

object Goo extends App {
  val ff: WebDriver = new FirefoxDriver()
  ff.navigate().to("http://www.google.ru")
  val element1  = ff.findElement(By.id("lst-ib"))
  element1.sendKeys("casebook.ru")
  element1.submit()
  ff.manage().timeouts().implicitlyWait(2, TimeUnit SECONDS)
  val element2 = ff.findElements(By.className("g"))
  println(element2.size())
  if (element2.size() == 10)
  {
    println("Number of search results is 10")
  } else{
    println("Number of search results is NOT 10")
  }
  ff.close()
}