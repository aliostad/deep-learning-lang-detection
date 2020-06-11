package base

import java.util.concurrent.TimeUnit

import org.openqa.selenium.Dimension
import org.openqa.selenium.firefox.FirefoxDriver
import org.scalatest.mock.MockitoSugar
import org.scalatest._

trait FeatureSpecBase extends FeatureSpecLike with Matchers
    with GivenWhenThen with MockitoSugar {

  lazy val driver = {
    val d = new FirefoxDriver()
    d.manage().timeouts().pageLoadTimeout(20, TimeUnit.SECONDS)
    d.manage().timeouts().implicitlyWait(20, TimeUnit.SECONDS)
    d.manage().window().setSize(new Dimension(1200, 1024))
    d
  }
  protected def noWait(block: ⇒ Unit) = {
    driver.manage().timeouts().implicitlyWait(0, TimeUnit.SECONDS)
    try {
      block
    } catch {
      case e: org.openqa.selenium.NoSuchElementException ⇒ // ignore
    } finally {
      driver.manage().timeouts().implicitlyWait(20, TimeUnit.SECONDS)
    }
  }
}
