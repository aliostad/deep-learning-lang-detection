#load "Queue.fs"
#load "Algorithms.fs"
#load "SetStackSize.fs"
#load "../packages/FSharp.Charting.0.90.14/FSharp.Charting.fsx"

open SortingAlgorithms
open Queue
open FSharpx.Books.AutomatedReasoning.initialization
open System.Diagnostics
open System
open System.Threading
open FSharp.Charting


Process.GetCurrentProcess().ProcessorAffinity <- IntPtr(2)
Process.GetCurrentProcess().PriorityClass <- ProcessPriorityClass.High;
Thread.CurrentThread.Priority <- ThreadPriority.Highest;

let warmup() = 
    let stopwatch = Stopwatch.StartNew()
    while stopwatch.ElapsedMilliseconds < 1000L do 
        ()
    stopwatch.Stop()


let timefn fn arr = 
    let stopWatch = Stopwatch.StartNew()
    let sortedList = fn arr
    stopWatch.Stop()
    let time = stopWatch.Elapsed.TotalMilliseconds
    // printf "%.2f\n" time
    time
    

let LIMIT = 300

let sorts = 
    [|
        "Bubble Sort";
        "Selection Sort";
        "Insertion Sort";
        "Radix Sort";
        "Quick Sort";
        "Merge Sort";
    |]

let functions = 
    [|
        List.bubbleSort;
        List.selectionSort;
        List.insertionSort;
        List.radixSort;
        List.quickSort;
        List.mergeSort;
    |]

let times = 
    [|0..5|] |> Array.map (fun x -> [|for i in 0..LIMIT -> (0.0, 0.0)|])


warmup()

[|0..LIMIT|] |> Array.Parallel.iter (fun length -> 
    let r = Random()
    let randLists = 
        [| 
            for i in 1..10 -> 
                [1..length] 
                |> List.map (fun _ -> r.Next(-1000000, 1000000))
        |]
    functions
    |> Array.Parallel.iteri (fun i fn -> 
        randLists |> Array.Parallel.iter (fun lis -> 
            let time = timefn fn lis
            let oldt = times.[i].[length]
            let newt = (fst oldt) + time, snd oldt + 1.0
            times.[i].[length] <- newt
        )
    )
)

[ 
    for i in 0..5 ->
        Chart.Line(times.[i] |> Array.mapi (fun i (k, v) -> i, k/v))
] |> Chart.Combine
  