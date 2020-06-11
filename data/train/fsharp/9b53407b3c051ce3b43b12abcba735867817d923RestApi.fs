module RestApi

open System
open System.Net
open System.Text
open System.IO

open Json

let enableApiNgDebugLogs = Concurency.atom (fun () -> false)

[<AutoOpen>]
module private Helpers =
    let formatPrety = Json.formatWith JsonFormattingOptions.Pretty
    let formatCompact = Json.formatWith JsonFormattingOptions.Compact
    let (|P|_|) k = prop k


let makeRequest (apiurl : string ) json = 
    ServicePointManager.Expect100Continue <- false
    let request = HttpWebRequest.Create apiurl :?> HttpWebRequest
    request.Method <- "POST"
    request.ContentType <- "application/json"
    request.Headers.Add(HttpRequestHeader.AcceptCharset, "UTF-8")
    request.Accept <- "application/json"
    let requestString = formatCompact json
    let requestData = Encoding.UTF8.GetBytes requestString
    request.ContentLength <- int64 requestData.Length 
    

    let sendAndGetResponse = async{
        use stream = request.GetRequestStream()    
        let! n = stream.AsyncWrite(requestData, 0, requestData.Length)        
        let response = request.GetResponse()
        use stream = response.GetResponseStream()
        use reader = new StreamReader(stream, Encoding.UTF8)

        let! responseString = Async.AwaitTask ( reader.ReadToEndAsync() ) 
        return Json.parse responseString, response  }
    request, sendAndGetResponse

type ApiService = 
    {   ApiUrl : string   
        ApiMethod : string }
    static member what x = 
        sprintf "url : %A, method : %A" x.ApiUrl x.ApiMethod

[<AutoOpen>]
module private Helpers1 =
    let makeArgs service args =        
        Json.obj 
            [   "jsonrpc", String "2.0"
                "method", String service.ApiMethod
                "params", args 
                "id", Number 1m ]

    let (|ApiError|_|) = function 
        | P "error" 
           (P "data" 
             (P "exceptionname" 
               (String exceptionname) & 
                 (P "errorCode" ( String errorCode) ) &
                 (P "errorDetails" ( String errorDetails) ) )) ->
            Some(exceptionname, errorCode, errorDetails)
        | _ -> None

type Auth1 = { 
    SessionToken : string
    AppKey : string option }

    
let callUntyped auth service requestArgsJson = 
    let requestJson = 
        Json.obj         
            [   "jsonrpc", String "2.0"
                "method", String service.ApiMethod
                "params", requestArgsJson
                "id", Number 1m ]

    catchInetErrors <| async {        
        let headers = 
            [   match auth.AppKey with
                | None -> ()
                | Some x -> yield "X-Application", x
                yield "X-Authentication", auth.SessionToken ]

        let request, sendAndGetResponse =  makeRequest service.ApiUrl requestJson        
        request.Headers.Add("X-Authentication", auth.SessionToken)
        match auth.AppKey with
        | None -> ()
        | Some x -> request.Headers.Add("X-Application",x)

        
        let! (xresponseJson,_) = sendAndGetResponse 
        if enableApiNgDebugLogs.Value() then
            let level,s = 
                match xresponseJson with 
                | Err error -> Logging.Error, "no answer"
                | Ok json -> Logging.Debug, formatPrety json
            Logging.write level "rest api - %A, %A, %s -> %s" auth service (formatPrety requestJson) s

        return 
            xresponseJson 
            |> Result.bind ( fun responseJson -> 
                match responseJson with 
                | ApiError (exceptionname, errorCode, errorDetails) ->                     
                    Err <| sprintf "%A, exceptionname - %A, errorCode - %A " errorDetails exceptionname errorCode
                | P "result" json -> Ok json
                | _ -> Err <| sprintf "missing property \"result\", request %A response %A" (Json.stringify requestJson) (Json.stringify responseJson) )
            |> Result.mapErr (fun error -> 
                sprintf "rest api error, service %A, %s" (ApiService.what service) error  ) }


    

let callWithoutAppKey sessionToken service requestArgsJson =
    callUntyped { SessionToken = sessionToken; AppKey = None} service requestArgsJson

type Auth = { 
    SessionToken : string
    AppKey : string }


let callWithAppKey auth service requestArgsJson =
    callUntyped { SessionToken = auth.SessionToken; AppKey = Some auth.AppKey} service requestArgsJson

let call<'Req, 'Resp, 'T> auth service (parseResult : 'Resp -> Result<'T,string> ) (request : 'Req )  = 
    
    callUntyped {SessionToken = auth.SessionToken; AppKey = Some auth.AppKey} 
        service 
        (Json.Serialization.serialize<'Req> request)     
    |> Result.Async.bind ( fun json -> 
        Json.Serialization.deserialize<'Resp> json
        |> Result.mapErr ( sprintf "rest api : error deserealizing response, %A, %A - %s" auth service )
        |> Result.bind ( fun r -> 
            parseResult r
            |> Result.mapErr
                ( sprintf "rest api : error parsing result, %A, %A, %s - %s" auth service (formatPrety json ) ) )
        |> Async.return' ) 

let callForType<'a> auth service request : Async<Result<'a,string>> = call auth service Ok request

    
    

