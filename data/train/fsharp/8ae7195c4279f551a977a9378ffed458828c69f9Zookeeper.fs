namespace Franz.Zookeeper

#nowarn "40"

open Franz.Stream
open Franz.Internal
open System.IO
open System.Threading
open Franz
open Franz.Internal.ErrorHandling
open System
open System.Collections.Concurrent
open System.Runtime.Serialization.Json
open System.Runtime.Serialization
open System.Collections.Generic

/// The type of the Zookeeper request
type RequestType = 
    /// Close connection
    | Close = -11
    /// Ping
    | Ping = 11
    /// Get node children
    | GetChildren2 = 12
    /// Get node data
    | GetData = 4

/// Zookeeper error codes
type ErrorCode = 
    | Ok = 0
    | SystemError = -1
    | RuntimeInconsistency = -2
    | DataInconsistency = -3
    | ConnectionLoss = -4
    | MarshallingError = -5
    | Unimplemented = -6
    | OperationTimeout = -7
    | BadArguments = -8
    | ApiError = -100
    | NoNode = -101
    | NoAuth = -102
    | BadVersion = -103
    | NoChildrenForEphemerals = -108
    | NodeExists = -110
    | NotEmpty = -111
    | SessionExpired = -112
    | InvalidCallback = -113
    | InvalidAcl = -114
    | AuthFailed = -115
    | SessionMoved = -116

/// Transaction id
type Xid = int

/// Zookeeper transaction id
type Zxid = int64

type Time = int64

/// Transaction id constants
module XidConstants = 
    /// Ping transaction id
    [<Literal>]
    let Ping : Xid = -2
    
    /// Notification transaction id
    [<Literal>]
    let Notification : Xid = -1

type ConnectResponse(protocolVersion : int, timeout : int, sessionId : int64, password : byte array) = 
    member __.ProtocolVersion = protocolVersion
    
    /// The session timeout
    member __.Timeout = timeout
    
    /// The session id
    member __.SessionId = sessionId
    
    /// The session password
    member __.Password = password
    
    static member Deserialize(stream) = 
        stream
        |> BigEndianReader.ReadInt32
        |> ignore
        let protocolVersion = stream |> BigEndianReader.ReadInt32
        let timeout = stream |> BigEndianReader.ReadInt32
        let sessionId = stream |> BigEndianReader.ReadInt64
        let password = stream |> BigEndianReader.ReadBytes
        new ConnectResponse(protocolVersion, timeout, sessionId, password)

/// The reply header available in all responses except the connect response
type ReplyHeader(xid : Xid, zxid : Zxid, error : ErrorCode) = 
    
    /// The transaction id
    member __.Xid = xid
    
    /// The zookeeper transaction id
    member __.Zxid = zxid
    
    /// The error code
    member __.Error = error
    
    static member Deserialize(stream) = 
        new ReplyHeader(stream |> BigEndianReader.ReadInt32, stream |> BigEndianReader.ReadInt64, 
                        stream
                        |> BigEndianReader.ReadInt32
                        |> enum<ErrorCode>)

/// Node statistics
type Stat = 
    { CreatedZxid : Zxid
      LastModifiedZxid : Zxid
      CreatedTime : Time
      ModifiedTime : Time
      Version : int
      ChildVersion : int
      AclVersion : int
      EphemeralOwner : int64
      DataLength : int
      NumberOfChildren : int
      LastModifiedChildrenZxid : Zxid }
    static member Deserialize(stream) = 
        { CreatedZxid = stream |> BigEndianReader.ReadInt64
          LastModifiedZxid = stream |> BigEndianReader.ReadInt64
          CreatedTime = stream |> BigEndianReader.ReadInt64
          ModifiedTime = stream |> BigEndianReader.ReadInt64
          Version = stream |> BigEndianReader.ReadInt32
          ChildVersion = stream |> BigEndianReader.ReadInt32
          AclVersion = stream |> BigEndianReader.ReadInt32
          EphemeralOwner = stream |> BigEndianReader.ReadInt64
          DataLength = stream |> BigEndianReader.ReadInt32
          NumberOfChildren = stream |> BigEndianReader.ReadInt32
          LastModifiedChildrenZxid = stream |> BigEndianReader.ReadInt64 }

