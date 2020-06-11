namespace SuaveAndWebsocket

#if INTERACTIVE
  #r @"C:\Users\alessandro\GITHUB\SuaveAndWebsocket\packages\Suave.1.1.3\lib\net40\Suave.dll"
  #r @"C:\Users\alessandro\GITHUB\SuaveAndWebsocket\packages\Suave.OAuth.0.7.7\lib\net40\Suave.OAuth.dll"
  #r @"C:\Users\alessandro\GITHUB\SuaveAndWebsocket\packages\Newtonsoft.Json.9.0.1\lib\net45\Newtonsoft.Json.dll"
#endif

open Suave
open Suave.Files
open Suave.Filters
open Suave.Operators
open Suave.Successful
open Suave.RequestErrors
open Suave.Web
open Suave.Sockets
open Suave.Sockets.Control
open Suave.WebSocket
open Suave.Utils

open Suave.OAuth

open Akka.FSharp

open Newtonsoft

open System
open System.Net

module Webserver=
  let L (msg: string)=
    Console.WriteLine (msg)
  
  let echo (ws:WebSocket)=
    //Create Actors to send and receive msg
    //---------------------------------------
    let arefSend=ActorManager.createActor "send" (ActorManager.processFunSend ws)
    let arefReceive=ActorManager.createActor "receive" (ActorManager.processFunReceive arefSend)

    //Manage socket
    //-------------------
    fun ctx -> socket {
        let mutable loop=true
        while loop do
            let! res=ws.read()
            match res with
            | Text, data, true -> 
                L ("Data Received: " + ASCII.toString data)
                //do! ws.send Text data true
                let msg=ActorManager.Message.Msg {From="Unknow";To="Unknow";Msg=ASCII.toString data}
                arefReceive <! msg
                //arefReceive <! 
            | Close,_,_        -> 
                L  "Received Close Request"
                //Kill actor
                arefReceive <! Akka.Actor.PoisonPill.Instance
                arefSend <! Akka.Actor.PoisonPill.Instance
                do! ws.send Close [||] true
                loop <- false
            | _               
                               -> ()
      }

  //OAuth2 Config
  //----------------------------------------------------------------
  type Credential={client_id:string; client_secret:string}

  let getCredential()=
    let file= [|__SOURCE_DIRECTORY__;"cred.txt"|] |> System.IO.Path.Combine 
    match (file |> System.IO.File.Exists) with
    | true ->
      let c=file |> System.IO.File.ReadAllText
      let cred=Json.JsonConvert.DeserializeObject<Credential>(c)
      L (sprintf "Find credential file with client_id=%s... and client_secret=%s..." (cred.client_id.Substring(0,5)) (cred.client_secret.Substring(0,5)))
      Some (cred)
    | false ->
        L "No cred.txt file found!!"  
        None 

  let oauthConfigs =
    match getCredential() with
    | Some (cred) ->
        defineProviderConfigs (function
            | "google" -> fun c ->
                {c with
                    scopes="profile email"
                    client_id = cred.client_id
                    client_secret = cred.client_secret}
            | _ -> id)

    | None -> Map.empty
    
  //Login url
  //http://localhost:8083/oaquery?provider=google
  let InitOauth ctx=
     let authorizeRedirectUri = buildLoginUrl ctx
     OAuth.authorize authorizeRedirectUri oauthConfigs 
      (fun loginData -> 
        sprintf "Name=%s - email=%A" loginData.Name loginData.ProviderData |> L
        Redirection.FOUND "/")
      (fun () -> Redirection.found "/")
      (fun error -> "Authorization failed because "+error.Message |> OK)  
  //----------------------------------------------------------------

  //test warbler ... just for fun!
  let f ctx=
    fun ctx2->
      L (sprintf "IP=%O" ctx2.connection.ipAddr)
      succeed  ctx2

  //Start web server
  //-------------------
  let StartServer port webRoot=
    let config={defaultConfig with
                    bindings=[HttpBinding.mk HTTP IPAddress.Loopback (uint16 port)]
               }
    let app=choose [
              //Html files
              GET >=> choose [
                  path "/" >=> browseFile webRoot @"\view\index.html"                
                  path "/index" >=> browseFile webRoot @"\view\index.html"                
              ]
              //Js files
              GET >=> choose [
                  pathScan "/node_modules/%s" ((fun s -> sprintf @"\js\node_modules\%s" s) >> browseFile webRoot)
                  pathScan "/out/%s" ((fun s -> sprintf @"\js\out\%s" s) >> browseFile webRoot)
              ]

              //Init Authorization
              warbler InitOauth

              //NOTE: if this get enable the chain will always stop here and we will not be able to access further WebPArt!!!!!              
              //warbler f 

              GET >=> path "/index2" >=> OK "Test"

              OAuth.protectedPart 
                (choose [
                  //WebSocket
                  GET >=> path "/echo" >=> handShake echo
                  ])
                (RequestErrors.FORBIDDEN "You don't have right to access this area. Please login first!")

              NOT_FOUND "NOT FOUND"
            ]   

    #if INTERACTIVE
      //Login url: /oalogin?provider=google

      let app=choose [
              //Init Authorization
              warbler InitOauth
              
              GET >=> path "/index2" >=> OK "Test"

              OAuth.protectedPart 
                (choose [
                  //WebSocket
                  GET >=> path "/protected" >=> OK "PROTECTED!!"
                  ])
                (RequestErrors.FORBIDDEN "You don't have right to access this area. Please login first!")

              NOT_FOUND "NOT FOUND"
            ]
     #endif 

//    let _,server=startWebServerAsync config app
//    let cts=new System.Threading.CancellationTokenSource()
//    Async.Start server,cts.Token

    startWebServer config app