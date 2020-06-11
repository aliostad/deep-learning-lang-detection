module Strangelights.Sample
open Strangelights.SampleLib
open System.IO 
open System.Diagnostics

// print out the contents of the file
let printFile () =
    let lines = File.ReadAllLines("FieldingTomJones.txt")
    Seq.iter (printfn "%s") lines

let main() =
    // get the "Private Bytes" performance counter
    let proc = Process.GetCurrentProcess()
    let counter = new PerformanceCounter("Process", "Private Bytes", proc.ProcessName)
    // run the test
    printFile()
    // print the result
    printfn "All  - Private bytes: %f" (counter.NextValue())
        
do main()