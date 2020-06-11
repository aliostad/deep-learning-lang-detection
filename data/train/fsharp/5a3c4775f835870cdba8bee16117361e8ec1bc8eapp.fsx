#r "packages/Suave/lib/net40/Suave.dll"
#r "packages/Aether/lib/net35/Aether.dll"
#r "packages/Chiron/lib/net40/Chiron.dll"

#load "code/api.fs"

open Suave
open Suave.Web
open Suave.Http
open Suave.Filters
open Suave.Operators
open Suave.Successful
open Suave.Writers


let app =
  let root = System.IO.Path.Combine(__SOURCE_DIRECTORY__,"web")
  choose [
    path "/api/users"
      >=> OK (Api.usersJson ())
      >=> setMimeType "application/json; charset=utf-8"
    path "/test" >=> OK "ok"
    path "/" >=> Files.browseFile root "index.html"
    Files.browse root ]
