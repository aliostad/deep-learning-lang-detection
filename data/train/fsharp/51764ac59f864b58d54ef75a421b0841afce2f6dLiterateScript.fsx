#I @"C:\Users\Tomas\Scripts\NuGet\packages\FSharp.Formatting.CommandTool.2.4.36\tools"
#r "FSharp.CodeFormat.dll"
#r "FSharp.Literate.dll"
open FSharp.Literate
open System.IO

let a = __SOURCE_DIRECTORY__ + @"\EmbeddingOutputDemo.fsx"

// Create evaluator and parse script
let fsi = FsiEvaluator()
//let doc = Literate.ParseScriptString(content, fsiEvaluator = fsi)
//Literate.WriteHtml(doc)

let templateFile = @"C:\Users\Tomas\Scripts\NuGet\packages\FSharp.Formatting.CommandTool.2.4.36\literate\templates\template-file.html"

Literate.ProcessDirectory(".", templateFile = templateFile, fsiEvaluator = fsi)
//Literate.ProcessScriptFile(a, fsiEvaluator = fsi, templateFile = templateFile)

