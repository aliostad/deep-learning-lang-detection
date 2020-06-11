namespace OtrDecoder

open System
open System.Diagnostics
open System.IO
open System.Text

type OtrFileDecoder() = 

    member this.DecodeFile file (options: DecodeOptions) = 
        printfn "Dekodiere %s..." file

        if not (Directory.Exists options.OutputDirectory) then
            Directory.CreateDirectory(options.OutputDirectory) |> ignore

        let cutMode = if options.AutoCut then "auto" else "default"
        let decoderProcess = ProcessStartInfo(options.DecoderPath)
        decoderProcess.Arguments <- sprintf "-e %s -p %s -o %s -i %s -f" options.Email options.Password options.OutputDirectory file
        decoderProcess.UseShellExecute <- false
        decoderProcess.RedirectStandardOutput <- true
        decoderProcess.StandardOutputEncoding <- Encoding.UTF8

        if options.AutoCut then
            decoderProcess.Arguments <- decoderProcess.Arguments + (sprintf " -C %s" cutMode)
        
        let p = Process.Start(decoderProcess)

        let mutable procLine = ""
        let mutable noCutlist = true

        procLine <- p.StandardOutput.ReadLine()
        while not (System.String.IsNullOrEmpty procLine) do
            if procLine.Trim().StartsWith("Fortschritt") || procLine.Trim().StartsWith("Progress") then
                noCutlist <- false
                printf "."
            else
                printf "%s %s " Environment.NewLine procLine
            procLine <- p.StandardOutput.ReadLine()
        
        let procEnd = p.WaitForExit

        let mutable result = "" 
        if noCutlist && options.ContinueWithoutCutlist then
            options.AutoCut <- false
            result <- this.DecodeFile file options
        else
            printfn ""
            let fileName = Path.GetFileNameWithoutExtension file
            result <- Directory.EnumerateFiles(options.OutputDirectory)
                        |> Seq.filter(fun f -> Path.GetFileName(f) = fileName)
                        |> Seq.head
        result        