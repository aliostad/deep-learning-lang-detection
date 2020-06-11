// Learn more about F# at http://fsharp.net
// See the 'F# Tutorial' project for more help.

open System
open System.Collections.ObjectModel
open OpenQA.Selenium.PhantomJS
open OpenQA.Selenium.Firefox
open System.Configuration

[<EntryPoint>]
let main argv =
    let applyToKeyword keyword = 
            printfn "start applying %A" keyword
            let getApplyJobUrl (jobId) =
                printf "http://my.monster.com.sg/application_confirmation.html?action=apply&job=%d&from=" jobId

            let loginUrl = @"https://my.monster.com.sg/login.html"
    
            use driver = new PhantomJSDriver()
            driver.Manage().Timeouts().ImplicitlyWait(TimeSpan.FromSeconds(10.0)) |> ignore

            driver.Url <- loginUrl
            let user = driver.FindElementById("BodyContent:txtUsername")
            let password = driver.FindElementById("BodyContent_txtPassword")
            let useEmailCheckbox = driver.FindElementByName("checkbox")
            let submit = driver.FindElementByName("submit")

            user.SendKeys(ConfigurationSettings.AppSettings.Item("username"))
            password.SendKeys(ConfigurationSettings.AppSettings.Item("password"))
            submit.Click();

            driver.FindElementById("profileimg") |> ignore

            printfn "logged in."
        
            let searchUrl = "http://jobsearch.monster.com.sg/search.html"
            driver.Url <- searchUrl
            let searchBox = driver.FindElementByCssSelector("#fts_id")
            searchBox.Clear();

            searchBox.SendKeys(keyword) |> ignore

            let last30DaysCheckBox = driver.FindElementByCssSelector("#day30");
            last30DaysCheckBox.Click()

            let dontIncludeSalaryDescriptionCheckBox = driver.FindElementByCssSelector("#ans")
            dontIncludeSalaryDescriptionCheckBox.Click()

            let searchButton = driver.FindElementByCssSelector(".ns_findbtn")
            searchButton.Click()

            let applyJobCheckboxes = driver.FindElementsByName("job")

            let c = applyJobCheckboxes.Count
            for abc in applyJobCheckboxes
                do abc.Click()
    
            let applyJobSubmit = driver.FindElementByCssSelector(".ns_reg_btn")
            applyJobSubmit.Click()
            try
                let resultPane = driver.FindElementByClassName("bg_green1")
                printfn "%A" resultPane.Text
            with
            | _ -> printfn "apply job submit error for %A" keyword

    let keywords = 
        ConfigurationSettings.AppSettings.Item("keywords").Split [|';'|]

    printfn "search keywords in configuration is %A" keywords

    keywords |> Array.iter applyToKeyword
    
    printfn "completed job"

    0 // return an integer exit code
