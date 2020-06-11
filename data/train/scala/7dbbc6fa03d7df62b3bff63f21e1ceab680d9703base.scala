package testb

import org.openqa.selenium.WebDriver
import org.openqa.selenium.By
import org.openqa.selenium.support.ui.Select
import java.util.concurrent.TimeUnit


object base {

 

 
/*
 * 识别元素时的超时时间
 */
 def setimplicitlyWait(time:Int){
   driver.get_it().manage().timeouts().implicitlyWait(time, TimeUnit.SECONDS)
 
 }
 
 /*
 * 页面加载时的超时时间
 */
 def setpageLoadTimeout(time:Int){
   driver.get_it().manage().timeouts().pageLoadTimeout(time, TimeUnit.SECONDS)

 }
 /*
  * 屏幕最大化
  */
 def setmaxscreen(){
   driver.get_it().manage().window().maximize()
 
 }
 /*
  * 关闭当前窗口
  */
  def close(){
    driver.get_it().close()
  }
 /*
  * 关闭所有窗口
  */
  def quit(){
 driver.get_it().quit()
  }
 
}
