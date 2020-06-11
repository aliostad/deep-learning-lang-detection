// --------------------------------------------------------------------------------------
// FAKE build script
// --------------------------------------------------------------------------------------
System.Environment.CurrentDirectory <- __SOURCE_DIRECTORY__

#load "paket-files/halcwb/GenBuild/scripts/targets.fsx"
#load "scripts/buildClient.fsx"

open System

open Fake
open Fake.NpmHelper
#if MONO
#else
open SourceLink
#endif

Target "All" DoNothing


"Clean"
  ==> "AssemblyInfo"
  ==> "Build"
  ==> "CopyBinaries"
  ==> "NUnit3"
  ==> "BuildClient"
  ==> "ClientTests"
  ==> "CopyClient"
  ==> "GenerateReferenceDocs"
  ==> "GenerateDocs"
  ==> "All"
  =?> ("ReleaseDocs",isLocalBuild)

"All"
#if MONO
#else
  =?> ("SourceLink", Pdbstr.tryFind().IsSome )
#endif
  ==> "BuildPackage"

"CleanDocs"
  ==> "GenerateHelp"
  ==> "GenerateReferenceDocs"
  ==> "GenerateDocs"

"CleanDocs"
  ==> "GenerateHelpDebug"

"GenerateHelp"
  ==> "KeepRunning"

"ReleaseDocs"
  ==> "Release"

"BuildPackage"
  ==> "Release"


RunTargetOrDefault "All"
