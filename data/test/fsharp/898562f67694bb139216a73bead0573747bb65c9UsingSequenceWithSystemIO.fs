module UsingSequenceWithSystemIO

// what will be covered in this chapter include the following 
//  1. use F#'s lazy evaluation to handle visiting file contents in a lazy fashion

open System.IO

// open a file path and crate a lazy stream from it
let allLinesSeq path = 
    let stream = File.OpenText(path) 
    seq { while not stream.EndOfStream do 
        yield stream.ReadLine() }

(*

you can try to use the perfmon.exe to examine how much performance has been gained from the use of the lazy evaluation.
*)

open System.IO
open System.Diagnostics

// print out the contents of the file 
let printFile () = 
    let lines = File.ReadAllLines("FieldingTomJones.txt") 
    Seq.iter(printfn "%s") lines

let main() = 
    // get the "Private Bytes" performance counter 
    let proc = Process.GetCurrentProcess()
    let counter = new PerformanceCounter("Process",
                                        "Private Bytes",
                                        proc.ProcessName)

    // run the test 
    printFile()
    // print the result 
    printfn "All - Private bytes: %f" (counter.NextValue())

do main()


(*

you can try the following lazy method that read the contents 


// Next, you measure the performance of lazy loading a file using your F# sequence code, you use exactly the same method 
// to try the test with is as fair as possible

open System.IO
open System.Diagnostics

// open a file path and create a lazy stream from it
let allLinesSeq path = 
    let stream = File.OpenText(path)
    seq { while not stream.EndOfStream do
        yield stream.ReadLine() }

// print out the contents of the file 
let printFile() =
    let lines = allLinesSeq "FieldingTomJones.txt"
    Seq.iter (printfn "%s") lines

let main() = 
    // get the "Private Bytes" performance counter 
    let proc = Process.GetCurrentProcess()
    let counter = new PerformanceCounter("Process",
                                        "Private Bytes",
                                        proc.ProcessName)

    // run the test 
    printFile()
    // print the result 
    printfn "All - Private bytes: %f" (counter.NextValue())
do main()

*)