open System.IO

open System
open System.Text
open System.Text.RegularExpressions
open System.Globalization
open System.Diagnostics

// white space, em-dash, en-dash, underscore
let private wordDelimiters = new Regex(@"[\s—–_]", RegexOptions.Compiled)
// characters that are not valid
let private invalidChars = new Regex(@"[^a-z0-9\-]", RegexOptions.Compiled)
// multiple hyphens
let private multipleHyphens = new Regex(@"-{2,}", RegexOptions.Compiled)

type BuildConfiguration = 
    {
        BooksFilePath : string;
        FtpUser : string;
        FtpPassword : string;
        IsTraceDebug : bool
    }

type TaskResult = 
    | Success of BuildConfiguration
    | Failure of BuildConfiguration * string

let private removeDiacritics (stIn : string) = 
    let stFormD = stIn.Normalize(NormalizationForm.FormD)
    let sb = new StringBuilder()
    stFormD |> Seq.iter (fun c -> 
                    let uc = CharUnicodeInfo.GetUnicodeCategory(c)
                    if uc <> UnicodeCategory.NonSpacingMark then sb.Append(c) |> ignore)
    sb.ToString().Normalize(NormalizationForm.FormC)

let Slugify (value : string) = 
    value.ToLowerInvariant() // convert to lower case
    |> removeDiacritics // remove diacritics (accents)
    |> fun s -> wordDelimiters.Replace(s, "-") // ensure all word delimiters are hyphens
    |> fun s -> invalidChars.Replace(s, "") // strip out invalid characters
    |> fun s -> multipleHyphens.Replace(s, "-") // replace multiple hyphens (-) with a single hyphen
    |> fun s -> s.Trim('-') // trim hyphens (-) from ends

let DownloadImage(imageUrl : string) = 
    (new System.Net.WebClient()).DownloadData(imageUrl)

let CreateFolderIfNotExists folderPath =
    if not (Directory.Exists folderPath) then
        (Directory.CreateDirectory folderPath) |> ignore

let Warning message = 
    Printf.kprintf 
        (fun s -> 
            let old = System.Console.ForegroundColor 
            try 
                System.Console.ForegroundColor <- ConsoleColor.Yellow;
                System.Console.Write s
            finally
                System.Console.ForegroundColor <- old) 
        "%s" message
    printfn ""

let private execProcess processName arguments =
    printfn "execute: %s" processName

    use proc = new Process()
    proc.StartInfo.UseShellExecute <- false
    proc.StartInfo.FileName <- processName
    proc.StartInfo.Arguments <- arguments
    proc.StartInfo.RedirectStandardOutput <- true
    proc.StartInfo.RedirectStandardError <- true
    proc.ErrorDataReceived.Add(fun d -> 
        if not (isNull d.Data) then eprintfn "%s" d.Data)
    proc.OutputDataReceived.Add(fun d -> 
        if not (isNull d.Data) then printfn "%s" d.Data)
    proc.Start() |> ignore
    proc.BeginErrorReadLine()
    proc.BeginOutputReadLine()
    proc.WaitForExit()
    proc.ExitCode

let ExecProcessWithFail processName arguments =
    if execProcess processName arguments > 0 then
        failwith ("'" + processName + " ' failed")

let ExecProcessWithTaskResult processName arguments configuration failMessage =
    if execProcess processName arguments > 0 then
        Failure (configuration, failMessage)
    else
        Success configuration

type BuildTask =
  { Name : string;
     Prerequisite : unit -> unit;
     Action : BuildConfiguration -> TaskResult
  }

let BuildTask name prerequisite action =
    { Name = name;
       Prerequisite = prerequisite;
       Action = action }

let private executeTaskInternal buildTask configuration =
    printfn "Execute task %s" buildTask.Name
    buildTask.Prerequisite()
    buildTask.Action configuration

let startBuild buildTask configuration =
    executeTaskInternal buildTask configuration

let executeTask buildTask taskResult =
    match taskResult with
    | Success s -> executeTaskInternal buildTask s
    | Failure (conf, mess) -> Failure (conf, mess)
