open OpenHardwareMonitor.Hardware
open System.Diagnostics
open System.IO
open System.Threading
open System

// Learn more about F# at http://fsharp.org
// See the 'F# Tutorial' project for more help.
[<EntryPoint>]
let main argv = 
    let com = new Computer()
    com.CPUEnabled <- true
    //    com.MainboardEnabled <- true
    //    com.FanControllerEnabled <- true
    //    com.GPUEnabled <- true
    //    com.HDDEnabled <- true
    //    com.RAMEnabled <- true
    com.Open()
    let getSensor (sens : SensorType) (hws : IHardware array) = 
        hws
        |> Seq.collect (fun h -> h.Sensors)
        |> Seq.filter (fun s -> s.SensorType = sens && s.Name <> "CPU Total")
        |> Seq.map (fun s -> s.Value.GetValueOrDefault())
        |> Seq.filter (fun v ->  v <> 0.0f)
        |> Seq.toArray
    
    let processs = Process.GetProcesses()
    
    let boincThings = 
        Directory.EnumerateFiles(@"C:\ProgramData\BOINC\projects\www.worldcommunitygrid.org\")
        |> Seq.toArray
        |> Array.map (fun x -> Path.GetFileName(x))
        |> Set.ofArray
    
    let boincProcess = processs |> Array.filter (fun x -> boincThings.Contains x.ProcessName)
    let loadbyBoinc = boincProcess.[0].TotalProcessorTime
    let coutners = boincProcess |> Array.map (fun bp -> new PerformanceCounter("Process", "% Processor Time", bp.ProcessName, true ))
    let total = new PerformanceCounter("Processor", "% Processor Time", "_Total" , true) 
    while true do
       let temp = (getSensor SensorType.Temperature com.Hardware) |> Array.average
       let load = (getSensor SensorType.Load com.Hardware) |> Array.sum
       let values = coutners |> Array.map (fun c -> c.NextValue() / float32 Environment.ProcessorCount)
       let totalt = total.NextValue()
       let sum = values |> Array.sum
       printfn "Boinc: %A \t all:%A \t not_boinc: %A" sum totalt (totalt - sum) 
       Thread.Sleep(1000)
    printfn "%A" argv
    0 // return an integer exit code
