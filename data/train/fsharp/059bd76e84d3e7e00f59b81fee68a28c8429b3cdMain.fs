module Main





open FsLab
open FSharp.Literate


module FileUtilities =
  open System
  open System.IO

  let (@@) a b = Path.Combine(a, b)

  let ensureDirectory path =
    let dir = DirectoryInfo(path)
    if not dir.Exists then dir.Create()

  let rec copyFiles source target =
    ensureDirectory target
    for f in Directory.GetDirectories(source) do
      copyFiles f (target @@ Path.GetFileName(f))
    for f in Directory.GetFiles(source) do
      File.Copy(f, (target @@ Path.GetFileName(f)), true)

open FileUtilities

[<EntryPoint>]
let main args = 
  // Usage:
  //
  //  --latex              Generate output as LaTeX rather than the default HTML
  //  --non-interactive    Do not open the generated HTML document in web browser
  //
  let templatePath = System.IO.Path.Combine(__SOURCE_DIRECTORY__, "templates/")
  let folderExists = System.IO.Directory.Exists(templatePath)
  let fileExists = System.IO.File.Exists(templatePath)
  let latex = args |> Seq.exists ((=) "--latex")
  let browse = args |> Seq.exists ((=) "--non-interactive") |> not
  if latex then Journal.Process(outputKind = OutputKind.Latex)
  else Journal.Process(browse,templateLocation=templatePath)

  
  copyFiles (__SOURCE_DIRECTORY__ @@ "output") @"..\articles\fsjournal\"
  0
