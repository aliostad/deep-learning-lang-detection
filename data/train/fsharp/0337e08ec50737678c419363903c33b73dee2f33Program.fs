open System
open System.Net
open System.Web
open System.IO
open System.Text
open System.Configuration
open System.Windows.Forms
open FSharp.Data

type OAuth = JsonProvider<"oauth.json">
type Projects = JsonProvider<"projects.json">

let clientId = ""
let secretKey =""
let redirectUri = ""

let authUri = "https://app.vssps.visualstudio.com/oauth2/authorize?mkt=ru-RU"
let tokenUri = "https://app.vssps.visualstudio.com/oauth2/token?mkt=ru-RU"

let buildsUri = "https://justforlab.visualstudio.com/DefaultCollection/_apis/projects"

let codeQuery = 
    authUri+"&response_type=Assertion" +
    "&client_id=" + clientId +
    "&redirect_uri=" + redirectUri +
    "&scope=vso.build_execute vso.chat_manage vso.code_manage vso.test_write vso.work_write"

let tokenQuery code = 
        tokenUri + "&client_assertion_type=urn:ietf:params:oauth:client-assertion-type:jwt-bearer" +
         "&client_assertion=" + secretKey +
         "&grant_type=urn:ietf:params:oauth:grant-type:jwt-bearer"+
         "&assertion=" + code +
         "&redirect_uri=" + redirectUri

let mutable (oauth:Option<OAuth.Root>) = None

let readResponse (resp:WebResponse) =
    use stream = resp.GetResponseStream()
    use reader = new StreamReader(stream)
    reader.ReadToEnd()

let accessToken token =
    let bytes = Encoding.ASCII.GetBytes(tokenQuery token)
         
    let req = WebRequest.Create(tokenUri, Method="POST", ContentType="application/x-www-form-urlencoded", ContentLength=bytes.LongLength)
    use context = req.GetRequestStream()
    context.Write(bytes, 0, bytes.Length)

    let txt = readResponse (req.GetResponse())
    oauth <- Some(OAuth.Parse(txt))
    printfn "Вы авторизованы! Продолжайте!"

let runBrowser (url:string) = 
    use form  = new Form(Text="VSO авторизация", WindowState = FormWindowState.Maximized)
    form.ResumeLayout(false)
    form.PerformLayout()
    
    let parseQuery (u:Uri) = HttpUtility.ParseQueryString(u.Query)
    let getCode (u:Uri) = parseQuery u |> (fun col -> match col with | n when n.AllKeys |> Array.contains "code" -> Some n.["code"] | _ -> None)
    let authorize = function
        | Some code -> 
            (form.Hide >> form.Close)()
            (accessToken code)
        | None -> None |> ignore
        
    use wb = new WebBrowser(Visible=true, Dock=DockStyle.Fill, ScriptErrorsSuppressed=true)
    form.Controls.Add(wb)
    wb.Navigated |> Event.add ((fun e -> e.Url) >> getCode >> authorize)
    wb.Navigate(url)
    form.ShowDialog() |> ignore

let query (url:string) = 
    let req = HttpWebRequest.Create(url) :?> HttpWebRequest
    if oauth.IsSome then
        req.Headers.Add("Authorization", "Bearer " + oauth.Value.AccessToken)
                    
    let join (sep:string) (arr:string[]) = String.Join(sep, arr)
    let resp = req.GetResponse() :?> HttpWebResponse;
    match resp.StatusCode with 
        | HttpStatusCode.OK -> readResponse(resp) |> Projects.Parse |> (fun p -> p.Value |> Array.map (fun x -> x.Name) |> join ", ")
        | _ -> resp.StatusCode.ToString()
        
let cleanUpCache = WebBrowserHelper.WebBrowserCleaner.ClearCache
let waitEnter = Console.ReadLine >> ignore

[<EntryPoint>]
[<System.STAThread>]
let main argv = 
    cleanUpCache ()
    printfn "Запрос без авторизации:"
    printfn "%s" <| query buildsUri
    printfn "Нажмите для авторизации"
    waitEnter ()
    let cookie = runBrowser codeQuery
    waitEnter ()
    printfn "Запрос c авторизацией"
    printfn "%s" <| query buildsUri
    waitEnter ()
    0
