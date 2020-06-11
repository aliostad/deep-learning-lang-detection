namespace Shodan.FSharp

open System
open System.Net
open FSharp.Data

open Shodan.FSharp.Configuration     
open Shodan.FSharp
open Shodan.FSharp.JsonResponse
open System.Reflection

exception ShodanError of string

type Shodan() =
    
    static let version = string <| Assembly.GetExecutingAssembly().GetName().Version in
    static let httpHeaders = [HttpRequestHeaders.UserAgent (sprintf "Win32:Shodan.FSharp:%s" version)]

    static member internal ApiRequest(apiEndpoint: Uri, query, ?method) =
        let md = defaultArg method HttpMethod.Get
        async {
            let! resp = Http.AsyncRequest(
                string apiEndpoint,
                headers=httpHeaders,
                query=("key", Settings.Shodan.SecretKey) :: query,
                httpMethod=md)

            match resp.Body with
            | Text body  when resp.StatusCode = 200 -> return body
            | Text err -> return raise (ShodanError (ErrorJson.Parse err).Error)
        }

    static member ApiInfo () = 
        async {
            let! json = Shodan.ApiRequest(WebApi.apiInfo, [])
            return ApiInfoJson.Parse json
        }

    static member AccountInfo () = 
        async {
            let! json = Shodan.ApiRequest(WebApi.accountInfo, [])
            return AccountInfoJson.Parse json
        }

type Search() =
        
    static member Info(host: IPAddress, ?history: bool, ?minify: bool) = 
        async { 
            // todo: simplify the mapping of query fields
            let query = 
                List.choose(function 
                    | name, Some flag -> Some(name, string flag)
                    | _ -> None
                ) ["history", history; "minify", minify]
                
            let! json = Shodan.ApiRequest(WebApi.Search.info host, query)
            return Search.HostInfoJson.Parse json
        }

    static member Search(query, page) =
        async { 
            let! json = Shodan.ApiRequest(WebApi.Search.search, query)
            return Search.SearchJson.Parse json
        }

    static member Tokens(query) =
        async {
            let! json = Shodan.ApiRequest(WebApi.Search.tokens, query)
            return Search.TokensJson.Parse json
        }

    static member Count(query) =
        async { 
            let! json = Shodan.ApiRequest(WebApi.Search.count, query)
            return Search.CountJson.Parse json
        }

    static member Ports () =
        async {
            let! json = Shodan.ApiRequest(WebApi.Search.ports, [])
            return Search.PortsJson.Parse json
        }

type Scan () =
    
    static member Protocols () =
        async {
            let! json = Shodan.ApiRequest(WebApi.Scan.procotols, [])
            return Scan.ProtocolsJson.Parse json
        }

    static member Scan targets =
        async {
            let! json = 
                Shodan.ApiRequest(
                    WebApi.Scan.scan,
                    ["ips", String.concat "," targets],
                    HttpMethod.Post)
            return Scan.ScanJson.Parse json
        }

    static member Internet(port, protocol) =
        async {
            let! json = 
                Shodan.ApiRequest(
                    WebApi.Scan.scanInternet,
                    ["port", string port
                     "protocol", protocol],
                    HttpMethod.Post)
            return Scan.InternetJson.Parse json
        }

    static member ScanStatus(scanId) =
        async {
            let! json = Shodan.ApiRequest(WebApi.Scan.scanId scanId, [])
            return Scan.ScanIdJson.Parse json
        }

