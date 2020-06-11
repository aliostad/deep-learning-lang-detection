// Learn more about F# at http://fsharp.net
// See the 'F# Tutorial' project for more help.

open OpenQA.Selenium
open OpenQA.Selenium.Support.UI
open System.Net
open System.IO
open System

module Crawler =
    type InputNodes = 
        | Link of URL:string * Name:string
        | Container of Name:string * Elements:InputNodes list

    let driver = new OpenQA.Selenium.Firefox.FirefoxDriver()

    let wait = new WebDriverWait(driver, System.TimeSpan.FromSeconds(4.5))

    if (not (System.IO.File.Exists("credentials.txt"))) then
        printfn "You need a credentials.txt with your username and password on the first 2 lines."
        exit 1
    let username,password = 
        let fin = System.IO.File.ReadAllLines("credentials.txt")
        (fin.[0], fin.[1])

    let goto (url:string) = driver.Navigate().GoToUrl(url)

    let findID id = driver.FindElementById(id)

    let click (element:IWebElement) = element.Click()

    let setText (element:IWebElement) text = element.SendKeys(text)

    let findWID id = wait.Until(ExpectedConditions.ElementIsVisible(By.Id(id)))

    let findWT tag = wait.Until(ExpectedConditions.ElementExists(By.TagName(tag)))

    let findWLX xpath = wait.Until(ExpectedConditions.PresenceOfAllElementsLocatedBy(By.XPath(xpath)))

    let findsWT tag = wait.Until(ExpectedConditions.VisibilityOfAllElementsLocatedBy(By.TagName(tag)))

    let findsWX xpath = wait.Until(ExpectedConditions.VisibilityOfAllElementsLocatedBy(By.XPath(xpath)))

    let text (element:IWebElement) = element.Text

    let rec parseContainer (elements:IWebElement seq) =
        let links = 
                    let toLink (e:IWebElement) = 
                        Link(e.FindElement(By.XPath("./*[1]")).GetAttribute("href"), e.FindElement(By.XPath("./*[1]")).Text)
                    elements
                    |> Seq.filter(fun e -> e.FindElement(By.XPath("./*[1]")).TagName = "a") 
                    |> Seq.toList 
                    |> List.map(fun e -> toLink e)
                    |> List.filter (fun l -> match l with | Link(url, name) -> url.ToLower().Contains("cgcookie") | _ -> false)
                    |> List.map(fun l -> match l with | Link(url,name) -> Link(url.ToLower().Replace("cgcookie.com", "cgcookiearchive.com"), name))
        let folders = elements 
                      |> Seq.filter(fun e -> e.FindElement(By.XPath("./*[1]")).TagName = "h3")
                      |> Seq.toList
                      |> List.map(fun f -> Container(f.FindElement(By.XPath("./*[1]")).Text, parseContainer (f.FindElements(By.XPath("./dl/dt")))))
                      |> List.filter(fun c -> match c with | Container(name, nodes) -> Seq.length  nodes > 0 | _ -> false)
        if (Seq.length folders > 0 ) then
            (Container("_Folder_Loose_Links", links)) :: folders
        else
            List.append folders links


    let printTree tree prefix =
        let rec fout = System.IO.File.CreateText("out.txt")
        let rec printTree tree prefix = 
            match tree with
            | Container(name, nodes) -> fprintf fout "%s-->%s\n" prefix name; nodes |> List.iter (fun n -> printTree n (prefix + "-->" + name))
            | Link(url, name) -> fprintf fout "%s--:%s (%s)\n" prefix name url
        printTree

    let makeNameSafe name = 
        let invalids = Array.concat [Path.GetInvalidPathChars(); Path.GetInvalidFileNameChars()]
        invalids |> Seq.fold (fun (str:string) c -> str.Replace(string c, ""))  name

    let saveEntirePage url name path =
        printfn "Saving page content for: %s" url  
        let clientDownload path (url:string) extension=
            let client = new WebClient()
            let header = (driver.Manage().Cookies.AllCookies) |> Seq.fold (fun acum s -> acum + s.Name + "=" + s.Value + ";") ""
            client.Headers.Add(HttpRequestHeader.Cookie, header)
            let agent = string (driver.ExecuteScript("return navigator.userAgent"))
            client.Headers.Add("user-agent", agent)
            let stream = client.OpenRead(url)
            let starti = 
                if (url.Contains("/?post_id")) then url.Substring(0, url.IndexOf("/?post_id")-1).LastIndexOf("/") + 1
                else 0
            let endi = url.IndexOf("/?post_id")
            let len = endi - starti
            let filename = 
                if len > 0 then url.Substring(starti, len) + extension
                else url.Substring(url.LastIndexOf("/") + 1)
            use fout = File.Create(Path.Combine(path, makeNameSafe filename))
            stream.CopyTo(fout)

        let downloadVideo path = 
            printfn "Downloading video"
            try
                driver.FindElement(By.ClassName("post-downloads-toggle")).Click()
                let videoLink = findWLX "//div[@class='post-downloads']/a" |> Seq.filter (fun e -> e.Text.Trim() = "HD Video")
                if Seq.length videoLink > 0 then
                    videoLink |> Seq.iteri(fun i a -> clientDownload path (a.GetAttribute("href")) ".zip")
                    driver.FindElement(By.ClassName("post-downloads-toggle")).Click()
                else
                    failwith "Video not found"
            with
                _ -> try clientDownload path ((findWT "source").GetAttribute("src")) ".mp4" with _ -> ()

        let downloadNoneVideoFiles path =
            printfn "Downloading files"
            try
                driver.FindElement(By.ClassName("post-downloads-toggle")).Click()
                let fileLink = findWLX "//div[@class='post-downloads']/a" |> Seq.filter (fun e -> e.Text.Trim() <> "HD Video")
                if Seq.length fileLink > 0 then
                    fileLink |> Seq.iter (fun a -> clientDownload path (a.GetAttribute("href")) "_files.zip")
                driver.FindElement(By.ClassName("post-downloads-toggle")).Click()
            with _ -> ()

        let downloadPage path (name:string) =
            printfn "Saving html"
            let name = if name.EndsWith(".htm") then name else  name + ".htm"
            let html = driver.FindElementByTagName("html").GetAttribute("innerHTML")
            File.WriteAllText(Path.Combine(path, makeNameSafe name), html)

        goto url
        let path = Path.Combine(path, makeNameSafe name)
        Directory.CreateDirectory(path) |> ignore
        downloadVideo path
        downloadNoneVideoFiles path
        downloadPage path name
        path
                                
    let rec saveNodesToDisk path container =
        match container with 
        | Container(name, links) -> //Create direcotries and then save all the links data
                                    printfn "saveNodesToDisk Handling container: %s" name
                                    let newPath = System.IO.Path.Combine(path, makeNameSafe name)
                                    System.IO.Directory.CreateDirectory(newPath) |> ignore
                                    let folders = links |> List.filter (fun l -> match l with | Container(_,_) -> true | _ -> false) 
                                    folders |> List.iter (saveNodesToDisk newPath)
                                    links |> List.iter (fun l -> match l with | Link(_,_) -> saveNodesToDisk newPath l | _ -> ())
                                
        | Link(url, name) -> //Save all the links data 
                             printfn "saveNodesToDisk Handling link: %s" name
                             goto url
                             if url.ToLower().Contains("/lessons/") then //Handle all lesson pages at once
                                let course = Seq.head (findWLX "//div[@class='additional-info']//a")
                                saveNodesToDisk path (Link(course.GetAttribute("href"), course.Text))
                             else                            
                                printfn "saveNodesToDisk Parsing: %s" name
                                //Check if we are on the TOC for a course otherwise save the one off page
                                try
                                    if not ((Seq.head (findWLX "//div[@class='course-lessons']/h3") |> text).Contains("Lessons")) then failwith "UNEXPECTED PAGE!"
                                    let path = saveEntirePage url name path
                                    let lessonLinks = findWLX "//ol[@class='course-lessons-list']/li/a" |> Seq.map (fun e -> e.GetAttribute("href"), (e.Text.Trim())) |> Seq.toArray
                                    lessonLinks |> Seq.iter (fun (link,text) -> saveEntirePage link text path |> ignore)
                                with | :? OpenQA.Selenium.WebDriverTimeoutException  ->
                                    //If lessons list can't be found assume we are on an one off page and save only this pages content to disk.
                                    saveEntirePage url name path |> ignore

open Crawler

[<EntryPoint>]
let main args =
    let outputDirectory = 
        if args.Length > 0 then 
            args.[1]
        else
            @"F:\"

    //Get all the links and file structure we will need for the export
    printfn "Building tree"
    if (not (System.IO.File.Exists("bookmarks.html"))) then
        printfn "You must have a bookmarks.html in the working directory. See the readme."
        exit 1
    goto ("file:///" + (System.IO.Path.Combine(System.Environment.CurrentDirectory, "bookmarks.html")))
    let eles = findsWX "/html/body/dl/dt"
    let result = Container("Output", parseContainer eles)

    //Log in
    printfn "Logging in"
    goto "https://cgcookiearchive.com/"
    findWID "header-login-form-toggle" |> click
    setText (findWID "user_login") username
    setText (findWID "user_pass")  password
    click (findWID "wp-submit")

    //Save all links with correct file structure to disc
    printfn "Saving..."
    if (not (Directory.Exists(Path.Combine(outputDirectory, "Output")))) then
        Directory.CreateDirectory(Path.Combine(outputDirectory, "Output")) |> ignore
    saveNodesToDisk (Path.Combine(outputDirectory)) result

    driver.Close()
    exit 0 // return an integer exit code