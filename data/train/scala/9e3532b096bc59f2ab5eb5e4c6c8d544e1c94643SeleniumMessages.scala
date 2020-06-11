import org.openqa.selenium.{Dimension, WebElement}
import org.openqa.selenium.interactions.Actions
import org.scalajs.jsenv.selenium.AbstractSeleniumJSRunner

trait SeleniumMessages {
  self: AbstractSeleniumJSRunner =>
  def handleMessage(msg: Seq[_]): Unit = {
    val webDriver = browser.getWebDriver
    msg match {
      case Seq("click", ele: WebElement, pos) => ele.click()
      case Seq("clickAt", ele: WebElement, x: Long, y: Long, pos) =>
        val actions = new Actions(webDriver)
        actions.moveToElement(ele, x.toInt, y.toInt).click().perform()
      case Seq("resizeBrowserWindow", width: Long, height: Long, pos) =>
        webDriver.manage().window().setSize(new Dimension(width.toInt, height.toInt))
    }
  }
}