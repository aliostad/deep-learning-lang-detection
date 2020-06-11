open System.IO
open System.Diagnostics
open System.Threading

let pnames = Process.GetProcessesByName("pikatwo");
for proc in pnames do
    proc.Kill()
    proc.WaitForExit()

let delDir dir =
    let dirInfo = new DirectoryInfo(dir)
    for file in dirInfo.GetFiles() do
        file.Delete() |> ignore
    for dir in dirInfo.GetDirectories() do
        dir.Delete(true) |> ignore

if Directory.Exists("Production") then
    if File.Exists("Production/githubAnnounceHistory.json") then
        let rel = File.GetLastWriteTime("Release/githubAnnounceHistory.json")
        let prod = File.GetLastWriteTime("Production/githubAnnounceHistory.json")
        if(rel < prod) then
            File.Delete("Release/githubAnnounceHistory.json")
            File.Copy("Production/githubAnnounceHistory.json", "Release/githubAnnounceHistory.json")
    if File.Exists("Production/debugOut.txt") then
        let rel = File.GetLastWriteTime("Release/debugOut.txt")
        let prod = File.GetLastWriteTime("Production/debugOut.txt")
        if(rel < prod) then
            File.Delete("Release/debugOut.txt")
            File.Copy("Production/debugOut.txt", "Release/debugOut.txt")
        
    delDir "Production/responseData"
    delDir "Production"
else
    Directory.CreateDirectory("Production") |> ignore

try
    File.Copy("Release/Pikatwo.exe", "Production/Pikatwo.exe")
    File.Copy("Release/Newtonsoft.Json.dll", "Production/Newtonsoft.Json.dll")
    File.Copy("Release/StarkSoftProxy.dll", "Production/StarkSoftProxy.dll")
    File.Copy("Release/Meebey.SmartIrc4net.dll", "Production/Meebey.SmartIrc4net.dll")
    File.Copy("Release/log4net.dll", "Production/log4net.dll")
    File.Copy("Release/HtmlAgilityPack.dll", "Production/HtmlAgilityPack.dll")
    File.Copy("Release/githubConfig.json", "Production/githubConfig.json")
    File.Copy("Release/githubAnnounceHistory.json", "Production/githubAnnounceHistory.json")
    File.Copy("Release/auth.json", "Production/auth.json")   
    File.Copy("Release/config.json", "Production/config.json")
    let responseFiles = Directory.GetFiles("Release/responseData")
    Directory.CreateDirectory("Production/responseData") |> ignore
    for i in 0..(responseFiles.Length-1) do
        File.Copy(responseFiles.[i], "Production/responseData/" + string i + ".json")
with
    :? System.IO.FileNotFoundException -> 
        System.Console.WriteLine("There's a config file/dependency missing. Check release version that has all config files/dependencies.")

let startInfo = new ProcessStartInfo();
startInfo.WorkingDirectory <- "Production"
let pikaDir = Directory.GetCurrentDirectory() + "\\Production\\Pikatwo.exe"
startInfo.FileName <- pikaDir
Process.Start(startInfo) |> ignore

System.Console.WriteLine("Deployed successfully, press any key to close")
System.Console.ReadKey() |> ignore