module EnvironmentInjectionTests

open Xunit
open FsUnit.Xunit
open System.Diagnostics
open System.IO
open Pather

let helperPath = EnvInjectionHelper.Marker.Marker.Assembly.Location

type HelperProcess = { In: StreamWriter; Out: StreamReader; Id: int }

let write (input:string) (proc: HelperProcess) =
    proc.In.Write(input)
    proc

let read (proc: HelperProcess) =
    proc.Out.ReadLine()

let set (name: string) (value:string) (proc: HelperProcess) =
    proc
    |> write (sprintf "S%s\n%s\n" name value)     
    |> read
    |> ignore
    
    proc

let get (name: string) (proc: HelperProcess) =
    proc
    |> write (sprintf "R%s\n" name)
    |> read

let helper (action) =
    let startInfo = ProcessStartInfo(helperPath)
    
    startInfo.RedirectStandardInput <- true
    startInfo.RedirectStandardOutput <- true
    startInfo.RedirectStandardError <- false
    startInfo.UseShellExecute <- false

    let proc = Process.Start(startInfo)            

    let result = try
                    action { In = proc.StandardInput; Out = proc.StandardOutput; Id = proc.Id }
                 finally
                    proc.Kill()

    result

[<Fact>]
let ``Helper process is working correctly`` () =     
    helper (write "E" >> read >> should equal "echo")

[<Fact>]
let ``Helper process reports env variable value`` () =
    helper (set "VAR1" "MyValue" >> get "VAR1" >> should equal "MyValue")
    
[<Fact>]
let ``Should read PathSet from process`` () =
    helper (fun proc ->
        let pathSet = [ "C:\MyPath1"; "C:\MyPath2" ] |> Seq.map PathName.FromString |> PathSet.fromSeq

        proc |> set "PATH" (pathSet |> PathSet.toEnvVar) |> ignore

        let remotePathSet = RemoteProcess.readPathSet proc.Id

        remotePathSet |> should equal pathSet
    )

[<Fact>]
let ``Should set PathSet in process`` () =
    helper (fun proc ->
        let pathSet = [ "C:\MyPath1"; "C:\MyPath2" ] |> Seq.map PathName.FromString |> PathSet.fromSeq

        RemoteProcess.setPath proc.Id pathSet

        let remotePathSet = proc |> get "PATH" |> PathSet.fromEnvVar

        remotePathSet |> should equal pathSet
    )

[<Fact>]
let ``Should do injection ping-ping`` () =
    helper (fun proc ->
        use channel = RemoteProcess.openChannel proc.Id

        RemoteProcess.pingPong channel |> should equal true
    )