[<RequireQualifiedAccess>]
module FsKafka.Connection

open FsKafka.Common
open FsKafka.Protocol
open FsKafka.Protocol.Requests
open FsKafka.Protocol.Responses
open FsKafka.Logging
open FsKafka.Socket
open FsKafka.SocketClient
open System
open System.Threading
open System.Threading.Tasks
open System.Collections.Concurrent
open System.Collections.Generic

type Config =
  { MetadataBrokersList   : (string * int) list
    Log                   : Logger
    RequestTimeoutMs      : int (* this is not the same as in Producer.Config, as this should be bigger then that value to include time of receiving failed response also, so 2 or 3 times bigger is good *)
    ReconnectionAttempts  : int
    ReconnectionBackoffMs : int
    SendBufferBytes       : int }
let defaultConfig =
  { MetadataBrokersList   = []
    Log                   = defaultLogger LogLevel.Verbose
    RequestTimeoutMs      = 20000
    ReconnectionAttempts  = 5
    ReconnectionBackoffMs = 500
    SendBufferBytes       = 100 * 1024 }
  
exception FailedAddingRequestException      of unit
exception RequestTimedOutException          of unit
exception SetRequestResponseFailedException of int
exception RemoveAsyncRequestFailedException of int
exception MessageToBigException             of string

type RequestsPool(logger:Logger) =
  let verboseef e f = verboseef logger "FsKafka.RequestsPool" e f

  let correlator         = ref 0
  let nextCorrelator ()  =
    if !correlator > Int32.MaxValue - 1000
    then Interlocked.Exchange(correlator, 0) |> ignore
    Interlocked.Increment correlator
  
  let asyncRequests = ConcurrentDictionary<int, RequestMessage * TaskCompletionSource<ResponseMessage>>()
  
  let tryRemoveRequest id = async {
    match asyncRequests.TryRemove id with
    | true, (request, source) -> return Success(request, source)
    | false, _                -> return RemoveAsyncRequestFailedException id |> Failure }

  let cancelRequest correlator =
    match asyncRequests.TryRemove correlator with
    | true, (request, source) ->
        source.TrySetCanceled() |> ignore
        verboseef (RequestTimedOutException()) (fun f -> f "Request timed out correlator=%i, Request=%A" correlator request)
    | _ -> ()

  let startTimeout correlator timeout =
    let source = new CancellationTokenSource(millisecondsDelay = timeout)
    source.Token.Register(fun () -> cancelRequest correlator) |> ignore

  let tryAdd correlator request timeout =
    let completionSource = new TaskCompletionSource<ResponseMessage>()
    match asyncRequests.TryAdd(correlator, (request, completionSource)) with
    | true  -> startTimeout correlator timeout
               Async.AwaitTask completionSource.Task |> Success
    | false -> FailedAddingRequestException() |> Failure
  
  member x.NextCorrelator ()                             = nextCorrelator()
  member x.TryAdd         (correlator, request, timeout) = tryAdd correlator request timeout
  member x.TryRemove      correlator                     = tryRemoveRequest correlator

type SocketClientsPool(config:SocketClient.Config, asyncSocket: unit -> IAsyncSocket, syncSocket: unit -> ISyncSocket) =

  let clients = Dictionary<string * int, DoubleClient>()
  
  let addClients =
    Set.iter (fun (host, port) ->
      let config = { config with Host = host; Port = port }
      let client =
        { SyncClient  = lazy(new SyncClient (config, syncSocket()))
          AsyncClient = lazy(new AsyncClient(config, asyncSocket())) }
      clients.Add((host, port), client))

  let removeClients =
    Set.iter (fun e ->
      if clients.[e].AsyncClient.IsValueCreated
      then clients.[e].AsyncClient.Force().Close()
      
      if clients.[e].SyncClient.IsValueCreated
      then clients.[e].SyncClient.Force().Close()
      
      clients.Remove e |> ignore )
      
  let updateClients endpoints =
    let current = clients.Keys |> Set.ofSeq
    endpoints - current |> addClients
    current - endpoints |> removeClients
    
  member x.Update    endpoints                      = updateClients endpoints
  member x.AsyncSend (endpoint, data, readResponse) = clients.[endpoint].AsyncClient.Force().Send(data, readResponse)
  member x.Send      (endpoint, data, readResponse) = clients.[endpoint].SyncClient.Force().Send(data, readResponse)
  member x.Endpoints ()                             = clients.Keys

