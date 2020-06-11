module Program

open Nagato
open System
open System.IO

let loop name commands f =
  printfn "(moved to..) %s" name
  printfn "commands are ===> %s" commands
  Seq.initInfinite(fun _ -> printf "%s> " name ; Console.ReadLine())
  |> Seq.takeWhile((<>)"q")
  |> Seq.iter f

module Bash =
  let mutable currentDirectory = @"C:\"
  let files () = 
    Directory.GetFiles (currentDirectory)
    |> Seq.map(fun name -> DirectoryInfo name)
    |> print_lines
  let dirs  () = 
    Directory.GetDirectories(currentDirectory)
    |> Seq.map(fun name -> (FileInfo name).Name)
    |> print_lines
  let loop () =
    loop "bash" "ls q" <| function
      | "files" -> files ()
      | "dirs"  -> dirs ()
      | s -> printfn "%s is invalid command" s
                      
module MyCommands =
  let private startProcess (s:string) =
    try
      printfn "(I did..) %s" s 
      System.Diagnostics.Process.Start s |> ignore
    with 
      e -> printfn "%A" e

  let openRoot    ws = ws |> unwords |> startProcess
  let openCDrive  ws = @"C:\" + unwords ws |> startProcess
  let taskmgr     () = @"C:\WINDOWS\system32\taskmgr.exe" |> startProcess
  let nagatoPaint () = @"C:\fsn\NagatoPaint\bin\Debug\NagatoPaint.exe" |> startProcess
  let msysgit     () = 
    let p = Process.runConsole @"C:\msysgit\msysgit\bin\sh.exe" "--login -i"
    p.BeginOutputReadLine()
    p.OutputDataReceived => fun e ->
      if not(String.IsNullOrWhiteSpace e.Data) 
        then  printf "%s\ngit> " e.Data
    p.StandardInput.WriteLine "cd /c/fsn/"
    let mutable line = ""
    while line <> "q" do
      print "git> "
      line <- Console.ReadLine()
      p.StandardInput.WriteLine (sprintf "git %s" line)

module FsShuttle =
  let loop () =
    loop "fss" "fparsec nagato q" <| function
      | "fparsec" -> FsShuttle.Reference.fparsec ()
      | "nagato"  -> FsShuttle.Reference.nagato  ()
      | s -> printfn "%s is invalid command" s

module Blog =
  let about_fsn () = Blog.about_fsn |> FsShuttle.MetaClipboard.setText
  let loop () =
    loop "blog" "fsn q" <| function
      | "fsn" -> about_fsn ()
      | s -> printfn "%s is invalid command" s

[<EntryPoint>][<STAThread>]
let main _ =
  loop "nagatosh" "open openc taskmgr fss np git q" <| fun cmd ->
    let ws = split_string false " " cmd
    match ws with
    | w::ws ->
      match w with
      | "bash"      -> Bash.loop ()
      | "blog"      -> Blog.loop ()
      | "open"      -> MyCommands.openRoot ws
      | "openc"     -> MyCommands.openCDrive ws
      | "taskmgr"   -> MyCommands.taskmgr     ()
      | "fss"       -> FsShuttle.loop         ()
      | "np"        -> MyCommands.nagatoPaint ()
      | "git"       -> MyCommands.msysgit     ()
      | word        -> printfn "%s is invalid command" word
    | _   -> ()
  0