module GmsExtensions

open System
open System.Collections.Generic
open System.Linq
open System.Text
open System.Threading
open Extensions

open Android.App
open Android.Content
open Android.OS
open Android.Runtime
open Android.Util
open Android.Views
open Android.Widget
open Android.Support.Wearable.Views
open Android.Support.Wearable.Views
open Android.Gms.Common.Data
open Android.Gms.Common
open Android.Gms.Wearable
open Android.Hardware
open Android.Gms.Common.Apis

type ResultCB<'R when 'R :> IResult and 'R: not struct>(f) =
    inherit Java.Lang.Object() 
    interface IResultCallback with
        member x.OnResult(a) =
            let r = a.JavaCast<'R>()
            f r
            () 

let apiClientCont fError fSuccess  =
    let bldr = new GoogleApiClientBuilder(Application.Context)
    let gapi = bldr.AddApi(WearableClass.Api).Build()
    if not gapi.IsConnected then
        let r = gapi.BlockingConnect(30L,Java.Util.Concurrent.TimeUnit.Seconds)
        if r.IsSuccess then
            fSuccess gapi
        else
            fError()

let logConnectionError() = logE "api client connect not successful"

let withApiClientDo = apiClientCont logConnectionError

type ConnectionFailedCB (fError) =
    inherit Java.Lang.Object()
    interface Android.Gms.Common.IGooglePlayServicesClientOnConnectionFailedListener with
        member x.OnConnectionFailed(connectionResult) = fError connectionResult
    interface IGoogleApiClientOnConnectionFailedListener with
        member x.OnConnectionFailed(connectionResult) = fError connectionResult

type ConnectionSuccessCB (fSuccess) =
    inherit Java.Lang.Object()
    interface IGoogleApiClientConnectionCallbacks with
        member x.OnConnected(bundle) = fSuccess()
        member x.OnConnectionSuspended(cause) = ()

let connect() =
    async {
        let bldr = new GoogleApiClientBuilder(Application.Context)
        let gapi = bldr.AddApi(WearableClass.Api).Build()
        if not gapi.IsConnected then
            let ev = ref (Some (new ManualResetEvent(false)))
            let errorCode = ref None
            let setEV () = match !ev with Some ev -> ev.Set() |> ignore | _ -> ()
            let setError (cr:ConnectionResult) = errorCode := Some cr.ErrorCode; setEV()
            gapi.RegisterConnectionCallbacks(new ConnectionSuccessCB(setEV))
            gapi.RegisterConnectionFailedListener(new ConnectionFailedCB(setError))
            do gapi.Connect()
            let! t = Async.AwaitWaitHandle(ev.Value.Value, 5000)
            ev.Value.Value.Dispose()
            ev := None
            if gapi.IsConnected then 
                return gapi
            else
                return failwithf "gapi : unable to connect; errorcode %A" !errorCode
        else
            return gapi
    }

type AwaitResult<'a> = ARSuccess of 'a | ARError of string

let awaitPending<'R when 'R :> IResult and 'R: not struct> (pr:IPendingResult) timeout =
    async {
        let ev = new ManualResetEvent(false)
        let result = ref None
        do pr.SetResultCallback(new ResultCB<'R> (fun r -> result := Some r; ev.Set() |> ignore))
        let! isDone = Async.AwaitWaitHandle(ev,timeout)
        ev.Dispose()
        match !result with
        | Some r ->
            if r.Status.IsSuccess then
                return ARSuccess r
            else
                let msg = sprintf "awaitPending failed with status %s" r.Status.StatusMessage
                logE msg
                return ARError msg
        | None -> 
            let msg = sprintf "awaitPending timeout: %d ms" timeout
            logE msg
            return ARError msg
      }

let awaitPendingT<'R when 'R :> IResult and 'R: not struct> (pr:IPendingResult) timeout =
    async {
        let! ar = awaitPending<'R> pr timeout
        match ar with
        | ARSuccess r -> return r
        | ARError  s  -> return failwith s
        }

let sendWearMessage path data =
    async {
        try
            let! gapi = connect()
            let pr = WearableClass.NodeApi.GetConnectedNodes(gapi)
            let! nr = awaitPendingT<INodeApiGetConnectedNodesResult> pr 5000
            for n in nr.Nodes do
                let pr2 = WearableClass.MessageApi.SendMessage(gapi,n.Id,path,data)
                let! _ = awaitPending<Android.Gms.Wearable.IMessageApiSendMessageResult> pr2 5000
                ()
        with ex -> 
                logE ex.Message
    }
