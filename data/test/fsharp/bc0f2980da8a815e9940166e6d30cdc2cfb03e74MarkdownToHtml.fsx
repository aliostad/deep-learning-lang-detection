
// Install-Package FSharp.Formatting -IncludePrerelease
#if INTERACTIVE
#r "../packages/RazorEngine.3.3.0/lib/net40/RazorEngine.dll"
#r "../packages/Microsoft.AspNet.Razor.2.0.30506.0/lib/net40/System.Web.Razor.dll"
#I "../packages/FSharp.Compiler.Service.0.0.36/lib/net40"
#I "../packages/FSharp.Formatting.2.4.2/lib/net40"
#r "FSharp.Literate.dll"
#r "FSharp.CodeFormat.dll"
#r "FSharp.MetadataFormat.dll"
#else
module ConvertToHtml
#endif
open System.IO
open FSharp.Literate
open FSharp.MetadataFormat

let templatePath = @"..\packages\FSharp.Formatting.2.4.2\"
let templateFile = @"literate\templates\template-file2.html"
let source = __SOURCE_DIRECTORY__
let path = source + @"\"
let template = Path.Combine(source, templatePath+templateFile)

let files = Directory.EnumerateFiles(path, "*.md", SearchOption.AllDirectories)

let copyStyles outputPath =
    let contentOutput = outputPath + @"\..\content\"
    Directory.CreateDirectory(contentOutput) |> ignore
    let miscPath = source + @"\" + templatePath + @"styles\"
    let css, js = "style.css", "tips.js" 
    File.Copy(miscPath+css, contentOutput + css, true)
    File.Copy(miscPath+js, contentOutput + js, true)

let generateDocs =
    files |> Seq.iter (fun f -> 
            copyStyles (f.Substring(0, f.LastIndexOf(@"\")))
            let targetFile = f.Substring(0, f.Length-2) + "html"
            Literate.ProcessMarkdown(f, template, targetFile)
        )


