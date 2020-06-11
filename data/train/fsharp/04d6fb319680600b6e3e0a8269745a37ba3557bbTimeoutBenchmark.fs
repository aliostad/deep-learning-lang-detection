// 
// TimeoutBenchmark.fs
//  
// Author(s):
//       Alessio Parma <alessio.parma@gmail.com>
// 
// Copyright (c) 2012-2016 Alessio Parma <alessio.parma@gmail.com>
// 
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

namespace DIBRIS.Dessert.Benchmarks

open System
open System.Diagnostics
open System.IO
open DIBRIS.Dessert
open DIBRIS.Dessert.Benchmarks.Common
open DIBRIS.Dessert.Examples.CSharp.Galois

module TimeoutBenchmark =
    
    let timeoutBenchmark_Dessert_PEM(env: SimEnvironment, counter: Counter) = seq<SimEvent> {
        while true do
            yield upcast env.Timeout(counter.RandomDelay)
            counter.Increment()
    }
    
    let timeoutBenchmark_Dessert(processCount) =
        let counterTally = Sim.Tally()
        let memoryTally = Sim.Tally()
        for i = 1 to repetitionCount do
            cleanUp()
            let stopwatch = Stopwatch()
            stopwatch.Start()
            let env = Sim.Environment()
            let tally = Sim.Tally()
            env.Process(memoryRecorder(env, tally)) |> ignore
            let counter = Counter()
            for i = 1 to processCount do
                env.Process(timeoutBenchmark_Dessert_PEM(env, counter)) |> ignore        
            env.Run(simTime)
            stopwatch.Stop()
            counterTally.Observe(toEventsPerSec(counter.Total, stopwatch.ElapsedMilliseconds))
            memoryTally.Observe(tally.Mean())
        Result(counterTally.Mean(), int(memoryTally.Mean()))

    let run() =
        let outputName = String.Format("timeout-benchmark-{0}.csv", tag)
        let output = new StreamWriter(outputName)
        printfn "TIMEOUT BENCHMARK - DESSERT"
        printfn "* Warming up..."
        for i = 1 to repetitionCount do
            timeoutBenchmark_Dessert(processCounts.[0]) |> ignore
        for processCount in processCounts do
            printf "* %d processes: " processCount
            let result = timeoutBenchmark_Dessert(processCount)
            let evPerSec = int(result.EventCount)
            let avgMem = int(result.AverageMemUsage)
            printfn "%d timeouts/sec, %d MB" evPerSec avgMem
            output.WriteLine("{0};{1};{2}", processCount, evPerSec, avgMem)
            output.Flush()
        printfn ""         
        output.Close()

