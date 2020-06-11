namespace FirstLine
open OpenQA.Selenium

module Driver = 

    let get () =
            new Firefox.FirefoxDriver()

    let go (url:string) doBefore doAfter (driver:Remote.RemoteWebDriver) = 
        doBefore url; driver.Navigate().GoToUrl url; doAfter()
        driver

    let dropCookies (driver:Remote.RemoteWebDriver) = 
        driver.Manage().Cookies.DeleteAllCookies()
        driver

    let back (driver:Remote.RemoteWebDriver) = 
        driver.Navigate().Back()
        driver

    let refresh (driver:Remote.RemoteWebDriver) = 
        driver.Navigate().Refresh()
        driver

    let leave (driver:Remote.RemoteWebDriver) =
        driver.Quit()
        driver.Dispose()

    let clean (driver:Remote.RemoteWebDriver) =
        leave driver
        get()

    let find selector (driver:Remote.RemoteWebDriver) =
            selector |> driver.FindElementsByCssSelector 
            |> List.ofSeq 

    let findVisible selector driver =
            driver |> find selector |> List.filter (fun elem -> elem.Displayed)

    let firstVisible selector driver =
            driver |> find selector |> List.tryFind (fun elem -> elem.Displayed)

    let frame (elem:IWebElement) (driver:Remote.RemoteWebDriver) =
         elem
            |> function
               | null -> ()
               | frame -> driver.SwitchTo().Frame(frame) |> ignore
         driver

    let frameUp (driver:Remote.RemoteWebDriver) =
         driver.SwitchTo().ParentFrame() |> ignore
         driver

    let clickFirst selector doBefore doAfter driver =
            driver |> firstVisible selector
            |> function
               | None -> ()
               | Some elem -> doBefore elem.Text; elem.Click(); doAfter driver;
            driver

    let clickAll selector doBefore doAfter driver =
            driver |> findVisible selector 
            |> function
               | [] -> ()
               | elems -> elems |> List.iter (fun elem -> doBefore elem.Text; elem.Click(); doAfter driver); 
            driver

    let clickAllFresh selector doBefore doAfter driver =
            let rec clickFreshStartAt i =
                 driver |> findVisible selector |> List.skip i
                 |> function
                    | [] -> ()
                    | elem :: _ -> 
                        doBefore elem.Text; elem.Click(); doAfter driver; clickFreshStartAt(i + 1)
            clickFreshStartAt 0
            driver

    let clickOptionNext selectorOption selectorNext doBefore doAfter driver =
            let rec clickFreshStart() =
                 (driver |> find selectorOption, driver |> find selectorNext )
                 |> function
                    | option :: _, next :: _ -> 
                        doBefore option.Text; option.Click(); next.Click(); doAfter(); clickFreshStart()
                    | _ -> ()
            clickFreshStart()
            driver

    let findVisibleAndDo selector doAction driver =
         driver |> findVisible selector
            |> function
               | [] -> driver
               | elems -> doAction elems driver;

    let findAndDo selector doAction driver =
         driver |> find selector
            |> function
               | [] -> driver
               | elems -> doAction elems driver;

    let rec tryLoop arguments doError doBefore doAfter doAction (driver:Remote.RemoteWebDriver) =
         arguments
            |> function
               | [] -> driver
               | arg :: tail -> 
                    try
                       doBefore arg; 
                       let driver = doAction arg driver;
                       doAfter(); 
                       tryLoop tail doError doBefore doAfter doAction driver
                    with
                    | ex -> doError ex.Message; 
                            tryLoop tail doError doBefore doAfter doAction (clean driver)