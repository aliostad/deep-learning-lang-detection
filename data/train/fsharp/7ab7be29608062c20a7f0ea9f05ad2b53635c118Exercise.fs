module Final.Exercise

(*
//If you want to execute part of this file in the REPL, you must first load the following files:
#load "Blank.fs"
#load "Document.fs"
#load "DocumentComparer.fs"
#load "DocumentHtmlRenderer.fs"

#r "../packages/FSharp.Formatting/lib/net40/FSharp.Markdown.dll"
#load "MarkdownParser.fs"

#r "../packages/NUnit/lib/nunit.framework.dll"
#load "../paket-files/forki/FsUnit/FsUnit.fs"
*)

open Document
open Document.Core
open FsUnit

let doc1 = """
This is a test
---

Hello world, I'm happy to be here today

I have serious doubts we'll get to this point, but if that's the case, you can all be **very** proud.

Now, if you manage to do this exercise, that's awesome.""" |> MarkdownParser.ParseMarkdownSections |> TitledSections |> List.singleton

let doc2 = """
This is a test
---

Hello **students**, I'm **very** happy to be here today...

*and I hope you're happy too!*

I have serious doubts we'll get to this point, but if that's the case, you can all be **very** proud.

Let's try to to that.""" |> MarkdownParser.ParseMarkdownSections |> TitledSections|> List.singleton

let run () =
    let mergedDoc = Comparer.getMergedParts doc1 doc2
    mergedDoc |> Output.writeFile HtmlRenderer.toHtml true
