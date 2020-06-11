import org.specs2.mutable._
import org.specs2.runner._
import org.junit.runner._
import org.junit._


import java.util.concurrent.TimeUnit;

import org.openqa.selenium.WebDriver;
import org.openqa.selenium.firefox.FirefoxDriver;

import play.api.test._
import play.api.test.Helpers._
import play.api.Play

@RunWith(classOf[JUnitRunner])
class AppTest extends Specification with BeforeAfter {

  "Application" should {

    "capture test" in {
		DevCiUtils.deleteCapture();
		val se=new Senario();
		se.test(baseUrl,driver)
		true
    }
  }
    
  var driver:WebDriver=null
  val baseUrl="http://localhost:9000/"
    
  def before={
 	driver = new FirefoxDriver();
	driver.manage().timeouts().implicitlyWait(10, TimeUnit.SECONDS);   
  }
  
  def after={
 	driver.quit(); 
  }

}
