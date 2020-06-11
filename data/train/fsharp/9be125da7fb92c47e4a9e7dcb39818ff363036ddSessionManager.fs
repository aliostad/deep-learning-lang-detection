namespace FacebookPagesApp

open System

open Android.App
open Android.Content
open Android.Util
open Android.Support.V4.Content
open FSharp.Control.Reactive
open Xamarin.Facebook
open System.Threading

type LoginResult = Successful | Failed

type ISessionManager = 
    abstract Login: Async<LoginResult> with get
    abstract Logout: Async<unit> with get
    abstract AccessToken:string with get

type LoginState = LoggedIn | LoggedOut

module FacebookSession =
    type private SessionStatusChangedCallback (cb) =    
        inherit Java.Lang.Object ()

        interface Session.IStatusCallback with 
            member this.Call(session:Session, state:SessionState, ex:Java.Lang.Exception) = cb session

     type private SessionBroadcastReceiver (cb) =
        inherit BroadcastReceiver()

        override this.OnReceive(context:Context, intent:Intent) = cb ()

    type private RequestCallback (cont) =    
        inherit Java.Lang.Object ()
        interface Session.IStatusCallback with 
            member this.Call(session:Session, state:SessionState, ex:Java.Lang.Exception) = 
                match (state, ex) with 
                | (s, _) when s.Equals(SessionState.Opened) -> cont Successful
                | (s, _) when s.Equals(SessionState.ClosedLoginFailed) -> cont Failed
                | _ -> Log.Info("FacebookSessionManager.RequestCallback", session.ToString()) |> ignore
                       Log.Info("FacebookSessionManager.RequestCallback", state.ToString()) |> ignore   

    let private activeSession () =
        match Session.ActiveSession with 
        | null -> None
        | s -> Some s

    type internal FacebookSessionManager(activityProvider: unit->Activity) =
        interface ISessionManager with
            member this.Login 
                with get () = Async.FromContinuations(
                                fun (cont, econt, ccont) ->
                                    let session = Session.ActiveSession
                                    let activity = activityProvider()
                                    let request = new Session.OpenRequest(activity)
                                    request.SetDefaultAudience(SessionDefaultAudience.OnlyMe)
                                           .SetLoginBehavior(SessionLoginBehavior.SsoWithFallback)

                                           // FIXME: Make this a parameter to the constructor
                                           .SetPermissions([|"manage_pages"; "publish_actions" |])
                                           .SetCallback(new RequestCallback(cont)) |> ignore

                                    // FIXME: Might need to call read first and then continue with a request for publish. Need to test.
                                    session.OpenForPublish request)
                                
            member this.Logout 
                with get () = async {
                    Session.ActiveSession.CloseAndClearTokenInformation()
                }

            member this.AccessToken 
                with get() = 
                    // Fixme: Why is this not a library function reall...wtf!!!
                    let getOrElse b a =
                        match a with
                        | Some x -> x
                        | None -> b

                    activeSession () |> Option.map (fun session -> 
                        match session.AccessToken with
                        | null -> ""
                        | at -> at) |> getOrElse ""
                       
    let private createSession context = (new Session.Builder(context)).SetApplicationId(Settings.ApplicationId).Build()

    let private currentSession (context:Context) =
        let onSubscribe(observer:IObserver<Option<Session>>) =
            let activeSessionClosedFilter = 
                let intentFilter = new IntentFilter()
                intentFilter.AddAction(Session.ActionActiveSessionClosed)
                intentFilter

            let activeSessionSetFilter = 
                let intentFilter = new IntentFilter()
                intentFilter.AddAction(Session.ActionActiveSessionSet)
                intentFilter

            let activeSessionClosedReceiver = 
                new SessionBroadcastReceiver(fun () ->
                    Session.ActiveSession <- createSession context)

            let activeSessionSetReceiver = 
                new SessionBroadcastReceiver(fun () -> 
                    activeSession () |> observer.OnNext)  
 
            let localBroadcastManager = 
                let instance = LocalBroadcastManager.GetInstance context
                instance.RegisterReceiver(activeSessionSetReceiver, activeSessionSetFilter)
                instance.RegisterReceiver(activeSessionClosedReceiver, activeSessionClosedFilter)
                instance

            let dispose() = 
                localBroadcastManager.UnregisterReceiver activeSessionSetReceiver
                localBroadcastManager.UnregisterReceiver activeSessionClosedReceiver
            
            let bootstrap () =
                if Session.ActiveSession = null     
                    then Session.ActiveSession <- createSession context
                else observer.OnNext (Some Session.ActiveSession)

                // The state of a session when the user was previously logged in
                if Session.ActiveSession.State = SessionState.CreatedTokenLoaded then Session.ActiveSession.OpenForRead(null)

            async {
                // Cause the work to be scheduled on to the event loop
                do! Async.SwitchToContext SynchronizationContext.Current
                bootstrap ()
            } |> Async.StartImmediate

            dispose 

        Observable.create onSubscribe

    let observe (context:unit->Context) : IObservable<LoginState> =
        let onSubscribe(observer:IObserver<LoginState>) =
            let publishState (session:Session) =
                let state = if session.IsOpened then LoggedIn else LoggedOut
                observer.OnNext state

            let sessionStatusChangedCallback = new SessionStatusChangedCallback(publishState) :> Session.IStatusCallback

            let currentSessionSubscription = 
                (currentSession <| context ()) 
                |> Observable.scanInit (None, None) (fun (_,prev) current -> (prev, current))
                |> Observable.subscribe (fun (prev, current) -> 
                    match (prev, current) with
                    | (None, Some session) -> 
                        session.AddCallback(sessionStatusChangedCallback)
                        publishState session
                    | (Some prev, None) ->
                        prev.RemoveCallback sessionStatusChangedCallback
                    | (Some prev, Some current) -> 
                        prev.RemoveCallback sessionStatusChangedCallback
                        current.AddCallback(sessionStatusChangedCallback)
                        publishState current
                    | _  -> ())

            let dispose () =
                currentSessionSubscription.Dispose()
                match activeSession () with
                | Some session -> session.RemoveCallback sessionStatusChangedCallback
                | _ -> ()
                          
            dispose

        Observable.create onSubscribe |> Observable.distinctUntilChanged

    let observeWithFunc (context:Func<Context>) : IObservable<LoginState> =
        observe (fun () -> context.Invoke())

    let getManager (activityProvider:unit->Activity) =
        new FacebookSessionManager(activityProvider) :> ISessionManager

    let getManagerWithFunc (activityProvider:Func<Activity>) =
        getManager (fun () -> activityProvider.Invoke())

    let onActivityResultDelegate (activity:Activity) requestCode (resultCode:Result) data =
        let session = Session.ActiveSession
        session.OnActivityResult(activity, requestCode, (int32 resultCode), data) |> ignore

        // Work around a bug in FB's Session class where ActionActiveSessionClosed isn't
        // broadcasted when the user cancels the login attempt
        match session.State with
        | s when s = SessionState.Closed ||
                 s = SessionState.ClosedLoginFailed -> 
                    Session.ActiveSession <- createSession activity.ApplicationContext
        | _ -> ()