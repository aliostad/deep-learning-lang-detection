module Build

#r "packages/FAKE/tools/FakeLib.dll"
#load "packages/Mag.Build/tools/mag.fsx"

open Fake
open MAG

MAG.Build(fun b ->
  { b with product = "OwnersManual"
           description = "MAG Auto Documentation"
           dbs =
             [| |]
           nugets =
             [| { name = "OwnersManual"
                  version = "1.0"
                  nuspec = "Package.nuspec"
                  dependencies = [
                                  ("RestSharp", "105.2.3");
                                  ("CommonMark.Net", "0.14.0");
                      ]
                  files = [ (@"**/*.*"), Some "lib", None ]
                  copyFiles =
                    (fun target -> CopyFile target ("./src/OwnersManual/bin/" @@ b.mode @@ "/OwnersManual.dll")) } |]
           dotCoverFilter = [| "-:*.UnitTests;" |] })
