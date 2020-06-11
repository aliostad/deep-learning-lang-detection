#r ".AnFake/AnFake.Api.v1.dll"
#r ".AnFake/AnFake.Core.dll"
#r ".AnFake/AnFake.Fsx.dll"
#r ".AnFake/AnFake.Plugins.TeamCity.dll"

open System
open System.Linq
open AnFake.Api
open AnFake.Core
open AnFake.Fsx.Dsl
open AnFake.Plugins.TeamCity

TeamCity.PlugIn()

let out = ~~".out"
let productOut = out / "product"
let product = 
    !!"AnFake/*.csproj"
    + "AnFake.Api.Pipeline/*.csproj"
    + "AnFake.Plugins.*/*.csproj" - "AnFake.Plugins.*.Test/*.csproj"

"Clean" => (fun _ ->    
    let obj = !!!"*/obj"
    let bin = !!!"*/bin"

    Folders.Clean obj
    Folders.Clean bin
    Folders.Clean out
)

"Compile" => (fun _ ->
    MsBuild.BuildRelease(product, productOut)    
)

"Build" <== ["Compile"]
