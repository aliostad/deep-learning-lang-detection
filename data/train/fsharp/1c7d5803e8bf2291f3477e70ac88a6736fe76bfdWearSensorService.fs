namespace GestureRecWear

open Extensions
open System
open System.Collections.Generic
open System.Linq
open System.Text
open System.IO

open Android.App
open Android.Content
open Android.OS
open Android.Runtime
open Android.Views
open Android.Widget
open Android.Gms.Wearable
open Android.Hardware
open Android.Gms.Common.Apis
open Android.Gms.Common.Data
open Recognition
open FSM

module ServiceContants =
    let defaultSensors = 
            [|
//                SensorType.Accelerometer; 
//                SensorType.Gyroscope; 
//                SensorType.LinearAcceleration
                SensorType.RotationVector; 
//                SensorType.Gravity
            |]

type WearMsg = {Path:string; Data:byte[]}

[<Service>] 
[<IntentFilter([|WearableListenerService.BindListenerIntentAction|])>]
type WearSensorService() as this = 
    inherit WearableListenerService()
    let mutable wakeLock:PowerManager.WakeLock = null
    let mutable cts = Unchecked.defaultof<_>
    let mutable storageAgent = Unchecked.defaultof<_>
    let mutable sendFilesAgent = Unchecked.defaultof<_>
    let mutable messageSendAgent : MailboxProcessor<WearMsg> = Unchecked.defaultof<_>
    let mutable obs = Unchecked.defaultof<_>
    let mutable fpost = Unchecked.defaultof<_>

    let unregisterAll() =
        let smgr = this.GetSystemService(Service.SensorService) :?> SensorManager
        if smgr <> Unchecked.defaultof<_> then
            smgr.UnregisterListener(this)

    let unregister sensors = 
        let smgr = this.GetSystemService(Service.SensorService) :?> SensorManager
        for snsr in sensors do
            let s = smgr.GetDefaultSensor(snsr)
            smgr.UnregisterListener(this, s) |> ignore

    let register sensors = 
        let smgr = this.GetSystemService(Service.SensorService) :?> SensorManager
        for snsr in sensors do
            let s = smgr.GetDefaultSensor(snsr)
            printfn "registering %A" s
            if not <| smgr.RegisterListener(this, s, SensorDelay.Game) then
                if not <| smgr.RegisterListener(this, s, SensorDelay.Game) then
                    if not <| smgr.RegisterListener(this, s, SensorDelay.Game) then
                        printfn "sensor not registered %A" s
                        logE (sprintf "Unable to register sensor %A" s)
 
    let acquireWakeLock() =
        let pm = this.GetSystemService(Service.PowerService) :?> PowerManager
        wakeLock <- pm.NewWakeLock(WakeLockFlags.Partial, "SensorTest")
        wakeLock.Acquire()

    let releaseWakeLock() =
        if wakeLock <> null then
            wakeLock.Release()
            wakeLock.Dispose()
        wakeLock <- null

    let sendLoop (inbox:MailboxProcessor<WearMsg>) =
        async {
            while true do
                try 
                    let! {Path=p;Data=msg} = inbox.Receive()
                    do! GmsExtensions.sendWearMessage p msg
                with ex ->
                    logE ex.Message
         }

    let mutable currentState = F (HSM.m_start (F(Twist.start Twist.TwistCfg.Default,None)),None)

    let processEvent = function
        | RE_Twist  ->  
            register    [SensorType.LinearAcceleration; SensorType.Gravity]
            AndroidExtensions.playVib 1000L
        | RE_Escape -> 
            unregister  [SensorType.LinearAcceleration; SensorType.Gravity]
            AndroidExtensions.playVib 1000L
        | RE_Tap -> AndroidExtensions.playVib 1000L
        | RE_Left -> AndroidExtensions.playVib 1000L
        | RE_Right -> AndroidExtensions.playVib 1000L
        | RE_Swipe -> AndroidExtensions.playVib 1000L

    let sendEvent ev =
        let evName = 
            match ev with
            | RE_Twist  -> "Twist"
            | RE_Escape -> "Escape"
            | RE_Right  -> "Right"
            | RE_Left   -> "Left"
            | RE_Tap    -> "Tap"
            | RE_Swipe  -> "Swipe"
        messageSendAgent.Post({Path=Constants.p_event; Data=Encoding.UTF8.GetBytes evName})

    let processEvent ev = printfn "%A" ev; processEvent ev; sendEvent ev
 
    interface ISensorEventListener with
        member x.OnAccuracyChanged(_,_) = ()
        member x.OnSensorChanged(ev) = 
            let tes = {Snsr=int ev.Sensor.Type; Ticks=ev.Timestamp; X=ev.Values.[0]; Y=ev.Values.[1];Z=ev.Values.[2]}
            let (F(nextState,maybeEvent)) =  evalState currentState tes
            currentState <- F(nextState,None)
            match maybeEvent with 
            | Some e -> processEvent e 
            | None -> ()

    override x.OnCreate() = 
        base.OnCreate()

    override x.OnStart(intnt,id) =
        base.OnStart(intnt,id)
        try
            acquireWakeLock()
            cts <- new System.Threading.CancellationTokenSource()
            messageSendAgent <- MailboxProcessor.Start(sendLoop,cts.Token)
//            let o,s = Observable.createBroker cts.Token
//            obs <- o
//            fpost <- s
            register [|SensorType.Gyroscope|]
            GlobalState.runningEvent.Trigger(true)
            AndroidExtensions.playVib (100L)
            logI "service started"
        with ex ->
            logE ex.Message

    override x.OnMessageReceived(msg) =
        try
            let d = msg.GetData()
            let p = msg.Path
            let s = msg.SourceNodeId
            logI p
            match p with
            | Constants.p_start -> 
                let i = new Intent(this,typeof<WearSensorService>)
                i
                |> x.StartService |> ignore
            | Constants.p_stop ->
                this.StopSelf()
            | p -> 
                logE (sprintf "invalid path %s" p)
        with ex ->
            logE ex.Message
                           
    override x.OnDestroy() =
        try 
            unregisterAll() 
            releaseWakeLock()
            if cts <> Unchecked.defaultof<_> then cts.Cancel()
            GlobalState.runningEvent.Trigger(false)
            messageSendAgent <- Unchecked.defaultof<_>
            storageAgent <- Unchecked.defaultof<_>
            logI "service closed"
        with ex ->
            logE (sprintf "error stopping service %s" ex.Message)
        base.OnDestroy()

    override x.OnDataChanged(eventBuffer) =
        logI "onDataChanged"
        try
            let dataEvents = [for i in 0..eventBuffer.Count-1 -> eventBuffer.Get(i).JavaCast<IDataEvent>()]
            let files =
                dataEvents
                |> Seq.filter (fun ev -> ev.Type = DataEvent.TypeDeleted)
                |> Seq.map    (fun ev -> ev.DataItem.Uri.Path)
//                |> Seq.map    (fun p  -> p.Remove(0,Constants.p_data_file.Length + 1))
                |> Seq.toList
            eventBuffer.Close()
            //FileSender.deleteFiles files Storage.data_directory
        with ex ->
           eventBuffer.Close()
           logE ex.Message

            