type T(config:Config, asyncSocket: unit -> IAsyncSocket, syncSocket: unit -> ISyncSocket) =
  let verbosef f = verbosef config.Log "FsKafka.Connection" f
  let verbosee   = verbosee config.Log "FsKafka.Connection"

  let requests = RequestsPool(config.Log)
  
  let handleResponse response = asyncResult {
    let! (_, correlator, data) = response
    let! (request, source)     = requests.TryRemove correlator
    let! response              = Optics.decode request.Message correlator data |> Result.toAsync
    match source.TrySetResult response with
    | true  -> return Success()
    | false -> return SetRequestResponseFailedException correlator |> Failure }

  let processResponse data = async {
    let! result = handleResponse data
    match result with
    | Success _ -> ()
    | Failure err -> verbosee err "failed parsing response message" }
      
  (* Brokers related *)
  
  let clientConfig =
    { Log                   = config.Log
      Codec                 = Optics.decodeInt
      ProcessResponseAsync  = processResponse
      Host                  = ""
      Port                  = 0
      ReconnectionAttempts  = config.ReconnectionAttempts
      ReconnectionBackoffMs = config.ReconnectionBackoffMs }

  let clientsPool = SocketClientsPool(clientConfig, asyncSocket, syncSocket)

  (* Send and timeout related *)
    
  let asyncSend endpoint request readResponse = async {
    let (host, port)   = endpoint
    let correlator     = requests.NextCorrelator()
    let encodedRequest = request |> Optics.withCorrelator correlator |> Optics.encode
    if encodedRequest.Length > config.SendBufferBytes
    then return sprintf "%A" request |> MessageToBigException |> Failure
    else
      let resultAwaiter =
        if readResponse
        then match requests.TryAdd(correlator, request, config.RequestTimeoutMs) with
             | Success awaiter -> Success <| Some awaiter
             | Failure error   -> Failure error
        else Success <| None

      match resultAwaiter with
      | Success awaiter ->
          let! writeResult = clientsPool.AsyncSend(endpoint, encodedRequest, readResponse)
          match writeResult with
          | Success _ ->
              verbosef (fun f -> f "Request sent: correlator=%i, Message=%A" correlator request)
              match awaiter with
              | Some awaiter -> let! result = awaiter in return Some result |> Success
              | None         -> return None |> Success
          | Failure e ->
              verbosee e (sprintf "Write correlator=%i failed to host=%s, port=%i" correlator host port)
              return Failure e
      | Failure error   ->
          verbosee error (sprintf "Write correlator=%i failed to host=%s, port=%i" correlator host port)
          return error |> Failure }
        
  let send endpoint request readResponse = Result.result {
    let correlator  = requests.NextCorrelator()
    let encodedRequest = request |> Optics.withCorrelator correlator |> Optics.encode
    let! response      = clientsPool.Send(endpoint, encodedRequest, readResponse)
    match response with
    | Some (_, correlator, data) ->
          verbosef (fun f -> f "Request sent: correlator=%i, Message=%A" correlator request)
          return! Optics.decode request.Message correlator data |> Result.map Some
    | None -> return None }
  
  let trySend request broker =
    let result = send broker request true
    match result with
    | Success(Some r) -> Some r
    | _               -> None
  
  let sendToFirstSuccessfullBroker request =
    clientsPool.Endpoints()
    |> Seq.tryPick (trySend request)

  do
    config.MetadataBrokersList
    |> Set.ofList
    |> clientsPool.Update

  member x.UpdateBrokersList brokers                         = clientsPool.Update brokers
  member x.SendAsync         (broker, request, readResponse) = asyncSend broker request readResponse
  member x.Send              (broker, request, readResponse) = send broker request readResponse
  member x.TryPick           request                         = sendToFirstSuccessfullBroker request

let create config =
  match config.MetadataBrokersList with
  | [] -> failwith "empty metadata brokers list"
  | _  -> T(config, (fun _ -> Tcp.createAsync config.Log), (fun _ -> Tcp.createSync config.Log))
