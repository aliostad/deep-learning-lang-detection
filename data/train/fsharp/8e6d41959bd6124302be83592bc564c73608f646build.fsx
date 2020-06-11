// include Fake libs
#r "./packages/FAKE/tools/FakeLib.dll"
#r "./packages/FAKE/tools/Fake.FluentMigrator.dll"
#r "./packages/database/Npgsql/lib/net451/Npgsql.dll"

open Fake
open Fake.FluentMigratorHelper

// Directories
let buildDir  = "./build/"
let deployDir = "./deploy/"

let migrationsAssembly = 
  combinePaths buildDir "FsTweet.Db.Migrations.dll"

// version info
let version = "0.1"  // or retrieve from CI server

// Targets
Target "Clean" (fun _ ->
  CleanDirs [buildDir; deployDir]
)

Target "BuildMigrations" (fun _ ->
  !! "src/FsTweet.Db.Migrations/*.fsproj"
  |> MSBuildDebug buildDir "Build" 
  |> Log "MigrationBuild-Output: "
)

let connString = 
  environVarOrDefault 
    "FSTWEET_DB_CONN_STRING"
    @"Server=127.0.0.1;Port=5432;Database=FsTweet;User Id=postgres;Password=test;"

setEnvironVar "FSTWEET_DB_CONN_STRING" connString
let dbConnection = ConnectionString (connString, DatabaseProvider.PostgreSQL)

Target "RunMigrations" (fun _ -> 
  MigrateToLatest dbConnection [migrationsAssembly] DefaultMigrationOptions
)

Target "Build" (fun _ ->
  !! "src/FsTweet.Web/*.fsproj"
  |> MSBuildDebug buildDir "Build"
  |> Log "AppBuild-Output: "
)

Target "Run" (fun _ -> 
  ExecProcess 
      (fun info -> info.FileName <- "./build/FsTweet.Web.exe")
      (System.TimeSpan.FromDays 1.)
  |> ignore
)

let noFilter = fun _ -> true

let copyToBuildDir srcDir targetDirName =
  let targetDir = combinePaths buildDir targetDirName
  CopyDir targetDir srcDir noFilter

Target "Views" (fun _ ->
  copyToBuildDir "./src/FsTweet.Web/views" "views"
)

Target "Assets" (fun _ ->
  copyToBuildDir "./src/FsTweet.Web/assets" "assets"
)

// Build order
"Clean"
==> "BuildMigrations"
==> "RunMigrations"
==> "Build"
==> "Views"
==> "Assets"
==> "Run"

// start build
RunTargetOrDefault "Build"
