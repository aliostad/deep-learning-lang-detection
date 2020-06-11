// note this file only works in interactive mode

type Info = { State : string; ZipCode : string };;

let allCustomers = [ { State = "State1"; ZipCode = "123456" }
                   ; { State = "State1"; ZipCode = "654321" }
                   ; { State = "State2"; ZipCode = "654333" }
                   ; { State = "State2"; ZipCode = "654333" } ];;

let customerZipCodesByState stateName =
    allCustomers
        |> Seq.filter (fun customer -> customer.State = stateName)
        |> Seq.map (fun customer -> customer.ZipCode)
        |> Seq.distinct;;
    
customerZipCodesByState "State1"
    |> Seq.iter (printfn "%s");;
// 2 zip codes printed

customerZipCodesByState "State2"
    |> Seq.iter (printfn "%s");;
// 1 zip code printed

// "query" enables us to use SQL-like syntax
let customerZipCodesByStateQuery stateName =
    query {
        for customer in allCustomers do
        where (customer.State = stateName)
        select customer.ZipCode
        distinct
    };;

customerZipCodesByStateQuery "State2"
    |> Seq.iter (printfn "%s");;
// 1 zip code printed

open System.Diagnostics

let activeProcCount =
    query {
        // I think it's somehow confusing 
        // because the expression looks like a for statement while actually it's not
        for activeProc in Process.GetProcesses() do count
    };;
// active process count

let memoryHog =
    query {
        for activeProc in Process.GetProcesses() do
        sortByDescending activeProc.WorkingSet64
        head
    };;
// who that takes the most part of memory?

// returns all processes displaying a UI
let windowedProcesses =
    query {
        for activeProc in Process.GetProcesses() do
        where (activeProc.MainWindowHandle <> nativeint 0)
        select activeProc };;

let printProcessList procSeq =
    Seq.iter (printfn "%A") procSeq;;

printProcessList windowedProcesses;;

let isNotepadRunning =
    query {
        for windowedProc in windowedProcesses do
        select windowedProc.ProcessName
        // reads: do some of them contain "notepad"? (I guess)
        contains "notepad" };;
// is notepad running?

// selection operators

let numOfServiceProcesses =
    query {
        for activeProc in Process.GetProcesses() do
        where (activeProc.MainWindowHandle <> nativeint 0)
        // the line below does nothing essentially (I guess)
        // select activeProc
        count};;

let oneHundredNumbersUnderFifty =
    let rng = new System.Random()
    seq {
        for i = 1 to 100 do
            yield rng.Next() % 50 };;

let distinctNumbers =
    query {
        for randomNumber in oneHundredNumbersUnderFifty do
        distinct
        count
    };;
// 1-50 ... randomly

let highestThreadCount =
    query {
        for proc in Process.GetProcesses() do
        maxBy proc.Threads.Count };;

// sorting operators

let sortedProcs =
    query {
        for proc in Process.GetProcesses() do
        let isWindowed = proc.MainWindowHandle <> nativeint 0
        sortBy isWindowed
        thenBy proc.ProcessName
        select proc.ProcessName
    };;

Seq.iter (printfn "%A") sortedProcs;;

#quit;;
