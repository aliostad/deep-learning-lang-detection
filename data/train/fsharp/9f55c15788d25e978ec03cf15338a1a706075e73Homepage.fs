module Viewer.Pages.Homepage 

open OpenQA.Selenium
open System
open canopy

let viewerUrl = 
  let var = Environment.GetEnvironmentVariable("VIEWER_URL")
  if String.IsNullOrEmpty var then failwith "Environment variable 'VIEWER_URL' not found"
  else var

let setCookie name value =
  let cookie = new Cookie(name, value);
  browser.Manage().Cookies.AddCookie(cookie);

let expandVocabularies () = 
  let clickAll selector =
    elements selector
    |> List.iter (fun element -> click element)

  clickAll ".accordion-trigger"

let load () =
  url viewerUrl //Strangely we must make a call to url to enable the setCookie call to work!
  setCookie "test" "test"
  url viewerUrl // This call now sends the cookies!
  expandVocabularies ()

let selectVocabTerm term =
  check (sprintf "input[value='%s']" term)

let search () = 
  click "input[type='submit']"

let resultCount () = 
  elements ".result" |> List.length

let totalKBCount () =
  let kbCount = elements ".counter" |> List.head
  kbCount.Text

let getViewerSearchResults () =
  elements ".abstract"
  |> List.map(fun y -> y.Text)
  |> List.toArray
