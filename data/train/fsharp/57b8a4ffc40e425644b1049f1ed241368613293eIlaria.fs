// A small command line utility to transform markdown to html
module Ilaria

open System
open System.IO

open FSharp.Markdown

open CommandLineOptions

let rec parseCommandArgsRec args optionsSoFar =
  match args with
  | [] -> optionsSoFar

  | "-?"::xs | "--help"::xs ->
    let newOptionsSoFar = {optionsSoFar with DisplayHelp = true}
    parseCommandArgsRec xs newOptionsSoFar

  | "-toc"::xs ->
    let newOptionsSoFar = {optionsSoFar with GenerateToc = true}
    parseCommandArgsRec xs newOptionsSoFar

  | "-verbose"::xs | "-v"::xs ->
    let newOptionsSoFar = {optionsSoFar with Verbose = true}
    parseCommandArgsRec xs newOptionsSoFar

  | "-css"::xs ->
    match xs with
      | s::xss ->
        let newOptionsSoFar = {optionsSoFar with CssFile = s}
        parseCommandArgsRec xss newOptionsSoFar
      | _ ->
        eprintfn "Must specify a file"
        parseCommandArgsRec xs optionsSoFar

  | "-sourceDir"::xs | "-s"::xs ->
    match xs with
    | s::xss ->
      let newOptionsSoFar = {optionsSoFar with SourceDir = s}
      parseCommandArgsRec xss newOptionsSoFar
    | _ ->
      eprintfn "Must have a directory"
      parseCommandArgsRec xs optionsSoFar

  | "-destinationDir"::xs | "-d"::xs ->
      match xs with
      | s::xss ->
        let newOptionsSoFar = {optionsSoFar with DestinationDir = s}
        parseCommandArgsRec xss newOptionsSoFar
      | _ ->
        eprintfn "Must have a directory"
        parseCommandArgsRec xs optionsSoFar

  | "-resourceDir"::xs | "-s"::xs ->
        match xs with
        | s::xss ->
          let newOptionsSoFar = {optionsSoFar with ResourceDir = s}
          parseCommandArgsRec xss newOptionsSoFar
        | _ ->
          eprintfn "Must have a directory"
          parseCommandArgsRec xs optionsSoFar

    | x::xs ->
        eprintfn "Unrecognized options"
        parseCommandArgsRec xs optionsSoFar

let parseCommandArgs args =
  parseCommandArgsRec args defaultOptions

let css_start = "
  <link rel=\"stylesheet\" href=\"{0}\">
    <style>
        .markdown-body {{
            box-sizing: border-box;
            min-width: 200px;
            max-width: 980px;
            margin: 0 auto;
            padding: 45px;
        }}
      </style>
  <article class=\"markdown-body\">"

let css_end = "</article>"

let createCssWrapper cssFile =
    if File.Exists(cssFile) then
      Some ( System.String.Format(css_start, Path.GetFileName cssFile) , css_end)
    else
      None

[<EntryPoint>]
let main argv =
    let argRecord = parseCommandArgs (Seq.toList argv)
    let source = argRecord.SourceDir
    let dest = argRecord.DestinationDir
    let res = argRecord.ResourceDir
    let verbose = argRecord.Verbose
    let cssFile = argRecord.CssFile
    let showHelp = argRecord.DisplayHelp

    if showHelp then
      printfn "%s" helpText

    else
      let logContents = ""
      let filesToConvert = Directory.GetFiles(source, "*.md")
      let resourceFiles = Directory.GetFiles(res, "*.*")
      let cssWrapper = createCssWrapper cssFile

      // copy CSS to destination if using one
      match cssWrapper with
        | Some (a, b) ->
          let cssFileName = Path.GetFileName cssFile
          let logMessage = String.Format("{0} used for style sheet", cssFileName)
          let copyCssFileMessage = String.Format("Copying "{0} to {1}", cssFile, dest + cssFileName)
          printfn "%s" logMessage
          if verbose then
            printfn "%s" copyCssFileMessage

          File.Copy(cssFile, dest + cssFileName, true)
        | None ->
          if verbose then
            eprintfn "No CSS will be used either because none was specified or
the specified file did not exist."
          else ()

      // convert Markdown and copy to destination
      for f in filesToConvert do
        let newFileName = dest + Path.GetFileNameWithoutExtension f + ".html"
        let markdownText = File.ReadAllText f
        let transformedHtml = Markdown.TransformHtml markdownText
        let createFormattedHtml css =
          match css with
            | None ->
              transformedHtml
            | Some (a, b) ->
              a + transformedHtml + b

        if verbose then
          printfn "creating file %s from %s" newFileName f

        File.WriteAllText(newFileName, createFormattedHtml cssWrapper)

      // copy resources to destination. Need to be a little smarter about this
      // rather than copy all files in the directory
      for f in resourceFiles do
        File.Copy(f, dest + Path.GetFileName f, true)


    0 // return an integer exit code
