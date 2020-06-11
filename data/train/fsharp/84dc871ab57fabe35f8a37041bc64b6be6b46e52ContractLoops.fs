// **** **** **** **** **** **** **** **** **** **** **** **** ****
// **  Copyright (c) 2017, Robert Nielsen. All rights reserved.  **
// **** **** **** **** **** **** **** **** **** **** **** **** ****

namespace Rodhern.Kapoin.MainModule.Contracts

  open System
  open System.Collections.Generic
  open System.Reflection
  open UnityEngine
  open Rodhern.Kapoin.Helpers
  open Rodhern.Kapoin.Helpers.UtilityModule
  open Rodhern.Kapoin.Helpers.UtilityClasses
  open Rodhern.Kapoin.Helpers.Contracts
  open Rodhern.Kapoin.MainModule.Events
  
  
  [< AttributeUsage (AttributeTargets.Method, Inherited= false, AllowMultiple= false) >]
  /// The StaticRequirementCheckAttribute is used to mark that a static method
  /// is a contract requirement check generator. The generator is used to
  /// generate new Static Requirement Check Action (SRCAction) objects.
  /// The check actions are in turn executed in the main loop in the space
  /// center scene.
  /// The signature of the static method should be unit -> SRCAction.
  type StaticRequirementCheckAttribute () =
    inherit Attribute ()
  
  
  [< AbstractClass >]
  /// A base class for static requirement check actions.
  /// Contract requirement check generators can use the SRCAction type
  /// as a jumping-off point for their object expressions.
  type SRCAction =
    /// This is the main function of the SRCAction object.
    /// All SRCAction instances must override Execute.
    abstract member Execute: unit -> unit
    abstract member OnDispose: unit -> unit
      /// Invoked when the StaticRequirementCheckScheduler is disabled.
      /// Notice: By the time OnDispose is called it is too late to access
      ///  most of the addon functionality (such as persistent data).
      ///  Perform rudimentary clean-up and logging only.
     default a.OnDispose () = ()
    abstract member GetPriority: int with get
      /// The priority determines which SRCActions execute first.
      /// Highest values execute first. Often the priority is irrelevant.
      default a.GetPriority with get () = 0
    /// Default constructor used in object expressions and so forth.
    new () = { disposed= false }
    val mutable private disposed: bool
    /// Helper method for StaticRequirementCheckScheduler.
    member a.QueueAction (loop: MainKapoinLoop) =
      fun () -> lock a (fun () ->
        if not a.disposed
         then do a.Execute ()
         else () ) // do nothing if disposed
      |> loop.QueueAction
    /// Helper method for StaticRequirementCheckScheduler.
    member a.MarkDisposed () =
      lock a (fun () ->
        if not a.disposed
         then do a.OnDispose ()
              a.disposed <- true
         else () ) // do nothing if disposed
    interface IDisposable with
      /// By default IDisposable.Dispose simply marks the object as 'disposed'.
      member I.Dispose () = I.MarkDisposed ()
  
  
  [< KSPAddon (KSPAddon.Startup.SpaceCentre, false) >]
  /// DESC_MISS
  type StaticRequirementCheckScheduler () =
    inherit SceneAddonBehaviour "StaticRequirementCheckScheduler"
    
    let mutable onExit = fun () -> ()
    let mutable allactions: SRCAction [] = [| |]
    let pendingcount = ref 0
    let lastqueuecount = ref 0
    
    /// Execute, then reset the onExit function.
    member private handler.ExecOnExit () =
      do onExit ()
      onExit <- fun () -> ()
    
    /// DESC_MISS
    member public handler.OnEnable () =
      base.OnEnable ()
      do handler.ExecOnExit ()
      let mainloopobj = GameObject.FindObjectOfType<MainKapoinLoop> ()
      if assigned mainloopobj then
        let tickhandler = new EventHandler<EventArgs> (handler.OnTick)
        let addhandler = fun () ->
          handler.LogFn "Subscribe to main loop tick event."
          mainloopobj.MainTickEvent.AddHandler tickhandler
        let removehandler = fun () ->
          handler.LogFn "Cancel tick handler subscription."
          mainloopobj.MainTickEvent.RemoveHandler tickhandler
          // dispose of the SRCActions, giving them an opportunity to clean up
          allactions |> Array.iter (fun a -> a.MarkDisposed ())
          allactions <- [| |]
        do addhandler ()
        onExit <- removehandler
    
    /// DESC_MISS
    member public handler.OnDisable () =
      base.OnDisable ()
      handler.ExecOnExit ()
    
    /// DESC_MISS
    member public handler.OnTick (loopmonitor: obj) (nullarg: obj) =
      handler.LogFn <| sprintf "OnTick %A %A." loopmonitor nullarg // todo
      if allactions.Length <= 0
       then handler.LogFn "No contract static requirement checks registered (yet)." // todo
            if not MainKapoinLoop.LoopStateIsRunning
             then "Internal error in StaticRequirementTickHandler."
                  + " Method 'OnTick' executing even though the main Kapoin loop is not running."
                  |> LogError
             else handler.LogFn "Initialize 'allactions' array by reflection." // todo
                  allactions <- StaticRequirementCheckScheduler.FindAllSRCs ()
                  handler.LogFn <| sprintf "Resulting 'allactions' array size is %d." allactions.Length // todo
      elif !pendingcount > 0
       then handler.LogFn "Checks still pending; update and verify warning level." // todo
            handler.ManagePendingCountWarnings (loopmonitor :?> MainKapoinLoop)
       else handler.LogFn "Schedule check actions." // todo
            handler.ScheduleActions (loopmonitor :?> MainKapoinLoop)
    
    /// Queue all actions from the 'allactions' array by repeatedly applying
    /// the 'QueueAction' functionality of the passed 'loopmonitor' argument.
    member public handler.ScheduleActions (loopmonitor: MainKapoinLoop) =
      lock handler (fun () ->
        incr pendingcount
        lastqueuecount:= 75 // reset queue counter to artificial value
        allactions |> Array.iter (fun a -> a.QueueAction loopmonitor)
        loopmonitor.QueueAction (fun () -> lock handler (fun () -> decr pendingcount)) )
    
    /// Log that the 'allactions' actions (aaas) were not (re)queued.
    /// If the (global) loop monitor action queue has improved, i.e. contains
    /// fewer unprocessed items than before, then a debug message is logged,
    /// otherwise a warning is logged.
    /// An additional action, queued to take place after all aaas are carried
    /// out, will signal that there are no more pending aaas. If that signal
    /// has not yet been received some aaas may still be waiting in queue. We
    /// do not requeue aaas while there are still pending aaas.
    member public handler.ManagePendingCountWarnings (loopmonitor: MainKapoinLoop) =
      lock handler (fun () ->
        let queuecount = loopmonitor.NumberOfActionsQueued
        if queuecount < !lastqueuecount
         then "Skip static contract requirement check scheduling"
              + " while the main Kapoin loop action queue is busy"
              + sprintf " (%d item%s in queue)." queuecount (if queuecount = 1 then "" else "s")
              |> handler.LogFn
         else "Main Kapoin loop action queue is busy"
              + sprintf " (%d item%s in queue);" queuecount (if queuecount = 1 then "" else "s")
              + " no new static contract requirement checks scheduled."
              |> LogWarn
        lastqueuecount:= queuecount )
    
    /// List of all Kapoin contract classes
    /// defined in the Kapoin main module assembly.
    static member public AllKapoinContractClasses () =
      /// Name of the main module, i.e. 'Kapoin', obtained by old fashion reflection.
      let aName = (Assembly.GetAssembly(typeof<StaticRequirementCheckScheduler>).GetName()).Name
      [ for a in AssemblyLoader.loadedAssemblies
         do if a.name = aName then
             for t in a.assembly.GetExportedTypes ()
              do if t.IsSubclassOf typeof<KapoinContract> then
                  yield t ]
    
    /// Use reflection to find a particular Kapoin contract class.
    static member public FindKapoinContractClass (cname: string) =
      StaticRequirementCheckScheduler.AllKapoinContractClasses ()
      |> List.filter (fun ctype -> ctype.Name = cname)
      |> function
         | [ ctype ] -> ctype
         | ctypes -> sprintf "Kapoin contract class '%s' not found (length of filtered list: %d)." cname ctypes.Length
                     |> KapoinContractError.Raise
    
    /// Find all Kapoin contract static requirement check methods,
    /// by inspecting Kapoin contract classes for SRC attributes.
    static member public FindAllSRCs () =
      
      /// Helper function to check each of the given type's methods to identify the SRCs.
      let getSRCs (ctype: Type) =
        let warningcheck (l: 'a list) =
          match l.Length with
          | 0 -> LogWarn <| sprintf "Kapoin contract class '%s' do not seem to have a static requirement check method." ctype.Name
          | 1 -> ()
          | n -> LogWarn <| sprintf "More than one (%d) static requirement check methods found for Kapoin contract class '%s'." n ctype.Name
          l
        let signaturefilter (info: MethodInfo) =
          try match info.Invoke (null, null) with
              | null
                -> sprintf "Method '%s' of class '%s' returned void." info.Name ctype.Name
                   |> LogError
                   None
              | :? SRCAction as action
                -> Some (action.GetPriority, action)
              | _
                -> sprintf "The return type of method '%s' of class '%s'" info.Name ctype.Name
                   + " was not suitable for a static requirement check method."
                   |> LogError
                   None
           with
           | e
             -> sprintf "Attempt to invoke method '%s' of class '%s' failed." info.Name ctype.Name
                + sprintf " Exception of type %s raised with message \"%s\"." (e.GetType ()).Name e.Message
                |> LogError
                None
        [ for m in ctype.GetMethods (BindingFlags.Public ||| BindingFlags.Static)
           do if Attribute.IsDefined (m, typeof<StaticRequirementCheckAttribute>) then
               yield m ]
        |> List.choose signaturefilter
        |> warningcheck
      
      /// List the static requirement check methods found from contracts in the cTypes list.
      let srcMethods =
        [| for ctype in StaticRequirementCheckScheduler.AllKapoinContractClasses ()
            do yield! getSRCs ctype |]
      
      // Reorder the SRCs (with the highest numbers first).
      let comparer = { new IComparer<int * 'a> with member I.Compare ((i,_),(j,_)) = - compare i j }
      Array.Sort (srcMethods, comparer)
      Array.map snd srcMethods
  
  
  /// A KSP scene addon that uses the frame update method to continually
  /// check active Kapoin contracts for completion (or failure).
  type KapoinContractLoopBehaviour (name: string, checktype: ContractCheck) =
    inherit SceneAddonBehaviour (name)
    
    let [< Literal >] framedivisor = 12
    let [< Literal >] frameoffset = 7
    
    let mutable lastActionFrame = 0
    let mutable lastActionTime = 0.f
    let nextActionIndex = ref 0
    
    member public this.Update (): unit =
      let framenb = UnityEngine.Time.frameCount
      if (framenb % framedivisor = frameoffset) && (framenb > lastActionFrame) then
        let time = UnityEngine.Time.realtimeSinceStartup
        if (time > lastActionTime + 0.5f) // at least half a second should always pass
           && ((framenb > lastActionFrame + 35) || (time > lastActionTime + 1.5f)) then // hardcoded for now
          lastActionFrame <- framenb
          lastActionTime <- time
          if MainKapoinLoop.LoopStateIsRunning then
            KapoinContract.CheckActiveContract checktype (Some nextActionIndex)
  
  
  /// The Kapoin contract check loop running in the flight scene.
  type KapoinInFlightContractLoop () =
    inherit KapoinContractLoopBehaviour (typeof<KapoinInFlightContractLoop>.Name, ContractCheck.FlightCheck)
  
  
  /// The Kapoin contract check loop running in the space center
  /// and tracking station scenes.
  /// Because of a limitation in the KSPAddon.Startup enumeration we actually
  /// need separate loops for the space center and tracking station scenes.
  type KapoinOnGroundContractLoop () =
    inherit KapoinContractLoopBehaviour (typeof<KapoinOnGroundContractLoop>.Name, ContractCheck.GroundCheck)
    
    // To avoid spamming the log, we will blacklist a few talkative classes for the time being.
    
    /// Start or stop blacklisting of selected 'talkative' classes
    /// in the space center and tracking station scenes.
    /// Blacklisting can be turned on and off at any time and will last until
    /// turned on or off again, either at a relevant scene change or manually.
    member public loop.Blacklist (blacklist: bool) =
      [| "StaticRequirementCheckScheduler"; "C70"; "C60" |]
      |> Array.iter (if blacklist then LoggerBlackList.Add else LoggerBlackList.Remove)
      loop.LogFn <| (if blacklist then "Enable" else "Disable") + " ground scene log blacklisting."
    
    member public loop.OnEnable () =
      base.OnEnable ()
      loop.Blacklist true
    
    member public loop.OnDisable () =
      base.OnDisable ()
      loop.Blacklist false
  
  
  [< KSPAddon (KSPAddon.Startup.Flight, false) >]
  type KapoinFlightSceneContractLoop () = inherit KapoinInFlightContractLoop ()
  
  [< KSPAddon (KSPAddon.Startup.SpaceCentre, false) >]
  type KapoinSpaceCentreContractLoop () = inherit KapoinOnGroundContractLoop ()
  
  [< KSPAddon (KSPAddon.Startup.TrackingStation, false) >]
  type KapoinTrackingStationContractLoop () = inherit KapoinOnGroundContractLoop ()
  
