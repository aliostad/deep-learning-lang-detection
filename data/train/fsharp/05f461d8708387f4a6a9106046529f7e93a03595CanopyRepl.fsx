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
open FSharp.Data
open Nessos.UnionArgParser
open types
open reporters
open configuration
open OpenQA.Selenium.Firefox
open OpenQA.Selenium
open OpenQA.Selenium.Support.UI
open OpenQA.Selenium.Interactions

let genderInput = "#genderGenderSeek"
let postalCodeInput = "#postalCode"
let viewSinglesButton = "View Singles"
let emailRegisterInput = "[name='email']"
let passwordRegisterInput = "[name='password']"
let birthMonthInput = "#birthMonth"
let birthDayInput = "#birthDay"
let birthYearInput = "#birthYear"
let handleInput = "[name='handle']"
let emailLoginInput = "#email"
let passwordLoginInput = "#password"
let signOutNav = "N"
let signOutButton = "Sign Out "
let signInButton = "Sign in now »"
let matchOptionClass = ".option"
let favoriteMatchClass = ".cta-favorite"
let favoritesButton = "F"
let myFavesButton = "my faves "
let favoriteCardsClass = ".cards"
let addEntryVerifulUrl = "/matchbook/AddEntry.aspx"

let matchUrl = "http://www.match.com"
let matchCreateAccountUrl = "http://www.match.com/registration/registration.aspx"
let loginUrl = "https://secure.match.com/login/index/#/"
let profileWelcomeVerifyUrl = "/Profile/Create/Welcome/?"
let myMatchVerify1Url = "/home/mymatch.aspx"
let myMatchVerify2Url = "/MyMatch/Index"

let exists selector =
  let e = someElement selector
  match e with
    | Some(e) -> true
    | _ -> false

let split sep (x : String) = x.Split([|sep|])

let next _ =
  click "Continue"

let keepGoing _ =
  click ".progress-next"

let random n =
  Guid.NewGuid().ToString().Substring(0, n)

let openBrowser _ =
  configuration.chromeDir <- "./"
  let options = Chrome.ChromeOptions()
  options.AddArgument("--enable-logging")
  options.AddArgument("--v=0")
  start (ChromeWithOptions options)
  browser.Manage().Cookies.DeleteAllCookies()

let mutable siteType = 1
let mutable myFavorite = "some favorite"
let mutable email = random 5 + "@gmail.com"
let mutable username = random 5
let mutable password = random 5

let assignSiteType _ =
  sleep 5
  printfn "%d" siteType
  printfn "%s" ( currentUrl() )
  siteType <- if exists "#topspot-dash" then 2 else 1
  printfn "%d" siteType

let init _ =
  siteType <- 1
  email <- random 5 + "@gmail.com"
  username <- random 5
  password <- random 5
  ()

let closeEmailAlert _ =
  if exists ".notif-email" then
     let element1 = element ".notif-email"
     if element1.Displayed then click "Later"

  if exists "#notificationEmail" then
     let modal2 = element "#notificationEmail"
     if modal2.Displayed then click "continue to site"

let createAccount _ =
  url matchCreateAccountUrl
  genderInput << "Man seeking a Woman"
  postalCodeInput << "75034"
  click viewSinglesButton
  emailRegisterInput << email
  next ()
  passwordRegisterInput << password
  birthMonthInput << "Dec"
  birthDayInput << "29"
  birthYearInput << "1987"
  next ()
  handleInput << username
  next ()
  on profileWelcomeVerifyUrl //logged in
  url matchUrl

let signOut _ =
  hover signOutNav
  click signOutButton
  browser.Manage().Cookies.DeleteAllCookies()

let signIn _ =
  browser.Manage().Cookies.DeleteAllCookies()
  url loginUrl
  assignSiteType()
  emailLoginInput << email
  passwordLoginInput << password
  click signInButton
  closeEmailAlert()

let addFavorite _ =
  url matchUrl
  let firstMatch = first matchOptionClass
  myFavorite <- firstMatch.Text.Split(' ').[0].Split('\r', '\n').[0]
  click myFavorite
  click favoriteMatchClass
  on addEntryVerifulUrl

let verifyFavorite _ =
  click favoritesButton
  closeEmailAlert()
  click myFavesButton
  displayed favoriteCardsClass
  displayed myFavorite

openBrowser()
init()
createAccount()
signOut()
signIn()
addFavorite()
signOut()
signIn()
verifyFavorite()
signOut()
signIn()
