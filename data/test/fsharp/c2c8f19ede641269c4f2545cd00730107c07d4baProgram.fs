
open System.IO
open ProcessRippleConfig

[<EntryPoint>]
let main argv =
    let slnDir = argv.[0]
    let lines = (slnDir, {Framework=argv.[1]; Source=argv.[2]}) ||> processRippleConfig
    File.WriteAllLines(Path.Combine(slnDir,"paket.dependencies"), lines)
    ProcessFileNames.renameRippleDependencyFiles slnDir
    File.Delete(Path.Combine(slnDir,"ripple.config"))
    let paketDir = Path.Combine(slnDir, ".paket")
    Directory.CreateDirectory(paketDir) |> ignore
    let url = "https://github.com/fsprojects/Paket/releases/download/3.8.1/paket.bootstrapper.exe"
    let tmp = Path.GetTempFileName()
    use wc = new System.Net.WebClient()
    wc.set_Proxy(null)
    wc.DownloadFile(url, tmp)
    let bootstraperExePath = Path.Combine(paketDir, "paket.bootstrapper.exe")
    File.Move(tmp, bootstraperExePath)
    System.Diagnostics.Process.Start(bootstraperExePath) |> ignore
    File.AppendAllLines(Path.Combine(slnDir, ".gitignore"), [|".paket/paket.exe"|])
    0
