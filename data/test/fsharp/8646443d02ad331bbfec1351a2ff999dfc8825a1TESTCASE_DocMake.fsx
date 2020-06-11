// Run in PowerShell not fsi:
// PS> cd <path-to-src>
// PS> ..\packages\FAKE.5.0.0-beta005\tools\FAKE.exe .\TESTCASE_DocMake.fsx Dummy

// With params:
// PS> ..\packages\FAKE.5.0.0-beta005\tools\FAKE.exe .\TESTCASE_DocMake.fsx Dummy --envar sitename="HELLO/WORLD"

// Office deps
#I @"C:\WINDOWS\assembly\GAC_MSIL\Microsoft.Office.Interop.Word\15.0.0.0__71e9bce111e9429c"
#r "Microsoft.Office.Interop.Word"
#I @"C:\WINDOWS\assembly\GAC_MSIL\Microsoft.Office.Interop.Excel\15.0.0.0__71e9bce111e9429c"
#r "Microsoft.Office.Interop.Excel"
#I @"C:\WINDOWS\assembly\GAC_MSIL\Microsoft.Office.Interop.PowerPoint\15.0.0.0__71e9bce111e9429c"
#r "Microsoft.Office.Interop.PowerPoint"
#I @"C:\Windows\assembly\GAC_MSIL\office\15.0.0.0__71e9bce111e9429c"
#r "office"

// FAKE is local to the project file
#I @"..\packages\FAKE.5.0.0-beta005\tools"
#r @"..\packages\FAKE.5.0.0-beta005\tools\FakeLib.dll"

#load @"DocMake\Utils\Common.fs"
#load @"DocMake\Utils\Office.fs"
#load @"DocMake\Tasks\PdfConcat.fs"
#load @"DocMake\Tasks\DocPhotos.fs"
#load @"DocMake\Tasks\DocFindReplace.fs"
#load @"DocMake\Tasks\DocToPdf.fs"
#load @"DocMake\Tasks\PptToPdf.fs"
#load @"DocMake\Tasks\UniformRename.fs"
#load @"DocMake\Tasks\XlsToPdf.fs"

open System.IO

open Fake
open Fake.Core
open Fake.Core.Environment
open Fake.Core.Globbing.Operators
open Fake.Core.TargetOperators
// open Fake.Core.Trace
// open Fake opens Fake.EnvironmentHelper     // for (@@) etc.

open DocMake.Utils.Common
open DocMake.Tasks.DocFindReplace
open DocMake.Tasks.DocPhotos
open DocMake.Tasks.DocToPdf
open DocMake.Tasks.PdfConcat
open DocMake.Tasks.PptToPdf
open DocMake.Tasks.UniformRename
open DocMake.Tasks.XlsToPdf



let _filestoreRoot  = @"G:\work\DocMake_DATA"
let _outputRoot     = @"G:\work\DocMake_OUTPUT"
let _templateRoot   = @"G:\work\DocMake_OUTPUT\__Templates"

let siteName = environVarOrDefault "sitename" @"CATTERICK VILLAGE/STW"
let saiNumber = environVarOrDefault "uid" @"SAI00001681"

let cleanName       = safeName siteName
let siteData        = _filestoreRoot @@ cleanName
let siteOutput      = _outputRoot @@ cleanName



let makeSiteOutputName (fmt:Printf.StringFormat<string->string>) : string = 
    siteOutput @@ sprintf fmt cleanName

let renamePhotos (jpegPath:string) (fmt:Printf.StringFormat<string->int->string>) : unit =
    let mkName = fun i -> sprintf fmt cleanName i
    UniformRename (fun p -> 
        { p with 
            InputFolder = jpegPath
            MatchPattern = @"\.je?pg$"
            MatchIgnoreCase = true
            MakeName = mkName 
        })

Target.Create "Clean" (fun _ -> 
    if Directory.Exists(siteOutput) then 
        Trace.tracefn " --- Clean folder: '%s' ---" siteOutput
        Fake.IO.Directory.delete siteOutput
    else ()
)

Target.Create "OutputDirectory" (fun _ -> 
    Trace.tracefn " --- Output folder: '%s' ---" siteOutput
    maybeCreateDirectory(siteOutput)
)

Target.Create "CoverSheet" (fun _ ->
    let template = _templateRoot @@ "TEMPLATE Samps Cover Sheet.docx"
    let docname = makeSiteOutputName "%s Cover Sheet.docx"
    Trace.tracefn " --- Cover sheet for: %s --- " siteName
    
    DocFindReplace (fun p -> 
        { p with 
            InputFile = template
            OutputFile = docname
            Searches  = [ ("#SITENAME", siteName);
                          ("#SAINUM", saiNumber) ] 
        }) 
    
    let pdfname = makeSiteOutputName "%s Cover Sheet.pdf"
    DocToPdf (fun p -> 
        { p with 
            InputFile = docname
            OutputFile = Some <| pdfname 
        })
)


