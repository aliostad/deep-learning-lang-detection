namespace Muffin.Pictures.Archiver.IntegrationTests

open NUnit.Framework
open System.IO
open System

open Muffin.Pictures.Archiver.CompositionRoot
open Muffin.Pictures.Archiver.Runner
open Muffin.Pictures.Archiver.Domain

module RunOnActualData =

    let private location name =
        if File.Exists name then
            name
        else
            System.Reflection.Assembly.GetExecutingAssembly().Location
            |> Directory.GetParent
            |> fun dir -> Path.Combine(dir.FullName, name)

    let private exifTool = location "exiftool"

    let assertExists paths =
        let filePath = Path.Combine(paths) |> FileInfo |> fun fi -> fi.FullName
        Assert.IsTrue(File.Exists(filePath), "Verify that file \"{0}\" exists.", filePath)

    let copyDirectory src dest =
        if not <| System.IO.Directory.Exists(src) then
            let msg = System.String.Format("Source directory does not exist or could not be found: {0}", src)
            raise (System.IO.DirectoryNotFoundException(msg))

        if not <| System.IO.Directory.Exists(dest) then
            System.IO.Directory.CreateDirectory(dest) |> ignore

        let srcDir = new System.IO.DirectoryInfo(src)

        for file in srcDir.GetFiles() do
            let temppath = System.IO.Path.Combine(dest, file.Name)
            file.CopyTo(temppath, true) |> ignore

    let runInCopy folderName f =
        let original = location "TestData"
        let copy = location folderName

        if Directory.Exists copy then
            Directory.Delete(copy, true)

        copyDirectory original copy

        f copy
        Directory.Delete(copy, true)

    let fileExif20141202 = "exif20141202.jpg" // has no tag for time taken
    let fileXmp201503 = "xmp20150316.jpg" // has time taken
    let fileNoExif = "no_exif.jpg" // has time taken


    [<Test>]
    let ``Run in strict mode`` () =
        runInCopy "strict" <|
        (fun testFolder ->
            let currentDirectory = sprintf "Current directory: %s" (System.IO.Directory.GetCurrentDirectory())
            System.Console.WriteLine(currentDirectory)
            printfn "%s" currentDirectory
            let arguments = { SourceDir = testFolder; DestinationDir = testFolder; Mode = TimeTakenMode.Strict; MailTo = None; ElasticUrl = None}
            let move = composeMove
            let getMoveRequests = composeGetMoveRequests arguments exifTool (DateTimeOffset.UtcNow.AddYears 1)

            runner move getMoveRequests arguments

            assertExists [| testFolder; "2014-12"; fileExif20141202 |]
            assertExists [| testFolder; fileNoExif |]
            assertExists [| testFolder; "2015-03"; fileXmp201503 |]
        )

    [<Test>]
    let ``Run in fallback mode`` () =
        runInCopy "fallback" <|
        (fun testFolder ->
            let currentDirectory = sprintf "Current directory: %s" (System.IO.Directory.GetCurrentDirectory())
            System.Console.WriteLine(currentDirectory)
            printfn "%s" currentDirectory

            File.SetLastWriteTimeUtc(Path.Combine(testFolder, fileNoExif), DateTime.Parse("2015-01-01"))

            let arguments = { SourceDir = testFolder; DestinationDir = testFolder; Mode = TimeTakenMode.Fallback; MailTo = None; ElasticUrl = None}
            let move = composeMove
            let getMoveRequests = composeGetMoveRequests arguments exifTool (DateTimeOffset.UtcNow.AddYears 1)

            runner move getMoveRequests arguments


            assertExists [| testFolder; "2014-12"; fileExif20141202 |]
            assertExists [| testFolder; "2015-01" ; fileNoExif |]
            assertExists [| testFolder; "2015-03"; fileXmp201503 |]
        )
