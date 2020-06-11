module TryFSharp.Site

open Fake
open System.IO
open TryFSharp.Helpers
open TryFSharp.Document

/// Turn tutorials in source folder into HTML files in the output folder
let processTutorials cfg changes = 
  let layoutFiles = !! (cfg.Layouts </> "*.*")  |> List.ofSeq
  let sources = !! (cfg.Tutorials </> "*.*") 
  let mutable anyChanges = false
  for f in sources do
    let outDir = Path.ChangeExtension(f.Replace(cfg.Tutorials, cfg.Output </> "tutorial"), "").TrimEnd('.') 
    let outMain = outDir </> "index.html"
    match f, changes with
    | f, Some changes when not (Set.contains f changes) -> ()
    | f, _ when Helpers.sourceChangedSeq (Seq.append [f] layoutFiles) outMain ->
        anyChanges <- true
        printfn "Processing file: %s" (f.Replace(cfg.Tutorials, ""))
        let tutorial = parseTutorial cfg f
        ensureDirectory outDir
        File.WriteAllText(outMain, DotLiquid.render "tutorial.html" tutorial)
        for i in 0 .. tutorial.Sections.Length - 1 do
          ensureDirectory (outDir </> string i)
          let tutorial = { tutorial with CurrentSection = i }
          File.WriteAllText(outDir </> string i </> "index.html", DotLiquid.render "tutorial.html" tutorial)        
    | _ -> () 
  anyChanges

/// Copy files from source directory to output
let copyFiles (cfg:SiteConfig) changes =
  let sources = !! (cfg.Static </> "**/*.*")
  for f in sources do
    match f, changes with
    | f, Some changes when not (Set.contains f changes) -> ()
    | _ -> 
        let outf = f.Replace(cfg.Static, cfg.Output)
        if sourceChanged f outf then
          printfn "Copying file: %s" (f.Replace(cfg.Static, ""))
          ensureDirectory (Path.GetDirectoryName(outf))
          File.Copy(f, outf, true)

/// Read all tutorials for the home page
let readTutorials (cfg:SiteConfig) = 
  let sources = !! (cfg.Tutorials </> "*.*") 
  { Tutorials = [| for f in sources -> parseTutorial cfg f |] }