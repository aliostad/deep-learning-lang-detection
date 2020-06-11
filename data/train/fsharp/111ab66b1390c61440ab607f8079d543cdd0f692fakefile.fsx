#r @"tools/FAKE/tools/FakeLib.dll"
open Fake

let output       = "./~build-output/"
let api          = output + "webapi/"
let vagrantShare = "./www/"

Target "help" (fun _ ->
    traceImportant "______ ___   _   __ _____ "
    traceImportant "|  ___/ _ \ | | / /|  ___|"
    traceImportant "| |_ / /_\ \| |/ / | |__  "
    traceImportant "|  _||  _  ||    \ |  __| "
    traceImportant "| |  | | | || |\  \| |___ "
    traceImportant "\_|  \_| |_/\_| \_/\____/ "
    trace "" 
    traceImportant "Usage: 'fake [<command>]'"
    trace ""
    traceImportant "Commands:   'help'      - shows this screen"
    traceImportant "            'build'     - runs a build"
    traceImportant "            'test'      - runs a build, and then tests"
    trace ""
)

Target "Clean" (fun _ ->
    traceImportant "Clean and ensure build output dirs..."
    CleanDirs [api; vagrantShare;]
)

Target "CompileApi" (fun _ ->
    traceImportant "Compiling Api project..."
    let projects = !! @"./src/webapi/webapi.csproj"
    MSBuild api "Build" ["PlatformTarget","x86"] projects |> Log "Compile Api Log: "
)

Target "build" (fun _ ->
    traceImportant "Developer build..."    
    let source = sprintf "%s_PublishedWebsites/WebApi" api
    let destination = vagrantShare
    XCopy source destination
)

Target "test" (fun _ ->
    traceImportant "Test suite run..."
)

"help"
    ==> "Clean"
    ==> "CompileApi"
    ==> "build"
    ==> "test"

RunParameterTargetOrDefault "target" "help"