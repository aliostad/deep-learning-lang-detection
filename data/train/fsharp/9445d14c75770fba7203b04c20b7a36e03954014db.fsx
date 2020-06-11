
#r @"packages/FAKE/tools/FakeLib.dll"
#r @"packages/FAKE/tools/Fake.SQL.dll"
open Fake
open Fake.Git
open Fake.AssemblyInfoFile
open Fake.ReleaseNotesHelper
open Fake.SQL
open System

let db = "tigers"
let user = "slot"
let password = "1"
let conn = sprintf @"Data Source=.\SQLEXPRESS;Initial Catalog=%s;Integrated Security=True;User ID=%s;Password=%s;" db user password


let migrate = @".\packages\FluentMigrator.Tools\tools\x86\40\Migrate.exe"
let dbtype = "SqlServer2014"
let dll = @".\src\tigers.migration\bin\Release\tigers.migration.dll"
let migration = sprintf "\"%s\" -db \"%s\" -conn \"%s\" -a \"%s\"" migrate dbtype conn dll


Target "builddll" (fun _ ->
    !! @"src\tigers.migration\tigers.migration.csproj"
    |> MSBuildRelease "" "Rebuild"
    |> ignore
)

Target "createdb" (fun _ ->
    SqlServer.DropAndCreateDatabase(conn)
)

let afterExecProcess code = if code <> 0 then failwithf "exec process was failed"

Target "migration" (fun _ -> ExecProcess (fun info -> 
                                            info.FileName <- migration) 
                                         (TimeSpan.FromMinutes 5.0) |> afterExecProcess)

Target "seeddata" (fun _ -> ExecProcess (fun info -> 
                                            info.FileName <- migration + " -profile \"dev\"")
                                         (TimeSpan.FromMinutes 5.0) |> afterExecProcess)

Target "dev" DoNothing

"builddll"
  ==> "migration"
  ==> "seeddata"

"createdb"
  ==> "seeddata"
  ==> "dev"


RunTargetOrDefault "migration"