/// The get children response
type GetChildrenResponse(header : ReplyHeader, children : string array, stat : Stat) = 
    
    /// The name of the children
    member __.Children = children
    
    /// The node statistics
    member __.Stat = stat
    
    /// The reply header
    member __.Header = header
    
    static member private ReadChildren list count stream : string list = 
        match count with
        | 0 -> list
        | _ -> 
            let child = stream |> BigEndianReader.ReadZKString
            GetChildrenResponse.ReadChildren (child :: list) (count - 1) stream
    
    static member Deserialize(replyHeader, stream) = 
        let numberOfChildren = stream |> BigEndianReader.ReadInt32
        let children = GetChildrenResponse.ReadChildren [] numberOfChildren stream
        new GetChildrenResponse(replyHeader, children |> List.toArray, stream |> Stat.Deserialize)

/// The ping response
type PingResponse(header : ReplyHeader) = 
    
    /// The reply header
    member __.Header = header
    
    static member Deserialize(replyHeader, _) = new PingResponse(replyHeader)

/// The get data response
type GetDataResponse(header : ReplyHeader, data : byte array) = 
    
    /// The reply header
    member __.Header = header
    
    /// The node data
    member __.Data = data
    
    static member Deserialize(replyHeader, stream) = 
        let data = stream |> BigEndianReader.ReadBytes
        new GetDataResponse(replyHeader, data)

/// The notification event type
type EventType = 
    | None = -1
    | NodeCreated = 1
    | NodeDeleted = 2
    | NodeDataChanged = 3
    | NodeChildrenChanged = 4

/// Response received when a notification is triggered
type WatcherEvent(header : ReplyHeader, eventType : EventType, state : int, path : string) = 
    
    /// The reply header
    member __.Header = header
    
    /// The event type
    member __.EventType = eventType
    
    member __.State = state
    
    /// The path notified about
    member __.Path = path
    
    static member Deserialize(replyHeader, stream : Stream) = 
        let eventType = stream |> BigEndianReader.ReadInt32
        let state = stream |> BigEndianReader.ReadInt32
        let path = stream |> BigEndianReader.ReadZKString
        new WatcherEvent(replyHeader, eventType |> enum<EventType>, state, path)

type IRequest = 
    abstract Serialize : Xid -> byte array

/// Header available in all requests
[<AbstractClass; Sealed>]
type RequestHeader() = 
    static member Serialize(xid : Xid, requestType : RequestType) = 
        let ms = new MemoryStream()
        ms |> BigEndianWriter.WriteInt32 xid
        ms |> BigEndianWriter.WriteInt32(requestType |> int)
        ms.Seek(0L, SeekOrigin.Begin) |> ignore
        let size = ms.Length |> int
        let buffer = Array.zeroCreate (size)
        ms.Read(buffer, 0, size) |> ignore
        buffer

/// Ping request
type PingRequest() = 
    
    member __.Serialize(_) = 
        let ms = new MemoryStream()
        ms |> BigEndianWriter.WriteInt32 0
        BigEndianWriter.Write ms (RequestHeader.Serialize(XidConstants.Ping, RequestType.Ping))
        let size = int32 ms.Length
        ms.Seek(0L, SeekOrigin.Begin) |> ignore
        ms |> BigEndianWriter.WriteInt32(size - 4)
        ms.Seek(0L, SeekOrigin.Begin) |> ignore
        let buffer = Array.zeroCreate (size)
        ms.Read(buffer, 0, size) |> ignore
        buffer
    
    interface IRequest with
        member self.Serialize(xid) = self.Serialize(xid)

