namespace OpenBCI.chipKIT_32bit
module ScheduledQueue = 

    type ScheduledQueue<'T>(interval : double, action : (obj -> ElapsedEventArgs -> unit)) =
        let queue = Queue<'T>()
        let timer = new Timer(interval)
        let event = ElapsedEventHandler(action)
        let schedule = queue.Enqueue
        do  timer.Elapsed.AddHandler(event)
            timer.Start()
        member this.Finalize = do
            timer.Stop()
            timer.Elapsed.RemoveHandler(event)
        member this.Interval with set (interval) = timer.Interval <- interval