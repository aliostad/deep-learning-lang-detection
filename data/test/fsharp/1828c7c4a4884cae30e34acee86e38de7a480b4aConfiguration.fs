namespace ellipsoid.org.Weatherwax.Web

open CacheByAttribute
open ellipsoid.org.SharpAngles
open ellipsoid.org.Weatherwax.Core
open ellipsoid.org.Weatherwax.Core.ClientDirectives
open IntelliFactory.WebSharper
open IntelliFactory.WebSharper.Html
open IntelliFactory.WebSharper.Html.Client
open IntelliFactory.WebSharper.JavaScript
open IntelliFactory.WebSharper.Sitelets
open System
open System.Diagnostics
open System.IO
open System.Web
open System.Web.Configuration

(*
    Note
    ====

    If copying this sample application, don't forget to remove the references to the following assemblies
    and install the corresponding NuGet packages:

    - ellipsoid.org.Weatherwax.Core
*)

type AngularState =
    | Master
    | Master_Home
    | Master_About
    | Master_Music
    | Master_Error

module Configuration =

    [<JavaScript>]
    let AppName = "siteletApp"

    [<Cache(ExpiryHours = 24)>]
    let PhantomJsSnapshot baseUrl fragment =
        async {
            // As (somewhat) per http://stackoverflow.com/questions/18530258/how-to-make-a-spa-seo-crawlable
            let appRoot = Path.GetDirectoryName(AppDomain.CurrentDomain.BaseDirectory)
            let appPath = Path.Combine(appRoot, "App_Data\\PhantomJs\\phantomjs.exe")
            let optionsPath = Path.Combine(appRoot, "App_Data\\PhantomJs\\snapshot.js")
            let fragmentUrl = sprintf "%s/#!/%s" baseUrl fragment
            let startInfo =
                ProcessStartInfo
                    (Arguments = sprintf "--load-images=false --ignore-ssl-errors=true --ssl-protocol=any %s %s"
                                     optionsPath fragmentUrl, FileName = appPath, UseShellExecute = false,
                     CreateNoWindow = true, RedirectStandardOutput = true, RedirectStandardError = true,
                     RedirectStandardInput = true, StandardOutputEncoding = System.Text.Encoding.UTF8)
            let phantomJsProcess = new Process(StartInfo = startInfo)
            let startResult = phantomJsProcess.Start()
            let output = phantomJsProcess.StandardOutput.ReadToEnd()
            let stopResult = phantomJsProcess.WaitForExit(10000)

            return output
        }
        |> Async.RunSynchronously