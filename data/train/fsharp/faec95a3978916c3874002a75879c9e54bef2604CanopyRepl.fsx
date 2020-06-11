#I "./FSharpModules/UnionArgParser/lib/net40"
#I "./FSharpModules/Microsoft.SqlServer.Types/lib/net20"
#I "./FSharpModules/FSharp.Data/lib/net40"
#I "./FSharpModules/FSharp.Data.SqlClient/lib/net40"
#I "./FSharpModules/Http.fs/lib/net40"
#I "./FSharpModules/Selenium.WebDriver/lib/net40"
#I "./FSharpModules/Selenium.Support/lib/net40"
#I "./FSharpModules/SizSelCsZzz/lib"
#I "./Fsharpmodules/Newtonsoft.Json/lib/net40"
#I "./FSharpModules/canopy/lib"
#I "./FsharpModules/Http.fs/lib/net40"

#r "UnionArgParser.dll"
#r "Microsoft.SqlServer.Types.dll"
#r "FSharp.Data.SqlClient.dll"
#r "HttpClient.dll"
#r "WebDriver.dll"
#r "WebDriver.Support.dll"
#r "HttpClient.dll"
#r "canopy.dll"
#r "System.Core.dll"
#r "System.Xml.Linq.dll"
#r "FSharp.Data.dll"

open HttpClient
open canopy
open runner
open System
open System.Collections.ObjectModel
open System.Collections.Generic
open FSharp.Data
open FSharp.Data.JsonExtensions
open Nessos.UnionArgParser
open types
open reporters
open configuration
open OpenQA.Selenium.Firefox
open OpenQA.Selenium
open OpenQA.Selenium.Support.UI
open OpenQA.Selenium.Interactions


let exists selector =
  let e = someElement selector
  match e with
    | Some(e) -> true
    | _ -> false

let openBrowser _ =
    configuration.chromeDir <- "./"
    let options = Chrome.ChromeOptions()
    options.AddArgument("--enable-logging")
    options.AddArgument("--v=0")
    start (ChromeWithOptions options)
    deleteCookies ()

let deleteCookies _ =
    browser.Manage().Cookies.DeleteAllCookies()
    (js """
          localStorage.removeItem('game')
        """)

let ids _ =
  (js """
        return $('[id]').map(function(a) {
            return $($('[id]')[a]).attr('id');
        })
      """) :?> ReadOnlyCollection<System.Object> |> List.ofSeq

let names _ =
  (js """
        return $('[name]').map(function(a) {
            return $($('[name]')[a]).attr('name');
        })
      """) :?> ReadOnlyCollection<System.Object> |> List.ofSeq

let switchTo b = browser <- b
let index = "http://localhost:3000/"

let resetGame _ =
  url "http://localhost:3000/reset-game"
  url index

let getGame _ =
  let response = "http://localhost:3000/game" |> createRequest Get |> getResponse
  JsonValue.Parse response.EntityBody.Value

openBrowser()
let player1 = browser
openBrowser()
let player2 = browser

tile [player1; player2]

resetGame ()
switchTo player1
url index
click "Join Game"
click "pikachu"
click "kabuto"
click "rattata"
click "raichu"
click "jynx"
switchTo player2
url index
click "Join Game"
click "beedrill"
click "golbat"
click "mankey"
click "staryu"
click "vulpix"

switchTo player1
sleep 1
click "pikachu"

switchTo player2
sleep 1
click "beedrill"

switchTo player1
sleep 1
click "Attack!"

switchTo player2
sleep 1
click "Attack!"

resetGame ()

reload()

url "http://localhost:3000/sandbox"

getGame () |> printfn "%A"

let response = "http://localhost:3000/game-state" |> createRequest Get |> getResponse
JsonValue.Parse response.EntityBody.Value

quit()

deleteCookies ()
url "http://localhost:3000/rpg"
click "Ask Mommy for help."
click "[data-ui-location='forest']"
click "Go home."
click "Go look for some trouble."
click "Attack"
click "Throw dat ball"
