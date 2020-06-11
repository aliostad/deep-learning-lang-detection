open canopy
open canopy.core
open canopy.types
open runner
open configuration
open reporters
open System
open System.IO
open System.Reflection
open System.Drawing
open OpenQA.Selenium

open matchrunner

[<EntryPoint>]
let main argv = 

  configuration.chromeDir <- Path.GetDirectoryName(Assembly.GetExecutingAssembly().Location)
  let myChrome = 
    let options = Chrome.ChromeOptions()
    options.AddArgument("start-maximized")
//    options.AddArgument("--enable-logging")
//    options.AddArgument("--v=0")
    ChromeWithOptions options
    
  start myChrome
  
  browser.Manage().Cookies.DeleteAllCookies()
  
  matchrunner.runTests()
  canopy.runner.run()
  
  printf "%d" runner.failedCount
  printfn "press [enter] to exit"
  System.Console.ReadLine() |> ignore
  
  quit()
  0