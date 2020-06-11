namespace Commander
open System
open System.Diagnostics
open System.IO
open System.Runtime.InteropServices
open System.Runtime.Serialization
open System.ServiceProcess
open Api

exception AlreadyExistError 

[<DataContract>]
type NewName = {
    [<DataMember(EmitDefaultValue = false)>]
    mutable directory: string
    [<DataMember(EmitDefaultValue = false)>]
    mutable newName: string 
    [<DataMember(EmitDefaultValue = false)>]
    mutable oldName: string 
    [<DataMember(EmitDefaultValue = false)>]
    mutable makeCopy: string }

[<DataContract>]
type ProcessItemType = {
    [<DataMember(EmitDefaultValue = false)>]
    mutable file: string
    [<DataMember(EmitDefaultValue = false)>]
    mutable openWith: bool
    [<DataMember(EmitDefaultValue = false)>]
    mutable showProperties: bool }

module Operation =
    let CreateFolder (newName: NewName) = 
        let path = Path.Combine(newName.directory, newName.newName)
        if Directory.Exists path then
            raise (AlreadyExistError)
        else
            Directory.CreateDirectory(path) |> ignore
     
    let OpenWith file =
        let p = Process.Start("rundll32.exe", sprintf "shell32, OpenAs_RunDLL %s" file)
        Api.SetActiveWindow p.MainWindowHandle |> ignore

    let ShowProperties file =
        let mutable info = new Api.ShellExecuteInfo (Verb = "properties", File = file, Show = Api.SW_SHOW, Mask = Api.SEE_MASK_INVOKEIDLIST)
        info.Size <- Marshal.SizeOf info
        Api.ShellExecuteEx &info |> ignore
        Api.SetActiveWindow info.Hwnd |> ignore

    let Show file =
        let p = new Process ()
        p.StartInfo.UseShellExecute <- true
        p.StartInfo.ErrorDialog <- true
        p.StartInfo.FileName <- file
        p.Start () |> ignore