/// Connect request
type ConnectRequest(protocolVersion, lastZxid, timeout, sessionId, password) = 
    member val ProtocolVersion = protocolVersion
    
    /// The last Zookeeper transaction id seen by the client
    member val LastZxid = lastZxid
    
    /// The session timeout
    member val Timeout = timeout
    
    /// The session id, should be zero on initial request, on reconnect it should be the last session id used
    member val SessionId = sessionId
    
    /// The session password, should be an empty array on initial request, on reconect previous password should be provided
    member val Password = password
    
    member self.Serialize(_) = 
        let ms = new MemoryStream()
        ms |> BigEndianWriter.WriteInt32 0
        ms |> BigEndianWriter.WriteInt32 self.ProtocolVersion
        ms |> BigEndianWriter.WriteInt64 self.LastZxid
        ms |> BigEndianWriter.WriteInt32 self.Timeout
        ms |> BigEndianWriter.WriteInt64 self.SessionId
        ms |> BigEndianWriter.WriteBytes self.Password
        let size = int32 ms.Length
        ms.Seek(0L, SeekOrigin.Begin) |> ignore
        ms |> BigEndianWriter.WriteInt32(size - 4)
        ms.Seek(0L, SeekOrigin.Begin) |> ignore
        let buffer = Array.zeroCreate (size)
        ms.Read(buffer, 0, size) |> ignore
        buffer
    
    interface IRequest with
        member self.Serialize(xid) = self.Serialize(xid)

/// Get children request
type GetChildrenRequest(path : string, watch : bool) = 
    
    /// The node path
    member __.Path = path
    
    /// True if we should subscribed to notifications
    member __.Watch = watch
    
    member __.Serialize(xid) = 
        let ms = new MemoryStream()
        ms |> BigEndianWriter.WriteInt32 0
        BigEndianWriter.Write ms (RequestHeader.Serialize(xid, RequestType.GetChildren2))
        ms |> BigEndianWriter.WriteZKString path
        ms |> BigEndianWriter.WriteInt8((if watch then 1
                                         else 0)
                                        |> int8)
        let size = int32 ms.Length
        ms.Seek(0L, SeekOrigin.Begin) |> ignore
        ms |> BigEndianWriter.WriteInt32(size - 4)
        ms.Seek(0L, SeekOrigin.Begin) |> ignore
        let buffer = Array.zeroCreate (size)
        ms.Read(buffer, 0, size) |> ignore
        buffer
    
    interface IRequest with
        member self.Serialize(xid) = self.Serialize(xid)

/// Get data request
type GetDataRequest(path : string, watch : bool) = 
    
    /// The node path
    member __.Path = path
    
    member __.Serialize(xid) = 
        let ms = new MemoryStream()
        ms |> BigEndianWriter.WriteInt32 0
        BigEndianWriter.Write ms (RequestHeader.Serialize(xid, RequestType.GetData))
        ms |> BigEndianWriter.WriteZKString path
        ms |> BigEndianWriter.WriteInt8((if watch then 1
                                         else 0)
                                        |> int8)
        let size = int32 ms.Length
        ms.Seek(0L, SeekOrigin.Begin) |> ignore
        ms |> BigEndianWriter.WriteInt32(size - 4)
        ms.Seek(0L, SeekOrigin.Begin) |> ignore
        let buffer = Array.zeroCreate (size)
        ms.Read(buffer, 0, size) |> ignore
        buffer
    
    interface IRequest with
        member self.Serialize(xid) = self.Serialize(xid)

/// Intermediate type containing a response's header and content
type ResponsePacket = 
    { Content : Stream
      Header : ReplyHeader }

/// Wathcer type
type WatcherType = 
    private
    /// Child watcher
    | Child
    /// Data watcher
    | Data

/// Contains information about a watcher
type Watcher = 
    { /// The watched node path
      Path : string
      /// The notification callback
      Callback : unit -> unit
      /// The watcher type
      Type : WatcherType }
    /// Reregister the watcher
    member internal self.Reregister(agent : Agent<ZookeeperMessages>) = 
        match self.Type with
        | Child -> agent.PostAndReply(fun reply -> GetChildrenWithWatcher(self, reply))
        | Data -> agent.PostAndReply(fun reply -> GetDataWithWatcher(self, reply))
        |> either (Async.Ignore >> Async.Start) 
               (fun x -> 
               LogConfiguration.Logger.Error.Invoke(sprintf "Could not reregister watcher for %s" self.Path, x))

