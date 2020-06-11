package utils

import org.scalatest.selenium.{HtmlUnit, WebBrowser}
import org.scalatest._


/**
  * Created by Stephen.Kam on 11/08/2016.
  */
trait Support extends FeatureSpec with GivenWhenThen with BeforeAndAfterAll with BeforeAndAfterEach with WebBrowser with Pagefactory {

  /*
  THIS PAGE GROUPS ALL OF THE TRAITS TOGETHER AND SETS THE BEFORE AND AFTER SCENARIOS
   */
  override def beforeAll(): Unit = { driver.manage().window().maximize() }

  override def beforeEach(): Unit = { homepage.navigateToWebPage(driver) }

  override def afterAll() = { quit() }

}
