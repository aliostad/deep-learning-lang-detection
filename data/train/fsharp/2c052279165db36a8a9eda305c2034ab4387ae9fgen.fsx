#!/usr/bin/env fsharpi

(** Load up/reference some things we'll be needing. *)
#I @"packages/FAKE/tools/"
#r @"FakeLib"
open Fake
open Fake.FscHelper

(** Set up our source files for our provider *)
let sourceFiles = [
        @"paket-files/fsprojects/FSharp.TypeProviders.StarterPack/src/ProvidedTypes.fsi"
        @"paket-files/fsprojects/FSharp.TypeProviders.StarterPack/src/ProvidedTypes.fs"
        "DocoptProvider.fsx"
    ]

Target "CopyDocoptNetDll" (fun _ ->
  trace "Copying DocoptNet lib package files"
  !! "packages/docopt.net/lib/net40/*"
  |> CopyFiles __SOURCE_DIRECTORY__
)

(** Build the provider! *)
Target "BuildProvider" (fun _ ->
    trace "Building the provider"
    sourceFiles
    |> Fsc (fun p -> { p with Output = "DocoptProvider.dll"
                              Debug = true
                              FscTarget = Library
                              References = [ "DocoptNet.dll"] })
)

(** Build the test app **)
Target "BuildApp" (fun _ ->
    trace "Building the test app"
    [ "App.fsx" ]
    |> Fsc (fun p -> { p with Output = "App.exe"; FscTarget = Exe; Debug = true
                              References = [ "DocoptProvider.dll"; "DocoptNet.dll"]
                              OtherParams = [ "--standalone" ] })
)

"CopyDocoptNetDll"
 ==> "BuildProvider"
 ==> "BuildApp"

Run "BuildApp"
