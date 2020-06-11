module Main

open System
open System.IO

// main function
[<EntryPoint>]
let main (args:string[]) =
    if args.Length <> 4 then
        printf "I need 4 args: numOfBodies numOfSteps ver parver"
        1
    else
        //Process.GetCurrentProcess().ProcessorAffinity <- nativeint 8 // new System.IntPtr(0x007F)
        //Console.WriteLine(Environment.ProcessorCount)
        //Console.WriteLine(Process.GetCurrentProcess().ProcessorAffinity)
        //Console.WriteLine("Press Enter to start...")
        //Console.ReadLine() |> ignore
        let n = (int) (Array.get args 0)
        let steps = (int) (Array.get args 1)
        let v = (Array.get args 2)
        let pv = (int) (Array.get args 3)
        match v with
        | "bhlist"      -> BHList.run n steps pv
        | "bhlazylist"  -> BHLazyList.run n steps pv
        | "bharr"       -> BHArr.run n steps pv
        | "bhseq"       -> BHSeq.run n steps pv
        | "allpairs"    -> Allpairs.run n steps pv
        | _ -> BHList.run n steps pv
        Console.ReadLine() |> ignore
        0 // return status: success
