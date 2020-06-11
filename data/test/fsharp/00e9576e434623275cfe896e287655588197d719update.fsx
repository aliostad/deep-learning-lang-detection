open System.Diagnostics

let shellExecute program args =
    let startInfo = new ProcessStartInfo()
    startInfo.FileName <- program
    startInfo.Arguments <- args
    startInfo.UseShellExecute <- true

    let proc = Process.Start(startInfo)
    proc.WaitForExit()
    ()

//shellExecute "C:\\Program Files\\Java\\jre1.8.0_51\\bin\\java.exe" "-jar C:\\home\bin\\plantuml\\plantuml.jar architecture.plantuml"

shellExecute "C:\\Program Files\\Java\\jre1.8.0_51\\bin\\java.exe" "-jar C:\\home\bin\\plantuml\\plantuml.jar"
