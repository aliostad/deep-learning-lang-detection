module Pather.RemoteProcess

open System
open System.Diagnostics
open System.IO.Pipes
open System.IO
open System.Text
open Pather
open System.Reflection

let private injectionPath =
    let basePath = System.AppDomain.CurrentDomain.BaseDirectory
    {
        Native.LibraryPath.Path86 = Path.Combine(basePath, "Injections", "Injection.x86.dll")
        Native.LibraryPath.Path64 = Path.Combine(basePath, "Injections", "Injection.x64.dll")
    }

let private unpackInjections () =    
    let archs = [ 
        ("x64", injectionPath.Path64) 
        ("x86", injectionPath.Path86) 
    ]

    let reader = new System.Resources.ResourceManager("Pather.g", Assembly.GetExecutingAssembly())

    archs |> Seq.iter (fun (arch, path) ->
        Path.GetDirectoryName path |> Directory.CreateDirectory |> ignore

        use resStream = reader.GetStream(sprintf "injections/injection.%s.dll" arch)
        use fileStream = File.Create(path)

        resStream.CopyTo(fileStream)
    )

let openChannel (processId: int) =    
    unpackInjections ()

    use proc = Process.GetProcessById(processId)
    
    let pipeName = sprintf "pather\%d" processId
    
    let pipe = new NamedPipeServerStream(pipeName, PipeDirection.InOut, 1, PipeTransmissionMode.Message)            

    Native.injectLibrary proc.Handle injectionPath

    pipe.WaitForConnection()

    pipe

let pingPong (channel: NamedPipeServerStream) =
    channel.WriteByte(45uy)

    channel.ReadByte() = 54

let setEnvVar (channel: NamedPipeServerStream) (variable: string) (value: string) =
    use writer = new BinaryWriter(channel, Encoding.Unicode)    

    writer.Write(01uy)
    writer.Write(variable)
    writer.Write(value)

    channel

let readEnvVar (channel: NamedPipeServerStream) (variable: string) =
    use writer = new BinaryWriter(channel, Encoding.Unicode)
    writer.Write(02uy)
    writer.Write(variable)
    
    use reader = new BinaryReader(channel, Encoding.Unicode)
    reader.ReadString()    

let readPathSet (processId : int) = 
    use channel = openChannel processId
    readEnvVar channel "PATH" |> PathSet.fromEnvVar

let setPath (processId : int) (path : PathSet.PathSet) = 
    use channel = openChannel processId    
    setEnvVar channel "PATH" (PathSet.toEnvVar path) |> ignore


let parentProcessId () =
    use snapshot = ToolHelp.createSnapshot ToolHelp.SnapshotFlags.Process 0
    let currentProcessId = Process.GetCurrentProcess().Id
    let currentProcess = ToolHelp.processes snapshot |> Seq.find (fun p -> p.ProcessId = currentProcessId)

    currentProcess.ParentProcessId