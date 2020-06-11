package utils

import org.scalatest.selenium.WebBrowser
import org.scalatest.{BeforeAndAfterEach, BeforeAndAfterAll, FeatureSpec, GivenWhenThen, Matchers}

trait BaseFeatureSpec extends FeatureSpec
    with GivenWhenThen
    with DriverInitialisation
    with Matchers
    with WebBrowser
    with BeforeAndAfterEach
    with BeforeAndAfterAll{
  override def beforeEach() = {
    driver.manage().deleteAllCookies()
    driver.manage().window().maximize()
  }

//  override def afterAll() = {
//    close()
//  }
}
