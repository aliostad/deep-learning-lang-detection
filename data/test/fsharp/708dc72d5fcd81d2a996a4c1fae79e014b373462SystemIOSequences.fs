open System
open System.IO
open System.Diagnostics

let wordCount() = 
    // Get the "Private Bytes" performance counter:
    let proc = Process.GetCurrentProcess()
    let counter = new PerformanceCounter("Process", 
                                         "Private Bytes", 
                                         proc.ProcessName)

    // (Download this file from http://www.gutenberg.org/ebooks/6593
    // and change the path below to its location.)

    // Read the file:
    let lines = File.ReadAllLines(@"C:\Data\Gutenberg\TomJones\TomJones.txt")

    // Uncomment this line and comment the one above to compare the 
    // performance of ReadAllLines and ReadLines.

    //let lines = File.ReadLines(@"C:\Data\Gutenberg\TomJones\TomJones.txt")

    // Do a very naive unique-word count (to prove we get
    // the same results whichever way we access the file)
    let wordCount = 
        lines
        |> Seq.map (fun line -> line.Split([|' '|]))
        |> Seq.concat
        |> Seq.distinct
        |> Seq.length
    printfn "Private bytes: %f" (counter.NextValue())
    printfn "Word count: %i" wordCount

[<EntryPoint>]
let main argv = 
    wordCount ()
    Console.ReadKey() |> ignore
    0
