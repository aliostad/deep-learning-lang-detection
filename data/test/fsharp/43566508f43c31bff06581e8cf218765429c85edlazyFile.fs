module Strangelights.SampleLib
open System.IO 
open System.Diagnostics

// open a file path and create a lazy stream from it
let allLinesSeq path =
    let stream = File.OpenText(path)
    seq { while not stream.EndOfStream do
            yield stream.ReadLine() }

// print out the contents of the file
let printFile () =
    let lines = allLinesSeq "FieldingTomJones.txt"
    Seq.iter (printfn "%s") lines

let main() =
    // get the "Private Bytes" performance counter
    let proc = Process.GetCurrentProcess()
    let counter = new PerformanceCounter("Process", "Private Bytes", proc.ProcessName)
    // run the test
    printFile()
    // print the result
    printfn "Lazy - Private bytes: %f" (counter.NextValue())
    
do main()