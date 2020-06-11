#r "packages/build/FAKE/tools/FAKELib.dll"
open Fake
open Fake.Paket

let buildSrc () =
    build
        (fun d -> { d with Properties = ["Configuration","Release";"Optimize","True"]; Targets = ["Clean";"Build"] }) 
        ("src" @@ "EasyNetQ.ProcessManager.State.SqlServer" @@ "EasyNetQ.ProcessManager.State.SqlServer.fsproj")
    build
        (fun d -> { d with Properties = ["Configuration","Release";"Optimize","True"]; Targets = ["Clean";"Build"] }) 
        ("src" @@ "EasyNetQ.ProcessManager.Transport.EasyNetQLegacy" @@ "EasyNetQ.ProcessManager.Transport.EasyNetQLegacy.fsproj")

let buildTest () =
    build
        (fun d -> { d with Properties = ["Configuration","Release";"Optimize","True"]; Targets = ["Clean";"Build"] }) 
        ("tests" @@ "EasyNetQ.ProcessManager.Tests" @@ "EasyNetQ.ProcessManager.Tests.fsproj")

let package () =
    CleanDir "output"
    Pack  (fun p -> { p with OutputPath = "output" })

let push () =
    let apiKey = environVarOrFail "apikey"
    Push (fun p -> { p with ApiKey = apiKey; WorkingDir = "output" })

let test () =
    let setParams (n : NUnitParams) =
        n
    !! "**/bin/Release/*.Tests.dll"
    |> NUnit setParams

Target "buildSrc" buildSrc
Target "buildTest" buildTest
Target "package" package
Target "push" push
Target "test" test
Target "default" id

"buildSrc"
    ==> "buildTest"
    ==> "test"
    ==> "package"
    =?> ("push", match environVarOrNone "apikey" with Some a -> true | _ -> false)
    ==> "default"

RunParameterTargetOrDefault "target" "default"