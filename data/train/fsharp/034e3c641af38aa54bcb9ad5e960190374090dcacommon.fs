module common

open config

open canopy

open System

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

let signOut _ =
  hover "N"
  click "Sign Out "
  browser.Manage().Cookies.DeleteAllCookies()

let random n =
  Guid.NewGuid().ToString().Substring(0, n)


let assignSiteType _ =
  Console.WriteLine siteType
  Console.WriteLine(currentUrl())
  siteType <- if currentUrl().Contains("https") then 1 else 2
  Console.WriteLine siteType

let closeEmailAlert _ =
  if exists ".notif-email" then
     let element1 = element ".notif-email"
     if element1.Displayed then click "Later"

  if exists "#notificationEmail" then
     let modal2 = element "#notificationEmail"
     if modal2.Displayed then click "continue to site"