// Weitere Informationen zu F# unter "http://fsharp.org".
// Weitere Hilfe finden Sie im Projekt "F#-Tutorial".
open FSharp.Data
open System
open System.Net
open System.Net.Http
open System.Net.Http.Headers
open FSharp.Data.HttpResponseHeaders

let getCookie (response:HttpResponseMessage) = 
    let success, cookies = response.Headers.TryGetValues("set-cookie")
    if success then
        Some (cookies |> Seq.map (fun s -> (s.Split ';') |> Array.head))
    else
        None

let getUri (doc:HtmlDocument) (day:int) (title:string) =
    let selector = doc.Descendants (fun node -> (node.AttributeValue "title") = title)
    if Seq.empty = selector then
        (day, String.Empty)
    else
        (day, (selector |> Seq.head).AttributeValue "href")

let getUris (response:HttpResponseMessage) =
    let doc = HtmlDocument.Parse (response.Content.ReadAsStringAsync().Result)
    seq {
        yield getUri doc 1 "Aktueller Tag"
        yield getUri doc 2 "Folgetag"
    }

let readConfig =
    let cookieContainer = new CookieContainer()
    let handler = new HttpClientHandler()
    handler.CookieContainer <- cookieContainer
    let client = new HttpClient(handler)
    let message = new HttpRequestMessage(HttpMethod.Get |> HttpMethod, "https://verwaltung-bbs-msh.de")
    let response = client.SendAsync(message).Result
    (getCookie response, getUris response)

let extractTable (sequence:string seq) = 
    sequence
    |> Seq.skipWhile (fun x -> not (x.Contains("<table")))
    |> Seq.takeWhile (fun x -> not (x.Contains("</table")))

let (>>=) m f = Option.bind f m

let getDate (html:string) = 
    let parsableHtml = 
        html.Split([|"\r\n"|], StringSplitOptions.RemoveEmptyEntries)
        |> Array.filter (fun x -> not (x.Contains("<col")))
    let table = extractTable parsableHtml
    let res = String.Join("\r\n", table)
    let doc = HtmlDocument.Parse res
    let nodes = 
        doc.Descendants ["td"]
        |> Seq.filter (fun node -> 
            node.DirectInnerText().StartsWith("Vertretungsplan"))
    let node = nodes |> Seq.tryHead
    match node with
    | Some node -> 
        let split = node.InnerText().Split ' '
        let success, date = DateTime.TryParse split.[split.Length - 1] 
        if success then
            Some date
        else
            None
    | None -> None

let getDay (client:HttpClient) (day:int, url:string) =
    let html = client.GetStringAsync(url).Result
    getDate html

let setupHttpClient =
    let handler = new HttpClientHandler()
    handler.UseCookies <- false
    let client = new HttpClient(handler)

    let cookie, uris = readConfig
    match cookie with
    | Some c -> client.DefaultRequestHeaders.Add("Cookie", c)
    | _ -> ()

    (client, uris)

[<EntryPoint>]
let main argv = 
    let client, uris = setupHttpClient

    uris
    |> Seq.map (fun item -> (getDay client item),(item |> snd))
    |> Seq.iter (fun (day, data) -> printfn "%A %A" day data)
    //printfn "%A" uris

    0 // Integer-Exitcode zurückgeben
