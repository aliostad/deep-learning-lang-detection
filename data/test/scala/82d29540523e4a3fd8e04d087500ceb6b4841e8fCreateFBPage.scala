package Page

/**
 * Created with IntelliJ IDEA.
 * User: ggupta
 * Date: 9/13/12
 * Time: 6:46 PM
 * To change this template use File | Settings | File Templates.
 */

import org.openqa.selenium.By
import org.openqa.selenium.firefox.{FirefoxDriver, FirefoxProfile}
import java.util.concurrent.TimeUnit
import org.openqa.selenium.support.ui.Select
import org.scalatest.BeforeAndAfterEach
import org.scalatest.Tag
import javax.security.auth.login.LoginContext
import org.scalatest.selenium.WebBrowser
import java.io.File
import lib.CommonFuncs

class CreateFBPage {

  //val FranchiseAutomation = new FirefoxProfile(new File("C:\\Users\\ggupta\\AppData\\Roaming\\Mozilla\\Firefox\\Profiles\\mxclx0cc.FranchiseAutomation"))
  //implicit val driver = new FirefoxDriver(FranchiseAutomation)
  val driver = new FirefoxDriver()
  val commonFuncs = new CommonFuncs()
  val url = commonFuncs.ReadConf("facebookUrl")

  def navigate(){
    driver.get(url)
  }

  def login(userEmail: String, pwd: String) {
    commonFuncs.WaitUntilElementPresent(60,driver,"//*[@id='email']")
    driver.findElement(By.xpath("//*[@id='email']")).clear()
    driver.findElement(By.xpath("//*[@id='email']")).sendKeys(userEmail)
    driver.findElement(By.xpath("//*[@id='pass']")).clear()
    driver.findElement(By.xpath("//*[@id='pass']")).sendKeys(pwd)
    driver.findElement(By.xpath("//input[@type='submit']")).click()
    //driver.manage().timeouts().implicitlyWait(30, TimeUnit.SECONDS)
  }

  def createPage(itr: Int) {
      commonFuncs.WaitUntilElementPresent(60,driver,"//*[@id='pagesNav']/h4/a/div")
      driver.findElement(By.xpath("//*[@id='pagesNav']/h4/a/div")).click();
      driver.manage().timeouts().implicitlyWait(5, TimeUnit.SECONDS)
      driver.findElement(By.xpath("//*[@id='pagelet_bookmark_seeall']/div/div[1]/div/div[1]/a")).click();
      driver.manage().timeouts().implicitlyWait(20, TimeUnit.SECONDS)
      driver.findElement(By.xpath("//div[@id='organization']/div/div/i")).click();
      new Select(driver.findElement(By.xpath("//form[@id='organization_form']/div/select"))).selectByVisibleText("Retail and Consumer Merchandise");
      driver.manage().timeouts().implicitlyWait(20, TimeUnit.SECONDS)
      driver.findElement(By.id("organization_form_page_name")).clear();
      driver.findElement(By.id("organization_form_page_name")).sendKeys("FE "+ itr);
      driver.findElement(By.xpath("//*[@id='organization_form']/div[2]/div/input")).click();
      driver.findElement(By.xpath("//*[@id='organization_form']/label/input")).click();
      //driver.manage().timeouts().implicitlyWait(40, TimeUnit.SECONDS)
      commonFuncs.WaitUntilElementPresent(60,driver,"//*[@id='nax_wizard_dialog']/div[3]/div/div/a[2]")
      driver.findElement(By.xpath("//*[@id='nax_wizard_dialog']/div[3]/div/div/a[2]")).click();
      commonFuncs.WaitUntilElementPresent(60,driver,"//*[@id='nax_blurb']/textarea")
      driver.findElement(By.xpath("//*[@id='nax_wizard_dialog']/div[3]/div/div[1]/a/span")).click();
      //driver.manage().timeouts().implicitlyWait(40, TimeUnit.SECONDS)
      commonFuncs.WaitUntilElementPresent(60,driver,"//*[@id='nax_username']")
      driver.findElement(By.xpath("//*[@id='nax_wizard_dialog']/div[3]/div/div[1]/a/span")).click();
      driver.manage().timeouts().implicitlyWait(40, TimeUnit.SECONDS)
      driver.get(url)
  }

  def close() {
    driver.close()
  }

}
