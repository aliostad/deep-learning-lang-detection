#r @"src/packages/FAKE.Core.3.17.7/tools/FakeLib.dll"

open Fake

Target "Clean" (fun _ ->
    CleanDir @"src/bin"
)

Target "RestorePackages" (fun _ ->
    !! @"src/*.sln"
    |> Seq.iter (fun s ->
        RestoreMSSolutionPackages (fun p -> 
            {p with OutputPath = @"src/packages"}
        ) s    
    )
)

Target "Build" (fun _ ->
    !! @"src/**/*.fsproj"
    |> MSBuild @"src/bin" "Build" []
    |> Log "Build log:"
)

Target "Test" (fun _ ->
    !! @"src/bin/*.dll"
    |> NUnit (fun p -> { p with DisableShadowCopy = true })
)

"Clean" ==> "RestorePackages" ==> "Build" ==> "Test"

RunTargetOrDefault "Test"
