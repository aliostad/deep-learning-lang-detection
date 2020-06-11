module DrawGraph

open System
open System.Diagnostics
open System.IO
open Emgu.CV
open Emgu.CV.UI
open Emgu.CV.CvEnum

let createGraph (graph : string) (processName : string) (graphVizPath : string option) =
    let workingDir = 
        match graphVizPath with
        | Some p -> p
        | None -> String.Empty

    let graphFile = Path.GetTempFileName()
    File.WriteAllText(graphFile, graph)

    match processName with
    | procName when procName = "sfdp.exe" || procName = "dot.exe" ->

        let pi = ProcessStartInfo(Path.Combine(workingDir, processName))
        pi.CreateNoWindow <- true
        pi.ErrorDialog <- false;
        pi.UseShellExecute <- false;
        pi.Arguments <- String.Format("-Tpng -O -Goverlap=prism {0}", graphFile)
        pi.WorkingDirectory <- workingDir
        try
          try
            use proc = new Process();
            proc.StartInfo <- pi
            proc.Start() |> ignore

            proc.WaitForExit()
            if proc.ExitCode = 0 then
                let mat = CvInvoke.Imread(graphFile + ".png", LoadImageType.AnyColor)
                let viewer = new ImageViewer(mat)
                viewer.Text <- graphFile + ".png"
                viewer.Show()
            else failwith "could not create image file"                
          finally
            try
              if File.Exists graphFile then File.Delete graphFile
              if File.Exists (graphFile + ".png") then File.Delete (graphFile + ".png")
            with ex->failwith (sprintf "cleanup failed: %s; %s" ex.Message ex.Source)
        with ex->failwith (sprintf "proc failed: %s; %s" ex.Message ex.Source)
    | _ -> failwith "Unknown graphing process"

let visualizeDot graph = createGraph graph "dot.exe" None
let visualizeSfdp graph = createGraph graph "sfdp.exe" None
let createVisual = visualizeSfdp
let createVisualClusters = visualizeDot