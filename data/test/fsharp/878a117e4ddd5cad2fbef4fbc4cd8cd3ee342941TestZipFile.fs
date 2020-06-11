module ZipixTest.TestZipFile

open System.IO
open FsCheck
open Zipix
open ZipixTest.Helpers


let processZip zipdata f =
    let zipIn = ZipFile.ofStream <| new MemoryStream(zipdata, false)
    use ms = new MemoryStream()
    let zipOut = ZipFile.ofStream ms
    f zipIn zipOut
    ms.Close()
    ms.ToArray()


let processFileTree ft f zipComment =
    processZip (mkZip ft zipComment) f


[<ZipixProperty>]
let test_copyRecords_identity (ft: FileTree) (MaybeString zipComment) =
    "copyRecords makes an exact copy of a valid zipfile" @|
        let zdIn = mkZip ft zipComment
        let zdOut = processZip zdIn ZipFile.copyRecords
        zdIn = zdOut
