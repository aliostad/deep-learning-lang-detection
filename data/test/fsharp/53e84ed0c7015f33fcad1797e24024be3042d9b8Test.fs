namespace moodleNufs
open System

open NUnit.Framework
open System
open OpenQA.Selenium
open OpenQA.Selenium.Appium
open OpenQA.Selenium.Remote
open OpenQA.Selenium.Appium.Android

module utils =

    let log (text : string) =
        System.Console.Error.WriteLine(text)

    let wait (duration:int) =
        log("Now waiting for" + string(duration) + "seconds") 
        System.Threading.Thread.Sleep(duration)



open utils

[<TestFixture>]
type Test() = 
    let MOODLE_SITE = "http://46.101.125.192/moodle/"
    let MOODLE_USERNAME = "admin"
    let MOODLE_PASSWORD = "Ch!3eDre=er5"
    let SEARCH_TEXT = "Data Structures";
    let TEST_ENDPOINT = new Uri("http://127.0.0.1:4723/wd/hub") // If Appium is running locally
    let INIT_TIMEOUT_SEC = TimeSpan.FromSeconds(300.0) (* Change this to a more reasonable value *)
    let IMPLICIT_TIMEOUT_SEC = TimeSpan.FromSeconds(120.0) (* Change this to a more reasonable value - This is the time to wait when looking for an item on the page *) 
    let cap = new DesiredCapabilities()
    static member val setupComplete = false with get, set
    static member val driver = null with get, set

    [<SetUp>]
    member x.Init() =

        if (Test.setupComplete=false) then
            cap.SetCapability("deviceName", "LYO-L21")
            cap.SetCapability("appPackage", "com.moodle.moodlemobile")
            //cap.SetCapability("appActivity", "com.moodle.moodlemobile.MoodleMobile");
            ///cap.SetCapability("autoLaunch", true);
            
            //Launch Android driver
            Test.driver <- new AndroidDriver<AndroidElement>(TEST_ENDPOINT, cap, INIT_TIMEOUT_SEC)
            Test.driver.Manage().Timeouts().ImplicitlyWait(IMPLICIT_TIMEOUT_SEC) |> ignore
            Test.setupComplete <- true
            log("Completed setup")
        else
            ()

    [<Test; Order(1)>]
    member x.appLoaded() =
        //verify if the application is launched
        Assert.IsNotNull (Test.driver.Context)
        wait 1000


    [<Test; Order(2)>]
    member x.connectSite() =
        let siteTxtBox = Test.driver.FindElementByXPath("//android.widget.LinearLayout[1]/android.widget.FrameLayout[1]/android.webkit.WebView[1]/android.webkit.WebView[1]/android.view.View[1]/android.view.View[1]/android.view.View[1]/android.view.View[3]/android.view.View[1]/android.view.View[1]/android.view.View[1]/android.view.View[2]/android.view.View[1]/android.view.View[1]/android.widget.EditText[1]");
        siteTxtBox.Clear()
        siteTxtBox.SendKeys(MOODLE_SITE)
        let connectBtn = Test.driver.FindElementByXPath("//android.widget.LinearLayout[1]/android.widget.FrameLayout[1]/android.webkit.WebView[1]/android.webkit.WebView[1]/android.view.View[1]/android.view.View[1]/android.view.View[1]/android.view.View[3]/android.view.View[1]/android.view.View[1]/android.view.View[1]/android.view.View[2]/android.view.View[1]/android.view.View[2]/android.widget.Button[1]");
        connectBtn.Click()
        wait 100

        let usernameTxtBox = Test.driver.FindElementByXPath("//android.widget.LinearLayout[1]/android.widget.FrameLayout[1]/android.webkit.WebView[1]/android.webkit.WebView[1]/android.view.View[1]/android.view.View[1]/android.view.View[1]/android.view.View[3]/android.view.View[1]/android.view.View[1]/android.view.View[1]/android.view.View[2]/android.view.View[1]/android.view.View[1]/android.widget.EditText[1]");
        usernameTxtBox.SendKeys(MOODLE_USERNAME)

        StringAssert.Contains(usernameTxtBox.Text, MOODLE_USERNAME)

        wait 1000

    [<Test; Order(20)>]
    member x.logIn() =
        let usernameTxtBox = find("//android.widget.LinearLayout[1]/android.widget.FrameLayout[1]/android.webkit.WebView[1]/android.webkit.WebView[1]/android.view.View[1]/android.view.View[1]/android.view.View[1]/android.view.View[3]/android.view.View[1]/android.view.View[1]/android.view.View[1]/android.view.View[2]/android.view.View[1]/android.view.View[1]/android.widget.EditText[1]");
		usernameTxtBox.Clear();
		usernameTxtBox.SendKeys(MOODLE_USERNAME);

		let passwordTxtBox = find("//android.widget.LinearLayout[1]/android.widget.FrameLayout[1]/android.webkit.WebView[1]/android.webkit.WebView[1]/android.view.View[1]/android.view.View[1]/android.view.View[1]/android.view.View[3]/android.view.View[1]/android.view.View[1]/android.view.View[1]/android.view.View[2]/android.view.View[1]/android.view.View[2]/android.widget.EditText[1]");
		passwordTxtBox.SendKeys(MOODLE_PASSWORD);

		let loginBtn = find("//android.widget.LinearLayout[1]/android.widget.FrameLayout[1]/android.webkit.WebView[1]/android.webkit.WebView[1]/android.view.View[1]/android.view.View[1]/android.view.View[1]/android.view.View[3]/android.view.View[1]/android.view.View[1]/android.view.View[1]/android.view.View[2]/android.view.View[1]/android.view.View[3]/android.widget.Button[1]");
		loginBtn.Click();

        //AndroidElement sideMenuToggleBtn = find("//android.widget.LinearLayout[1]/android.widget.FrameLayout[1]/android.webkit.WebView[1]/android.webkit.WebView[1]/android.view.View[1]/android.view.View[1]/android.view.View[1]/android.view.View[1]/android.view.View[2]/android.view.View[1]/android.widget.Button[1]");
        //sideMenuToggleBtn.Click();

		let searchBtn = find("//android.widget.LinearLayout[1]/android.widget.FrameLayout[1]/android.webkit.WebView[1]/android.webkit.WebView[1]/android.view.View[1]/android.view.View[1]/android.view.View[1]/android.view.View[1]/android.view.View[2]/android.view.View[1]/android.view.View[2]/android.view.View[1]");
		searchBtn.Click();

		let searchTxtBox = find("//android.widget.LinearLayout[1]/android.widget.FrameLayout[1]/android.webkit.WebView[1]/android.webkit.WebView[1]/android.view.View[1]/android.view.View[1]/android.view.View[1]/android.view.View[1]/android.view.View[3]/android.view.View[1]/android.view.View[1]/android.view.View[1]/android.view.View[1]/android.view.View[1]/android.widget.EditText[1]");
		searchTxtBox.SendKeys(SEARCH_TEXT)

		StringAssert.Contains(searchTxtBox.Text, SEARCH_TEXT);
		wait 1000 

    [<Test; Order(30)>]
    member x.courseSearch() =
        let searchTxtBox = find("//android.widget.LinearLayout[1]/android.widget.FrameLayout[1]/android.webkit.WebView[1]/android.webkit.WebView[1]/android.view.View[1]/android.view.View[1]/android.view.View[1]/android.view.View[1]/android.view.View[3]/android.view.View[1]/android.view.View[1]/android.view.View[1]/android.view.View[1]/android.view.View[1]/android.widget.EditText[1]");
		searchTxtBox.Clear();
		wait 500
		searchTxtBox.SendKeys(SEARCH_TEXT);

		let searchBtn = find("//android.widget.LinearLayout[1]/android.widget.FrameLayout[1]/android.webkit.WebView[1]/android.webkit.WebView[1]/android.view.View[1]/android.view.View[1]/android.view.View[1]/android.view.View[1]/android.view.View[3]/android.view.View[1]/android.view.View[1]/android.view.View[1]/android.view.View[1]/android.view.View[1]/android.widget.Button[1]\n");
		searchBtn.Click();

