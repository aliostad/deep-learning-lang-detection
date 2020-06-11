module Helpers

open System
open System.Collections.Generic
open System.Diagnostics
open System.IO
open System.Security.Cryptography;
open System.Text.RegularExpressions

let HomeDirectory = Environment.GetFolderPath(Environment.SpecialFolder.Personal)

let (|Regex|_|) pattern input =
    if (isNull input) then None else
    let m = Regex.Match(input, pattern)
    if m.Success then Some(List.tail [ for g in m.Groups -> g.Value ])
    else None

let system s =
    let filename  = Seq.head s
    let arguments = Seq.tail s |> String.concat " "

    let psi = ProcessStartInfo
                (RedirectStandardOutput = true, RedirectStandardError = true, UseShellExecute = false,
                 FileName = filename, Arguments = arguments)
    let outputs = List<string>()
    let handler f (_sender: obj) (args: DataReceivedEventArgs) = f args.Data
    let p = new Process(StartInfo = psi)

    p.OutputDataReceived.AddHandler(DataReceivedEventHandler (handler outputs.Add))
    p.Start() |> ignore
    p.BeginOutputReadLine()
    p.BeginErrorReadLine()
    p.WaitForExit()
    outputs

let md5File filename =
    use md5 = MD5.Create()
    use stream = File.OpenRead filename
    BitConverter
        .ToString(md5.ComputeHash stream)
        .Replace("-", "‌​")
        .ToLower()
