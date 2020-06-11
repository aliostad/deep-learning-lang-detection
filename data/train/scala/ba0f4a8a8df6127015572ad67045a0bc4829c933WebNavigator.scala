package it.jesinity

import java.util
import java.util.concurrent.TimeUnit

import org.openqa.selenium.WebElement
import org.openqa.selenium.firefox.FirefoxDriver

object WebNavigator {


  def main(args: Array[String]): Unit = {

    val driver = new FirefoxDriver()
    driver.manage().timeouts().implicitlyWait(30,TimeUnit.SECONDS)

    driver.get("http://www.repubblica.it/")
    val elements: util.List[WebElement] = driver.findElementsByCssSelector(".main-nav>ul>li>a")
    elements.get(2).click()

    val article = driver.findElementsByCssSelector("section.apertura-extra >article")

    val element: WebElement = article.get(0)

    println(element.getText)

    TimeUnit.SECONDS.sleep(10L)

    driver.quit()
  }

}
