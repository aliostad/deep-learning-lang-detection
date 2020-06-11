module DevRT.NUnit

open System
open Common
open DataTypes
open FileUtil
open IOWrapper
open ProcessWrapper
open StringWrapper

let isSummary data = contains "Duration:" data || contains "Test Count:" data
let isTestFailerInfo str = contains ") Failed :" str || contains ") Invalid :" str
let isFailureLineNumber = contains ":wiersz"
let isNoise (str:string) =
    str |> startsWith " "
    || contains "Run Settings" str
    || str |> startsWith "NUnit Console"
    || str |> startsWith "Copyright"
    || str = Environment.NewLine
    || str |> isNullOrWhiteSpace
    || str |> startsWith "Test"
    || str |> startsWith "Results"
    || str |> startsWith "Runtime"
    || str |> startsWith "Errors and Failures"

let getUpdatedStatus currentStatus = function
    | d when isSummary d -> Summary
    | d when isTestFailerInfo d -> Failure
    | d when isFailureLineNumber d -> FailureLineInfo
    | _ when currentStatus = Failure -> currentStatus
    | d when isNoise d -> Noise
    | _ -> Failure

let parseFailureLineNumberInfo text =
    text |> splitByString " w" |> Array.last

let writeFailureLineNumberInfo write text =
    text |> parseFailureLineNumberInfo |> write

let handleOutput handleSummary handleFailure handleFailureLineInfo = function
    | Summary -> handleSummary
    | Invalid | Failure -> handleFailure
    | FailureLineInfo -> handleFailureLineInfo
    | _ -> fun _ -> ()

let getTestDirectoryName outputDir =
    let parts = split '/' outputDir
    parts.[2]

let copyBuildOutput log source target =
    let copyFiles source dest =
        doCopy (dest |> createPath) (source |> getFiles) copyFile
    let copySubdirectories copyAllFiles source dest =
        doCopy (dest |> createPath) (source |> getDirectories) copyAllFiles
    let copyAllFiles' = copyAllFiles createDirectory copyFiles copySubdirectories
    (source, target) |> log
    copyAllFiles' source target |> ignore

let handleRunning getUpdatedStatus handleOutput data =
    let update, getStatus = createStatus Noise
    data |> getUpdatedStatus (getStatus()) |> update
    data |> handleOutput (getStatus())

let getArguments outputDir testProjectName =
    combine outputDir (sprintf "%s.dll" testProjectName)

let runTestProject run getArguments startInfo =
    getArguments >> startInfo >> run

let prepareAndRunTests
    getOutputDirectory
    getProcessStartInfo
    cleanDirectory
    copyBuildOutput
    run = function
    | RunTestsOn (dllsSource, dlls) ->
        let outputDirectory = dllsSource |> getOutputDirectory
        let startInfo dllFile () =
            getProcessStartInfo dllFile outputDirectory
        stopProcess 500 "nunit-agent"
        cleanDirectory()
        copyBuildOutput dllsSource outputDirectory
        dlls
        |> Seq.iter
            (run (getArguments outputDirectory) startInfo)
    | _ -> ()

let run prepareAndRunTests = function
    | BuildSucceeded -> prepareAndRunTests() | BuildFailed | _   -> ()
