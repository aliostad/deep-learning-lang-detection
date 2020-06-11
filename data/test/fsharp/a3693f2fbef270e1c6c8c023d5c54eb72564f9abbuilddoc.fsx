#load @"../../packages/FSharp.Formatting/FSharp.Formatting.fsx"
open FSharp.Literate

let (++) s1 s2 = System.IO.Path.Combine(s1, s2)

let articleSource = __SOURCE_DIRECTORY__ ++ @"Articles\"
let template = __SOURCE_DIRECTORY__ ++ @"templates\template-project.html"
let output = __SOURCE_DIRECTORY__ ++ @"..\..\"

let articles =
    [
        "ResumableMonad.Multistep.Persisted.fs"
        "ResumableMonad.Multistep.fs"
    ]

//let doc = Path.Combine(source, "../docs/document.md")
//Literate.ProcessMarkdown(doc, template)

let doc() =
    // Load the template & specify project information
    let projTemplate = template //source + "template-project.html"
    let projInfo =
      [ "page-description", "Resumable monad with F#"
        "page-author", "William Blum"
        "project-name", "Resumable Monad"
        "github-link", "https://github.com/blumu/ResumableMonad/" ]

    articles
    |> Seq.iter(
        fun a ->
            let source = __SOURCE_DIRECTORY__ ++ a
            let output = output ++ System.IO.Path.GetFileName(System.IO.Path.ChangeExtension(source, ".html"))
            printfn "Processing %s to %s" source output
            Literate.ProcessScriptFile(source, template, output, replacements = projInfo)
        )
    
    /// Process everything under the Article directory
    Literate.ProcessDirectory
      (articleSource, projTemplate, output, replacements = projInfo, processRecursive = false)

    System.IO.File.Copy(output ++ "TheResumableMonad.html", output ++ @"index.html", true)

doc()