Target.Create "SurveySheet" (fun _ ->
    let infile = Fake.IO.Directory.findFirstMatchingFile "* Sampler survey.xlsx" (siteData @@ "1_Survey")
    let outfile = makeSiteOutputName "%s Survey Sheet.pdf" 
    XlsToPdf (fun p -> 
        { p with 
            InputFile = infile
            OutputFile = Some <| outfile
        })
)


Target.Create "SurveyPhotos" (fun _ ->
    let inletCopyPath = siteOutput @@ "SurveyPhotos\Inlet"
    maybeCreateDirectory inletCopyPath 
    !! (siteData @@ "1_Survey\Inlet\*.jpg") |> Fake.IO.Shell.Copy inletCopyPath
    renamePhotos inletCopyPath "%s Inlet %03i.jpg"

    let outletCopyPath = siteOutput @@ "SurveyPhotos\Outlet"
    maybeCreateDirectory outletCopyPath
    !! (siteData @@ "1_Survey\Outlet\*.jpg") |> Fake.IO.Shell.Copy outletCopyPath 
    renamePhotos outletCopyPath "%s Outlet %03i.jpg"

    let docname = makeSiteOutputName "%s Survey Photos.docx" 
    DocPhotos (fun p -> 
        { p with 
            InputPaths = [ inletCopyPath; outletCopyPath]            
            OutputFile = docname
            ShowFileName = true 
        })

    let pdfname = makeSiteOutputName "%s Survey Photos.pdf"
    DocToPdf (fun p -> 
        { p with 
            InputFile = docname
            OutputFile = Some <| pdfname 
        })
)

// findFirstMatchingFile is an alternative to unique
Target.Create "SurveyPPT" (fun _ -> 
    let infile = Fake.IO.Directory.findFirstMatchingFile "*.pptx" (siteData @@ "1_Survey") 
    let outfile = makeSiteOutputName "%s Survey PPT.pdf" 
    Trace.tracef "Input: %s" infile
    PptToPdf (fun p -> 
        { p with 
            InputFile = infile
            OutputFile = Some <| outfile
        })
)

Target.Create "CircuitDiag" (fun _ -> 
    let infile = Fake.IO.Directory.findFirstMatchingFile "* Circuit Diagram.pdf" (siteData @@ "2_Site_works") 
    let dest = makeSiteOutputName "%s Circuit Diagram.pdf" 
    Trace.tracef "Input: %s" infile
    Fake.IO.Shell.CopyFile dest infile
)


Target.Create "ElectricalWork" (fun _ ->
    // let infile = !! (relativeToSite @"2_Site_works\* Wookbook.xls*") |> unique
    let infile = Fake.IO.Directory.findFirstMatchingFile "* Wookbook.xls*" (siteData @@ "2_Site_works") 
    let outfile = makeSiteOutputName "%s Electrical Worksheet.pdf" 
    XlsToPdf (fun p -> 
        { p with 
            InputFile = infile
            OutputFile = Some <| outfile
        })
)

let finalGlobs : string list = 
    [ "* Cover Sheet.pdf" ;
      "* Survey Sheet.pdf" ;
      "* Survey Photos.pdf" ;
      "* Survey PPT.pdf" ;
      "* Circuit Diagram.pdf" ;
      "* Electrical Worksheet.pdf" ]

//      // For Testing...
//let finalGlobs : string list = 
//    [ "* Install Sheet.pdf" ]

Target.Create "Final" (fun _ ->
    let get1 = fun glob -> Fake.IO.Directory.tryFindFirstMatchingFile glob siteOutput
    let files = List.map get1 finalGlobs |> List.choose id
    PdfConcat (fun p -> 
        { p with 
            OutputFile = makeSiteOutputName "%s UWW Samplers OM Manual.pdf" })
                files
)

Target.Create "Blank" (fun _ ->
    Trace.tracefn "Blank, sitename is %s" siteName
)


// *** Dependencies ***
"Clean"
    ==> "OutputDirectory"

"OutputDirectory"
    ==> "CoverSheet"
    ==> "SurveySheet"
    ==> "SurveyPhotos"
    ==> "SurveyPPT"
    ==> "CircuitDiag"
    ==> "ElectricalWork"
    ==> "Final"

Target.RunOrDefault "Blank"
