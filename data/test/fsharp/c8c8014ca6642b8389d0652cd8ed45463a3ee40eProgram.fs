open System.Diagnostics

let generateInput ran = Generator.Codevs1082 ran

let startProcess fileName =
    let startInfo =
            ProcessStartInfo(
                FileName = fileName,
                UseShellExecute = false,
                RedirectStandardInput = true,
                RedirectStandardOutput = true)
    let process' = new Process(StartInfo = startInfo)
    process'.Start() |> ignore
    process'
    
let compare (input : string) targetPath examplePath =
    let getResult (process' : Process) =
        let writer = process'.StandardInput
        let reader = process'.StandardOutput
        writer.WriteLine input
        reader.ReadToEnd()
    use targetProcess = startProcess targetPath
    use exampleProcess = startProcess examplePath
    let result =
        let targetOutput = getResult targetProcess
        let exampleOutput = getResult exampleProcess
        targetOutput = exampleOutput
    if not result then printfn "Test Failed. Input:\n%A" input
    result


let (|Int|_|) str =
    let vaild, num = System.Int32.TryParse str
    if vaild then Some num else None
    
[<EntryPoint>]
let main = 
    function
    | [|Int times; targetPath; examplePath|] ->
        let ran = System.Random()
        let beat _ =
            let input = generateInput ran
            compare input targetPath examplePath
        let result = 
            { 1..times }
            |> Seq.map beat
            |> Seq.reduce (&&)
        if result then 0 else 1
    | _ ->
        printfn "Argument error."
        255
