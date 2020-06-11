package net.test2

import java.util.concurrent.TimeUnit
import org.openqa.selenium.{By, WebDriver}
import org.openqa.selenium.firefox.FirefoxDriver

/**
 * Created by 1 on 25.08.2015.
 */

object Main extends App {
  val ff: WebDriver = new FirefoxDriver()
  ff.navigate().to("http://www.google.ru")
  val element1  = ff.findElement(By.id("lst-ib"))
  element1.sendKeys("casebook.ru")
  element1.submit()
  ff.manage().timeouts().implicitlyWait(2, TimeUnit SECONDS)
  try {
    val element2 = ff.findElement(By.xpath("//a[text()='casebook.ru']"))
    val a = element2.getText().equals("casebook.ru")
    println("First result is equals to request")
  } catch {
    case e: org.openqa.selenium.NoSuchElementException =>
      (e, println("Element does not exist"))
  } finally{
    ff.close()
  }
}