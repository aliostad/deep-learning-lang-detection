namespace Pid
open Pid.Core

module Controller =
    type Output =
        | ControlOutput of float
        | Halted of float

    type Command =
          /// Request (via the provided reply channel) the control variable, the recommendation
          /// based on process observations up to this point.
        | ReportControlOutput of AsyncReplyChannel<Output>

          /// End the controller's internal timer loop. All further ReportControlOutput replies
          /// will be purged before the actor terminates.
        | Halt of AsyncReplyChannel<Output>

        | MoveSetPoint of float
        | ChangeConstants of Constants

    type private ControllerOperation =
        | Command of Command
        | MeasurementIntervalElapsed

    /// <summary>
    /// Begins a controller process that can be queried asynchronously. Evaluation of the control
    /// variable is eager as per the given process interval, but adjustments are reported only
    /// on demand.
    /// </summary>
    /// <param name="measureProcess">
    /// Returns on demand the process variable (i.e. theobserved performance of the machine
    /// under control). This function will be periodically called according to processInterval.
    /// </param>
    /// <param name="processInterval">
    /// The average time (in milliseconds) between measurements of the process variable. The
    /// actual intervals depend on system business, and the controller makes no guarantees
    /// other than a "best-effort" average.
    /// </param>
    let Start (constants : Pid.Constants) (seed : Pid.Core.InitialState) (measureProcess : unit -> float) (processInterval : int) =
        let controlProcess (mailbox : MailboxProcessor<ControllerOperation>) =
            /// Responds synchronously to all messages in the mailbox which might be waiting. Others are
            /// left and ultimately ignored.
            let rec purgePendingReplies (mailbox : MailboxProcessor<ControllerOperation>) lastControlOutput =
                let replyIfNecessary message =
                    match message with
                    | Command c ->
                        match c with
                        | (ReportControlOutput sender | Halt sender) ->
                            Some(async { return sender.Reply (Halted lastControlOutput) })
                        | _ -> None
                    | _ -> None
                in
                    try
                        Async.RunSynchronously (mailbox.Scan (replyIfNecessary, 0))
                    with
                    | :? System.TimeoutException -> ()   // Found all the messages; done!
            in
            let rec controlLoop (controllerState : Pid.Core.State) (constants : Pid.Constants) = 
                try
                    async {
                        let! message = mailbox.Receive (5 * processInterval)
                        match message with
                            | Command c ->
                                match c with
                                    | ReportControlOutput sender ->
                                        sender.Reply (ControlOutput controllerState.Output)
                                        return! controlLoop controllerState constants
                                    | MoveSetPoint newSetPoint ->
                                        return! controlLoop {controllerState with SetPoint=newSetPoint} constants
                                    | ChangeConstants newConstants ->
                                        return! controlLoop controllerState newConstants
                                    | Halt sender ->
                                        sender.Reply (Halted controllerState.Output)
                                        return purgePendingReplies mailbox controllerState.Output   // Close this mailbox.
                            | MeasurementIntervalElapsed ->
                                // TODO: Be lazier! We don't actually need the output to be periodically calculated.
                                // 
                                let newControllerState = controllerState.appliedTo (measureProcess ()) constants
                                return! controlLoop newControllerState constants
                    }
                with
                | :? System.TimeoutException ->
                    System.Console.Error.WriteAsync "Warning: system overwhelmed, periodic timers are arriving very late." |> ignore
                    controlLoop controllerState constants
            in controlLoop (Pid.Core.State.Initial seed) constants
        in
        /// <summary>
        /// Start a control loop, passing down to it all commands from the customer (e.g. to change the set point)
        /// and triggering control calculations at the interval period.
        /// </summary>
        /// <param name="period">Describes the control calculation interval in milliseconds.</param>
        let rec timerProcess period =
            let controller = MailboxProcessor.Start(controlProcess)
            let rec receiveCommandFrom (mailbox : MailboxProcessor<Command>) =
                async {
                    let! message = mailbox.TryReceive period
                    match message with
                        | None ->
                            controller.Post MeasurementIntervalElapsed
                            return! receiveCommandFrom mailbox
                        | Some c ->
                            controller.Post (Command c)
                            // TODO: Adjust remaining period.
                            return! receiveCommandFrom mailbox
                }
            in MailboxProcessor.Start receiveCommandFrom
        in timerProcess processInterval


