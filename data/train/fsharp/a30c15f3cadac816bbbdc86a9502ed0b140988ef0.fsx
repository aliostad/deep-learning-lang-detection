open System
open FSharp.Data
open System.Net
open System.IO
open System.Net.Http
open System.Diagnostics
open System.Text.RegularExpressions

module DownloadHelpers =

    type DataOrError = 
    | Error of Error
    | Data of String

    let buildRequest(url:String, httpMethod:String) = 
        let request = new HttpRequestMessage(new HttpMethod(httpMethod), url)
        request.Headers.UserAgent.ParseAdd("(compatible; MSIE 10.6; Windows NT 6.1; Trident/5.0; InfoPath.2; SLCC1; .NET CLR 3.0.4506.2152; .NET CLR 3.5.30729; .NET CLR 2.0.50727) 3gpp-gba UNTRUSTED/1.0");
        request

    let downloadPageByRequest(request:HttpRequestMessage) = async {
        let handler = new HttpClientHandler()
        handler.UseCookies <- false
        let client = new HttpClient(handler)
        try
            use! response = Async.AwaitTask <| client.SendAsync(request)
            let resultCode = response.StatusCode.ToString();
            let! html = Async.AwaitTask <| response.Content.ReadAsStringAsync();
            let processedHtml = Regex.Replace(html, @"\</\d+\>", "") // F# data bug
            return Data processedHtml 
        with ex -> 
                Debug.WriteLine(ex.ToString())
                return Error (Error.Exception ex)
    }

    let downloadPage(url:System.String) = async {
        return! downloadPageByRequest(buildRequest(url, HttpMethod.Get))
    }