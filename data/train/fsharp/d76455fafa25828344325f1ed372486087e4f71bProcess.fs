module Process

open System
open System.Diagnostics
open System.Runtime.InteropServices

// This part of Code I want on C++0x CLI

let ByteToHex bytes = 
    bytes 
    |> Array.map (fun (x : byte) -> System.String.Format("{0:X2}", x))
    |> String.concat System.String.Empty

let getProcess pc =   
    Process.GetProcesses() |> fun pcs ->
        try
            pcs |> Array.find(fun p -> p.ProcessName = pc), true
        with
        | :? System.Collections.Generic.KeyNotFoundException -> null, false
        | _ -> null, true

let getModule(m : string, pcs : Process * bool) =
    if snd pcs then
        [for mx in (fst pcs).Modules ->
            if mx.ModuleName.ToLower() = m then
                Some(mx)
            else
                None ]
        |> Seq.choose id 
        |> Seq.head
        |> fun mdls ->
            if mdls <> null then
                mdls.BaseAddress.ToInt32()
            else 0
    else 0