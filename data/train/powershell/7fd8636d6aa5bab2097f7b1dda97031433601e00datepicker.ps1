# http://techlearn.in/content/how-select-particular-date-date-picker-selenium-web-driver
<#

package TechLearndotin;
import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.firefox.FirefoxDriver;
import org.openqa.selenium.support.ui.Select;
import org.testng.annotations.Test;
import org.testng.annotations.BeforeTest;
import org.testng.annotations.AfterTest;
import com.thoughtworks.selenium.Selenium;

public class Rightclick {
      public WebDriver driver;
      public Selenium selenium;
    
 @Test 
       public void Datepicker() throws Exception {
       driver.get("http://techlearn.in");
       driver.findElement(By.linkText("Register")).click();
       Thread.sleep(3000); // Selecting date from Date picker using the following code Ex: My Date of Birth is : October 21 1988.
       new Select(driver.findElement(By.id("edit-submitted-date-of-birth-month"))).selectByVisibleText("Oct");
       new Select(driver.findElement(By.id("edit-submitted-date-of-birth-day"))).selectByVisibleText("21");
       new Select(driver.findElement(By.id("edit-submitted-date-of-birth-year"))).selectByVisibleText("1988");
       }
   
 @BeforeTest
      public void beforeTest() {
      driver = new FirefoxDriver();
      driver.manage().window().maximize();
      }

 @AfterTest
      public void afterTest() {
      }
      }

 
#>

# http://www.mythoughts.co.in/2013/04/selecting-date-from-datepicker-using.html#.VERjLYXwAQd
# 

<#

    import java.util.List;  
    import java.util.List;  
    import java.util.concurrent.TimeUnit;  
    import org.openqa.selenium.By;  
    import org.openqa.selenium.WebDriver;  
    import org.openqa.selenium.WebElement;  
    import org.openqa.selenium.firefox.FirefoxDriver;  
    import org.testng.annotations.BeforeTest;  
    import org.testng.annotations.Test;;  
      
    public class DatePicker {  
      
     WebDriver driver;  
       
     @BeforeTest  
     public void start(){  
     System.setProperty("webdriver.firefox.bin", "C:\\Program Files (x86)\\Mozilla Firefox\\firefox.exe");    
     driver = new FirefoxDriver();  
     }  
       
     @Test  
     public void Test(){  
       
      driver.get("http://jqueryui.com/datepicker/");  
      driver.switchTo().frame(0);  
      driver.manage().timeouts().implicitlyWait(60, TimeUnit.SECONDS);  
      //Click on textbox so that datepicker will come  
      driver.findElement(By.id("datepicker")).click();  
      driver.manage().timeouts().implicitlyWait(60, TimeUnit.SECONDS);  
      //Click on next so that we will be in next month  
      driver.findElement(By.xpath(".//*[@id='ui-datepicker-div']/div/a[2]/span")).click();  
        
      /*DatePicker is a table.So navigate to each cell   
       * If a particular cell matches value 13 then select it  
       */  
      WebElement dateWidget = driver.findElement(By.id("ui-datepicker-div"));  
      List<webelement> rows=dateWidget.findElements(By.tagName("tr"));  
      List<webelement> columns=dateWidget.findElements(By.tagName("td"));  
        
      for (WebElement cell: columns){  
       //Select 13th Date   
       if (cell.getText().equals("13")){  
       cell.findElement(By.linkText("13")).click();  
       break;  
       }  
      }   
     }  
}
#>