and ZookeeperMessages = 
    private
    | Connect of string * int * int * AsyncReplyChannel<Result<unit, exn>>
    | GetChildrenWithWatcher of Watcher * AsyncReplyChannel<Result<Async<ResponsePacket>, exn>>
    | GetChildren of string * AsyncReplyChannel<Result<Async<ResponsePacket>, exn>>
    | Ping
    | GetData of string * AsyncReplyChannel<Result<Async<ResponsePacket>, exn>>
    | GetDataWithWatcher of Watcher * AsyncReplyChannel<Result<Async<ResponsePacket>, exn>>
    | Reconnect of TcpClient.T
    | Dispose

/// Intermediate request type
type RequestPacket(xid) = 
    let mutable response = None
    let waiter = new System.Threading.ManualResetEventSlim()
    
    /// The transaction id
    member __.Xid = xid
    
    /// Get the response async
    member __.GetResponseAsync(timeout : int) = 
        async { 
            let success = waiter.Wait(timeout)
            if not success then failwith "Response not received in time"
            return response.Value
        }
    
    member internal __.ResponseReceived(packet) = 
        response <- Some packet
        waiter.Set()

type private Pinger = 
    { Body : Async<unit>
      CancellationTokenSource : CancellationTokenSource }

type private State = 
    { TcpClient : TcpClient.T
      SessionId : int64
      Password : byte array
      LastXid : Xid
      SessionTimeout : int
      Receiver : Async<unit> option
      Pinger : Pinger option }

/// Zookeeper exception
type ZookeeperException(msg : string) = 
    inherit Exception(msg)

