module ``File tasks module``

open NUnit.Framework

open Xake
open Xake.Tasks

type private File = System.IO.File

let TestOptions = {ExecOptions.Default with Threads = 1; Targets = ["main"]; ConLogLevel = Chatty; FileLogLevel = Silent}

[<Test>]
let ``allows delete file``() =
    "." </> ".xake" |> File.Delete

    let execCount = ref 0
    do xake TestOptions {
        rules [
            "main" => action {
                execCount := !execCount + 1
                do! need ["samplefile"]
                File.Exists "samplefile" |> Assert.True
                do! rm {file "samplefile"}
            }

            "samplefile" ..> writeText "hello world"
        ]
    }

    Assert.AreEqual(1, !execCount)
    File.Exists "samplefile" |> Assert.False

[<Test>]
let ``allows delete file by mask``() =
    "." </> ".xake" |> File.Delete
    let execCount = ref 0
    
    do xake TestOptions {
        rules [
            "main" => action {
                do! need ["$$1"; "$$2"]
                File.Exists "$$2" |> Assert.True
                do! rm {file "$$*"}
                execCount := !execCount + 1
            }

            "$$*" ..> writeText "hello world"
        ]
    }

    Assert.AreEqual(1, !execCount)
    ["$$1"; "$$2"] |> List.iter (File.Exists >> Assert.False)

[<Test>]
let ``allows to delete by several masks``() =
    "." </> ".xake" |> File.Delete
    do xake TestOptions {
        rules [
            "main" => action {
                do! need ["$aa"; "$bb"]
                File.Exists ("$bb") |> Assert.True
                do! rm {file "$aa"}
                do! rm {file "$b*"}
            }

            "$*" ..> writeText "hello world"
        ]
    }

    ["$aa"; "$bb"] |> List.iter (File.Exists >> Assert.False)

[<Test>]
let ``supports simple file copy``() =
    "." </> ".xake" |> File.Delete
    do xake TestOptions {
        rules [
            "main" => action {
                do! trace Error "Running inside 'main' rule"
                do! need ["aaa"; "clean"]
                do! copyFile "aaa" "aaa-copy"
            }

            "clean" => rm {file "aaa-copy"}
            "aaa" ..> writeText "hello world"
        ]
    }

    File.Exists "aaa-copy" |> Assert.True
