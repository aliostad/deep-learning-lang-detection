module RabbitMQ.PerfTest.Metrics
open System
open System.Threading

open App.Metrics
open App.Metrics.Histogram

type Stats (id: string, interval : int) =
    let time () = DateTime.Now.Ticks
    let metrics = (new MetricsBuilder()).Build()

    let startTime =  time()
    let mutable lastStatTime = 0L
    let mutable sendCount = 0
    let mutable sendCountInterval = 0
    let mutable receiveCount = 0
    let mutable receiveCountInterval = 0
    let mutable totalLatencyInterval = 0L
    let mutable maxLatency = 0L
    let mutable minLatency = Int64.MaxValue

    let locker = obj()
    let div = TimeSpan.TicksPerMillisecond / 1000L
    let latencyOpts = new HistogramOptions (Name = "Latency")

    let resetInterval n =
        metrics.Manage.Reset()
        metrics.Measure.Histogram.Update(latencyOpts, 0L)
        lastStatTime <- n
        Interlocked.Exchange(&sendCountInterval, 0) |> ignore
        Interlocked.Exchange(&receiveCountInterval, 0) |> ignore
        Interlocked.Exchange(&minLatency, Int64.MaxValue) |> ignore
        Interlocked.Exchange(&maxLatency, 0L) |> ignore

    let reportInterval () =
        let sw = new Diagnostics.Stopwatch()
        sw.Start()
        let now = time ()
        let elapsed = TimeSpan (now - lastStatTime)
        (* if (int elapsed.TotalMilliseconds) >= interval then *)
            // report
        let sent = sendCountInterval / (interval / 1000)
        let received = receiveCountInterval / (interval / 1000)
        let totaltime = TimeSpan (now - startTime)
        let snap = metrics.Snapshot.Get()
        let maxLatency, minLatency, medLatency =
            match snap.Contexts.WhereNotEmpty() |> Seq.tryHead with
            | Some x ->
                let h = x.Histograms |> Seq.tryFind (fun h -> h.Name = "Latency")
                match h with
                | Some h ->
                    int h.Value.Max / 10, int h.Value.Min / 10, int h.Value.Median / 10
                | None -> 0, 0, 0
            | None -> 0, 0, 0

        resetInterval now
        printfn "id: %s, time: %.3fs, sent: %i msg/s, received: %i msg/s, min/median/max latency: %i/%i/%i microseconds"
                id totaltime.TotalSeconds sent received minLatency medLatency maxLatency
        sw.Stop()
        sw.ElapsedMilliseconds
    do
        resetInterval startTime
        async {
            let mutable sleep = 1000
            while true do
                do! Async.Sleep sleep
                let taken = reportInterval ()
                sleep <- max 100 (1000 - int taken)
        } |> Async.Start

    member s.HandleSend() =
        Interlocked.Increment (&sendCount) |> ignore
        Interlocked.Increment (&sendCountInterval) |> ignore

    member s.HandleReceive(latencyTicks : int64) =
        metrics.Measure.Histogram.Update(latencyOpts, latencyTicks)
        Interlocked.Increment (&receiveCount) |> ignore
        Interlocked.Increment (&receiveCountInterval) |> ignore
