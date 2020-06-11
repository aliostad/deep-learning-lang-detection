namespace DUP // Short for desktop utilities

open System

type Directory =
    /// Copies recusively the contents of the 'sourceDir' to the 'targetDir'.
    static member Copy(sourceDir:string, targetDir:string) =
        let rec directoryCopy srcPath dstPath copySubDirs =
            if not <| System.IO.Directory.Exists(srcPath) then
                let msg = System.String.Format("Source directory does not exist or could not be found: {0}", srcPath)
                raise (System.IO.DirectoryNotFoundException(msg))

            if not <| System.IO.Directory.Exists(dstPath) then
                System.IO.Directory.CreateDirectory(dstPath) |> ignore

            let srcDir = new System.IO.DirectoryInfo(srcPath)

            for file in srcDir.GetFiles() do
                let temppath = System.IO.Path.Combine(dstPath, file.Name)
                file.CopyTo(temppath, true) |> ignore

            if copySubDirs then
                for subdir in srcDir.GetDirectories() do
                    let dstSubDir = System.IO.Path.Combine(dstPath, subdir.Name)
                    directoryCopy subdir.FullName dstSubDir copySubDirs

        directoryCopy sourceDir targetDir true

    /// Deletes recursively the contents of the 'sourcePath' which is presumed to be a directory.
    static member DeleteContents(sourcePath:string) =
        if not <| System.IO.Directory.Exists(sourcePath) then
            let msg = System.String.Format("Source directory does not exist or could not be found: {0}", sourcePath)
            raise (System.IO.DirectoryNotFoundException(msg))

        let srcDir = new System.IO.DirectoryInfo(sourcePath)

        for file in srcDir.GetFiles() do
            System.IO.File.Delete(file.FullName)
        for subdir in srcDir.GetDirectories() do
                System.IO.Directory.Delete(subdir.FullName, true)

type File =
    /// Copies the 'source' file to 'target' file. If the 'target' file already exists deletes it first.
    static member Copy(source:string, target:string) =
        let srcInfo = System.IO.FileInfo(source)

        if not <| srcInfo.Exists then
            let msg = System.String.Format("Source file could not be found: {0}", source)
            raise (System.IO.DirectoryNotFoundException(msg))

        srcInfo.CopyTo(target, true) |> ignore



