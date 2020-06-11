module Google.Cloud.Datastore.Emulator.Core
open System.Diagnostics
open System
open System.Runtime.InteropServices

[<System.Runtime.InteropServices.Guid("259CB426-2F44-4B03-A818-DAA7413C432D")>]
type EmulatorOutput = { Port: int}
let private emulatorStartInfoByOS() =
    if RuntimeInformation.IsOSPlatform(OSPlatform.Windows) then
         System.Diagnostics.ProcessStartInfo("cmd.exe", 
                                arguments = "/c gcloud beta emulators datastore start",
                                UseShellExecute = false,
                                RedirectStandardOutput = true,
                                CreateNoWindow = false)
    else
        System.Diagnostics.ProcessStartInfo("cmd.exe", 
                            arguments = "/c gcloud beta emulators datastore env-init",
                            UseShellExecute = false,
                            RedirectStandardOutput = true,
                            CreateNoWindow = false)    
let private emulatorVarsByOS() = 
   if RuntimeInformation.IsOSPlatform(OSPlatform.Windows) then
        System.Diagnostics.ProcessStartInfo("cmd.exe", 
                                arguments = "/c gcloud beta emulators datastore env-init",
                                UseShellExecute = false,
                                RedirectStandardOutput = true,
                                CreateNoWindow = false)
    else
        System.Diagnostics.ProcessStartInfo("cmd.exe", 
                            arguments = "/c gcloud beta emulators datastore env-init",
                            UseShellExecute = false,
                            RedirectStandardOutput = true,
                            CreateNoWindow = false)
type DataStoreEmulator() = 
    let emulator = new Process()
    let setVars = new Process() 
    member this.Start() =
        emulator.StartInfo <- emulatorStartInfoByOS()
        setVars.StartInfo <- emulatorVarsByOS()
        emulator.Start() |> ignore
        setVars.Start() |> ignore
        let mutable port = 0
        while (not setVars.StandardOutput.EndOfStream) && port = 0 do
            let line = setVars.StandardOutput.ReadLine()
            let isHostConfig = line |> (fun (l :string) -> l.Contains("DATASTORE_EMULATOR_HOST"))
            if isHostConfig then
                port <- line.Split(':').[1] |> int
        {Port = port}

    member this.Stop() =
        if (not setVars.HasExited) then
            setVars.Kill();
        if (not emulator.HasExited) then
            emulator.Kill()
            
        setVars.Dispose()
        emulator.Dispose()  

    interface IDisposable with
        member this.Dispose() = 
            this.Stop()