/// Zookeeper client. Handle the communication with a single Zookeeper instance
[<AllowNullLiteral>]
type ZookeeperClient(connectionLossCallback : Action) = 
    let mutable disposed = false
    
    let deserialize f (response : ResponsePacket) = 
        if response.Header.Error = ErrorCode.Ok then f (response.Header, response.Content)
        else raise (ZookeeperException(sprintf "Got error %A" response.Header.Error))
    
    let createPinger sessionTimeout (agent : Agent<ZookeeperMessages>) = 
        let cts = new CancellationTokenSource()
        
        let body = 
            async { 
                while not cts.Token.IsCancellationRequested do
                    do! Async.Sleep(sessionTimeout / 2)
                    if cts.Token.IsCancellationRequested then return ()
                    else agent.Post(Ping)
            }
        body |> Async.Start
        { Body = body
          CancellationTokenSource = cts }
    
    let childWatchers = new ConcurrentDictionary<string, Watcher>()
    let dataWatchers = new ConcurrentDictionary<string, Watcher>()
    
    let agent = 
        Agent.Start(fun inbox -> 
            let lastZxid = ref 0L
            let pendingRequests = new ConcurrentQueue<RequestPacket>()
            
            let sendNewRequest (request : IRequest) state = 
                let xid = state.LastXid + 1
                let requestPacket = new RequestPacket(xid)
                pendingRequests.Enqueue(requestPacket)
                state.TcpClient
                |> TcpClient.write (request.Serialize(xid))
                |> ignore
                ({ state with LastXid = xid }, requestPacket.GetResponseAsync(state.SessionTimeout))
            
            let tryToOption (success, x) = 
                if success then Some x
                else None
            
            let rec receive (stream : Stream) = 
                let responseSize = stream |> BigEndianReader.ReadInt32
                let ms = new MemoryStream(stream |> BigEndianReader.Read responseSize)
                let header = ms |> ReplyHeader.Deserialize
                let (success, request) = pendingRequests.TryDequeue()
                if not success && header.Xid <> XidConstants.Ping && header.Xid <> XidConstants.Notification then 
                    raise (new IOException(sprintf "Nothing in queue, but got xid %i" header.Xid))
                if header.Zxid > 0L then Interlocked.Increment(lastZxid) |> ignore
                match header.Xid with
                | XidConstants.Ping -> LogConfiguration.Logger.Trace.Invoke("Got ping response")
                | XidConstants.Notification -> 
                    let response = WatcherEvent.Deserialize(header, ms)
                    
                    let watcher, suppress = 
                        match response.EventType with
                        | EventType.NodeChildrenChanged -> 
                            (childWatchers.TryGetValue(response.Path) |> tryToOption, false)
                        | EventType.NodeDataChanged -> (dataWatchers.TryGetValue(response.Path) |> tryToOption, false)
                        | EventType.NodeDeleted | EventType.NodeCreated -> (None, true)
                        | _ -> 
                            LogConfiguration.Logger.Warning.Invoke("Got unsupported notification", null)
                            (None, false)
                    match watcher with
                    | Some x -> 
                        x.Reregister(inbox)
                        x.Callback()
                    | None when not suppress -> 
                        LogConfiguration.Logger.Warning.Invoke
                            (sprintf "Got notification for '%A', but cannot find a matching watcher" response.Path, null)
                    | _ -> ()
                | x when x = request.Xid -> 
                    LogConfiguration.Logger.Trace.Invoke(sprintf "Received with xid %i" header.Xid)
                    { Header = header
                      Content = ms }
                    |> request.ResponseReceived
                | _ -> raise (new IOException(sprintf "Xid out of order. Got %i expected %i" header.Xid request.Xid))
                receive stream
            
            let replyEither (reply : AsyncReplyChannel<Result<'a, exn>>) oldState result : State = 
                match result with
                | Success(state, x) -> 
                    reply.Reply(x |> succeed)
                    state
                | Failure x -> 
                    reply.Reply(x |> fail)
                    oldState
            
            let sendConnectRequest sessionTimeout sessionId password state = 
                let request = new ConnectRequest(0, lastZxid.Value, sessionTimeout, sessionId, password)
                
                let response = 
                    state.TcpClient
                    |> TcpClient.write (request.Serialize(-1))
                    |> TcpClient.read ConnectResponse.Deserialize
                
                let pinger = inbox |> createPinger sessionTimeout
                
                let receiver = 
                    async { 
                        try 
                            do receive state.TcpClient.Stream.Value
                        with _ -> 
                            pinger.CancellationTokenSource.Cancel()
                            inbox.Post(Reconnect(state.TcpClient))
                    }
                receiver |> Async.Start
                { state with SessionId = response.SessionId
                             Password = response.Password
                             SessionTimeout = sessionTimeout
                             Receiver = Some receiver
                             Pinger = Some pinger }
            
            let connect host port sessionTimeout state = 
                { state with TcpClient = state.TcpClient |> TcpClient.connectTo host port } 
                |> sendConnectRequest sessionTimeout (int64 0) (Array.zeroCreate (16))
            
            let getChildren path watcher state = 
                let shouldWatch = watcher |> Option.isSome
                
                let request = new GetChildrenRequest(path, shouldWatch)
                if shouldWatch then childWatchers.TryAdd(path, watcher.Value) |> ignore
                sendNewRequest request state
            
            let getChildrenWithoutWatcher path = getChildren path None
            
            let getData path watcher state = 
                let shouldWatch = watcher |> Option.isSome
                
                let request = new GetDataRequest(path, shouldWatch)
                if shouldWatch then dataWatchers.TryAdd(path, watcher.Value) |> ignore
                sendNewRequest request state
            
            let getDataWithoutWatcher path = getData path None
            
            let ping state = 
                state.TcpClient
                |> TcpClient.write ((new PingRequest()).Serialize(XidConstants.Ping))
                |> ignore
            
            let reconnect (oldClient : TcpClient.T) state = 
                if not <| oldClient.Client.Equals(state.TcpClient.Client) then 
                    LogConfiguration.Logger.Trace.Invoke("Not reconnecting as state has changed since requested")
                    state
                else 
                    let reconnect state = 
                        let newClient = state.TcpClient |> TcpClient.reconnect
                        sendConnectRequest state.SessionTimeout state.SessionId state.Password 
                            { state with TcpClient = newClient }
                    catch reconnect state |> either id (fun x -> 
                                                 LogConfiguration.Logger.Error.Invoke("Could not reconnect", x)
                                                 connectionLossCallback.Invoke()
                                                 state)
            
            let rec loop state = 
                async { 
                    let! msg = inbox.Receive()
                    match msg with
                    | Connect(host, port, sessionTimeout, reply) -> 
                        return! loop (catch (connect host port sessionTimeout) state |> either (fun newState -> 
                                                                                            reply.Reply(() |> succeed)
                                                                                            newState) (fun x -> 
                                                                                            reply.Reply(x |> fail)
                                                                                            state))
                    | GetChildrenWithWatcher(watcher, reply) -> 
                        return! loop (catch (getChildren watcher.Path (Some watcher)) state |> replyEither reply state)
                    | GetChildren(path, reply) -> 
                        return! loop (catch (getChildrenWithoutWatcher path) state |> replyEither reply state)
                    | Ping -> 
                        return! loop (catch ping state |> either (fun () -> state) (fun x -> 
                                                              LogConfiguration.Logger.Error.Invoke("Could not ping", x)
                                                              state))
                    | GetData(path, reply) -> 
                        return! loop (catch (getDataWithoutWatcher path) state |> replyEither reply state)
                    | GetDataWithWatcher(watcher, reply) -> 
                        return! loop (catch (getData watcher.Path (Some watcher)) state |> replyEither reply state)
                    | Reconnect oldClient -> return! loop (reconnect oldClient state)
                    | Dispose -> ()
                }
            
            loop { TcpClient = TcpClient.create()
                   SessionId = 0L
                   Password = Array.empty
                   LastXid = 0
                   SessionTimeout = 0
                   Receiver = None
                   Pinger = None })
    
    let handleAsyncReply fSuccess (result : Result<Async<'a>, exn>) = 
        match result with
        | Success x -> 
            x
            |> Async.RunSynchronously
            |> fSuccess
        | Failure x -> raise (new Exception(x.Message, x))
    
    do agent.Error.Add(fun x -> LogConfiguration.Logger.Fatal.Invoke("Got exception in zookeeper agent", x))
    
    /// Connect to the provided Zookeeper instance
    member __.Connect(endpoint : EndPoint, sessionTimeout) = 
        if disposed then invalidOp "Client has been disposed"
        let result = agent.PostAndReply(fun reply -> Connect(endpoint.Address, endpoint.Port, sessionTimeout, reply))
        match result with
        | Failure x -> raise x
        | Success _ -> ()
    
    /// Get node children and subscribe to notifications about the node children
    member __.GetChildren(path, watcherCallback) = 
        if disposed then invalidOp "Client has been disposed"
        let watcher = 
            { Path = path
              Callback = watcherCallback
              Type = Child }
        agent.PostAndReply(fun reply -> GetChildrenWithWatcher(watcher, reply)) 
        |> handleAsyncReply (deserialize GetChildrenResponse.Deserialize)
    
    /// Get node children
    member __.GetChildren(path) = 
        if disposed then invalidOp "Client has been disposed"
        agent.PostAndReply(fun reply -> GetChildren(path, reply)) 
        |> handleAsyncReply (deserialize GetChildrenResponse.Deserialize)
    
    /// Get the node data
    member __.GetData(path) = 
        if disposed then invalidOp "Client has been disposed"
        agent.PostAndReply(fun reply -> GetData(path, reply)) 
        |> handleAsyncReply (deserialize GetDataResponse.Deserialize)
    
    /// Get the node data and subscribe to data change notification
    member __.GetData(path, watcherCallback) = 
        if disposed then invalidOp "Client has been disposed"
        let watcher = 
            { Path = path
              Callback = watcherCallback
              Type = Data }
        agent.PostAndReply(fun reply -> GetDataWithWatcher(watcher, reply)) 
        |> handleAsyncReply (deserialize GetDataResponse.Deserialize)
    
    /// Gets the child watchers
    member __.ChildWatchers = childWatchers.Values |> Seq.map id
    
    /// Gets the data watchers
    member __.DataWatchers = dataWatchers.Values |> Seq.map id
    
    interface IDisposable with
        member __.Dispose() = 
            if not disposed then 
                agent.Post(Dispose)
                disposed <- true

module private JsonHelper = 
    let settings = 
        let s = new DataContractJsonSerializerSettings()
        s.UseSimpleDictionaryFormat <- true
        s
    
    let fromJson<'a> (data : byte array) = 
        let serializer = new DataContractJsonSerializer(typeof<'a>, settings)
        use ms = new MemoryStream(data)
        let obj = serializer.ReadObject(ms)
        obj :?> 'a

/// Kafka broker registration information
[<CLIMutableAttribute; DataContractAttribute>]
type BrokerRegistrationInformation = 
    { [<IgnoreDataMemberAttribute>]
      Id : int
      [<DataMember(Name = "version")>]
      Version : int
      /// Hostname of the broker
      [<DataMember(Name = "host")>]
      Host : string
      /// Port of the broker
      [<DataMember(Name = "port")>]
      Port : int
      /// Endpoints the broker are listening to
      [<DataMember(Name = "endpoints")>]
      Endpoints : string array }

/// Topic registration information
[<CLIMutableAttribute; DataContractAttribute>]
type TopicRegistrationInformation = 
    { [<DataMember(Name = "version")>]
      Version : int
      /// The partitions available to the topic, and which brokers that contains them
      [<DataMember(Name = "partitions")>]
      Partitions : IDictionary<string, int array> }

/// Topic partition state information
[<CLIMutableAttribute; DataContractAttribute>]
type TopicPartitionState = 
    { [<DataMember(Name = "version")>]
      Version : int
      /// The brokers which have insync replicas of the partition
      [<DataMember(Name = "isr")>]
      Isr : int array
      /// The leader of the partition
      [<DataMember(Name = "leader")>]
      Leader : int }

/// Zookeeper manager
///
/// Connect to the Zookeeper cluster defined by the provided Zookeeper instances. If a connection to an instance is lost
/// a connection to one of the other instances is made. If unable to connect to any of the instances in the cluster,
/// the ConnectionLost event is raised and should be handle by the user.
type ZookeeperManager(endpoints : EndPoint seq, sessionTimeout : int) = 
    let brokerIdsPath = "/brokers/ids"
    let topicsPath = "/brokers/topics"
    let mutable client : ZookeeperClient = null
    let mutable disposed = false
    let connectionLostEvent = new Event<_>()
    let numberOfEndpoints = endpoints |> Seq.length
    
    let endpointSeq = 
        endpoints
        |> Seq.toArray
        |> Array.shuffle
        let rec innerSeq = 
            seq { 
                for x in endpoints do
                    yield x
                yield! innerSeq
            }
        innerSeq
    
    let connectionLost fConnect = 
        LogConfiguration.Logger.Info.Invoke("Lost connection to zookeeper, trying to reconnect...")
        (client :> IDisposable).Dispose()
        client <- fConnect 0
    
    let rec connectToZookeeper attempts = 
        if attempts = numberOfEndpoints then 
            LogConfiguration.Logger.Fatal.Invoke("Could not connect to any of the zookeeper hosts", null)
            connectionLostEvent.Trigger()
            null
        else 
            let endpoint = endpointSeq |> Seq.head
            let newClient = new ZookeeperClient(new Action(fun () -> connectionLost connectToZookeeper))
            try 
                newClient.Connect(endpoint, sessionTimeout)
                client.ChildWatchers |> Seq.iter (fun x -> newClient.GetChildren(x.Path, x.Callback) |> ignore)
                client.DataWatchers |> Seq.iter (fun x -> newClient.GetData(x.Path, x.Callback) |> ignore)
                newClient
            with e -> 
                (newClient :> IDisposable).Dispose()
                LogConfiguration.Logger.Error.Invoke
                    (sprintf "Could not connect to the zookeeper host %s:%i" endpoint.Address endpoint.Port, e)
                connectToZookeeper (attempts + 1)
    
    let checkIfConnected() = 
        if client |> isNull then invalidOp "Not connected to any zookeeper host"
    
    do 
        if endpoints
           |> isNull
           || endpoints |> Seq.isEmpty then invalidArg "endpoints" "At least one endpoint should be provided"
    
    /// Event raised when unable to connect to any of the provided Zookeeper instances
    [<CLIEventAttribute>]
    member __.ConnectionLost = connectionLostEvent.Publish
    
    /// Connect to the Zookeeper cluster
    member __.Connect() = client <- connectToZookeeper 0
    
    /// Get children of the specified node
    member __.GetChildren(path) = 
        checkIfConnected()
        client.GetChildren(path).Children
    
    /// Get children of the specified node and subscribe to notifications
    member __.GetChildren(path, watcherCallback) = 
        checkIfConnected()
        client.GetChildren(path, watcherCallback).Children
    
    /// Get the available Kafka brokers
    member self.GetBrokerIds() = self.GetChildren(brokerIdsPath) |> Array.map (fun x -> x |> int)
    
    /// Get the available Kafka brokers and subscribed to notifications
    member self.GetBrokerIds(watcherCallback) = 
        self.GetChildren(brokerIdsPath, watcherCallback) |> Array.map (fun x -> x |> int)
    
    /// Get node data
    member __.GetData(path) = 
        checkIfConnected()
        client.GetData(path).Data
    
    /// Get node data and subscribe to notifications
    member __.GetData(path, watcherCallback) = 
        checkIfConnected()
        client.GetData(path, watcherCallback).Data
    
    /// Get registration information about a single Kafka broker
    member self.GetBrokerRegistrationInfo(id) = 
        let info = self.GetData(sprintf "%s/%i" brokerIdsPath id) |> JsonHelper.fromJson<BrokerRegistrationInformation>
        { info with Id = id }
    
    /// Get registration information about a single Kafka broker and subscribe to notifications
    member self.GetBrokerRegistrationInfo(id, watcherCallback) = 
        let info = 
            self.GetData(sprintf "%s/%i" brokerIdsPath id, watcherCallback) 
            |> JsonHelper.fromJson<BrokerRegistrationInformation>
        { info with Id = id }
    
    /// Get registration information about all brokers in the Kafka cluster
    member self.GetAllBrokerRegistrationInfo() = 
        self.GetBrokerIds() |> Seq.map (fun x -> self.GetBrokerRegistrationInfo(x))
    
    /// Get available Kafka topics
    member self.GetTopics() = self.GetChildren(topicsPath)
    
    /// Get available Kafka topics and subscribe to notification
    member self.GetTopics(watcherCallback) = self.GetChildren(topicsPath, watcherCallback)
    
    /// Get registration information about a topic
    member self.GetTopicRegistrationInfo(topic) = 
        self.GetData(sprintf "%s/%s" topicsPath topic) |> JsonHelper.fromJson<TopicRegistrationInformation>
    
    /// Get registration information about a topic and subscribe to notifications
    member self.GetTopicRegistrationInfo(topic, watcherCallback) = 
        self.GetData(sprintf "%s/%s" topicsPath topic, watcherCallback) 
        |> JsonHelper.fromJson<TopicRegistrationInformation>
    
    /// Get topic partition state information
    member self.GetTopicPartitionState(topic, partitionId) = 
        let path = sprintf "%s/%s/partitions/%i/state" topicsPath topic partitionId
        self.GetData(path) |> JsonHelper.fromJson<TopicPartitionState>
    
    /// Get topic partition state information and subscribe to notifications
    member self.GetTopicPartitionState(topic, partitionId, watcherCallback) = 
        let path = sprintf "%s/%s/partitions/%i/state" topicsPath topic partitionId
        self.GetData(path, watcherCallback) |> JsonHelper.fromJson<TopicPartitionState>
    
    interface IDisposable with
        member __.Dispose() = 
            if not disposed then 
                if client |> isNull then (client :> IDisposable).Dispose()
                disposed <- true
