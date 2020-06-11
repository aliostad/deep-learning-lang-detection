namespace EmpGraph.Core
open System.IO

open ICSharpCode.SharpZipLib.Zip
open ICSharpCode.SharpZipLib.Zip.Compression.Streams
open System.IO

module internal zipHelper =

    let private isXls (file:ZipEntry) =
        file.IsFile && fileHelper.isXlsfile file.Name 

    let copyToMemoryStream (zipFile:ZipFile) (zipEntry:ZipEntry) =
        let memStream = new MemoryStream()
        use stream = zipFile.GetInputStream(zipEntry)
        stream.CopyTo(memStream)
        memStream.Position <- 0L
        memStream

    let getFileInput (zipFile:ZipFile) (zipEntry:ZipEntry) =
        let fileStream = copyToMemoryStream zipFile zipEntry
        {name = zipEntry.Name ; file = fileStream}

    let getXlsFiles stream =
        use zipFile = new ZipFile(stream = stream)
        let (files: seq<ZipEntry>) = Seq.cast zipFile
        let streams =
            files
            |> Seq.filter isXls
            |> Seq.map (fun a -> getFileInput zipFile a)
            |> Seq.toList
        streams