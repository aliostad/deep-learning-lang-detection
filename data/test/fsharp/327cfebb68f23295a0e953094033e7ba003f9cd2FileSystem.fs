namespace Nessos.InstallUtils

    open System
    open System.IO

    open Nessos.Reversible

    type File private () =
        
        static let fileNotFound (path : string) =
            raise <| new FileNotFoundException(sprintf "Could not find file '%s'." path)

        static member RevMove(src : string, dst : string, ?overwrite) =
            let overwrite = defaultArg overwrite false
            let move () =
                if not <| File.Exists src then
                    fileNotFound src

                let previous =
                    if File.Exists dst then
                        if overwrite then
                            let tmp = Path.GetTempPathName()
                            File.Move(dst, tmp)
                            Some tmp
                        else failwithf "File '%s' already exists." dst
                    else None

                do File.Move(src, dst)

                (), previous

            let recover previous =
                File.Move(dst, src)
                previous |> Option.iter (fun tmp -> File.Move(tmp, dst))

            let fini previous = previous |> Option.iter (fun tmp -> try File.Delete tmp with _ -> ())

            Reversible.FromComponents (move, recover, fini)

        static member RevCopy(src : string, dst : string, ?overwrite) =
            let overwrite = defaultArg overwrite false

            let copy () =
                if not <| File.Exists src then
                    fileNotFound src

                let previous =
                    if File.Exists dst then
                        if overwrite then
                            let tmp = Path.GetTempPathName ()
                            File.Move(dst, tmp)
                            Some tmp 
                        else
                            failwithf "File '%s' already exists." dst
                    else None

                File.Copy(src, dst)

                (), previous

            let recover previous =
                File.Delete dst
                previous |> Option.iter(fun tmp -> File.Move(tmp, dst))

            let fini previous = previous |> Option.iter (fun tmp -> try File.Delete tmp with _ -> ())

            Reversible.FromComponents(copy, recover, fini)

        
        static member RevDelete(file : string, ?failIfMissing) =
            let failIfMissing = defaultArg failIfMissing true

            let delete () =
                if not <| File.Exists file then
                    if failIfMissing then
                        fileNotFound file
                    else (), None
                else
                    let tmp = Path.GetTempPathName()
                    File.Move(file, tmp)
                    (), Some tmp

            let recover backup = backup |> Option.iter (fun tmp -> File.Move(tmp, file))
            let fini backup = backup |> Option.iter (fun tmp -> try File.Delete tmp with _ -> ())

            Reversible.FromComponents(delete, recover, fini)


    type Directory private () =

        static let directoryNotFound path =
            raise <| DirectoryNotFoundException(sprintf "Could not find a part of the path '%s'" path)

        static let rec copyRec (src : string) (dst : string) =
            if not <| Directory.Exists dst then
                Directory.CreateDirectory dst |> ignore

            let directory = new DirectoryInfo(src)

            for file in directory.GetFiles() do
                let inline (!) prefix = Path.Combine(prefix, file.Name)
                File.Copy(!src, !dst)

            for dir in directory.GetDirectories() do
                let inline (!) prefix = Path.Combine(prefix, dir.Name)
                copyRec !src !dst

        static let nested (path1 : string) (path2 : string) =
            // case insensitive file system... grrrr
            // this prolly yields false positives under mono/linux
            let p1 = (Path.GetFullPath path1).ToLower()
            let p2 = (Path.GetFullPath path2).ToLower()

            p2.StartsWith p1 || p1.StartsWith p2

        static member CopyRecursive(src : string, dst : string, ?overwrite) =
            let overwrite = defaultArg overwrite false

            if not <| Directory.Exists src then directoryNotFound src
            elif nested src dst then
                failwithf "source and target directories are nested; cannot copy recursive."
            elif Directory.Exists dst then
                if overwrite then Directory.Delete(dst, true)
                else failwithf "Cannot copy to '%s'; directory already exists." dst

            copyRec src dst

        static member RevCopyRecursive (src : string, dst : string, ?overwrite) =
            let overwrite = defaultArg overwrite false
                
            let copy () =
                if not <| Directory.Exists src then directoryNotFound src
                elif nested src dst then
                    failwithf "source and target directories are nested; cannot copy recursive."

                let backup =
                    if Directory.Exists dst then
                        if overwrite then
                            let tmp = Path.GetTempPathName()
                            Directory.Move(dst, tmp)
                            Some tmp
                        else  
                            failwithf "Cannot copy to '%s'; directory already exists." dst
                    else None

                copyRec src dst, backup

            let recover backup =
                Directory.Delete(dst, true)
                backup |> Option.iter (fun tmp -> Directory.Move(tmp, dst))

            let fini backup =
                backup |> Option.iter (fun tmp -> if Directory.Exists tmp then Directory.Delete tmp)

            Reversible.FromComponents(copy, recover, ignore)


        static member RevDelete(directory : string, ?throwIfMissing) =
            let throwIfMissing = defaultArg throwIfMissing true
            let delete () =
                if not <| Directory.Exists directory then 
                    if throwIfMissing then directoryNotFound directory
                    else
                        (), None
                else
                    let tmp = Path.GetTempPathName ()
                    Directory.Move(directory, tmp)
                    (), Some tmp

            let recover backup = backup |> Option.iter (fun tmp -> Directory.Move(tmp, directory))

            let fini backup = 
                backup
                |> Option.iter (fun tmp -> 
                    if Directory.Exists tmp then 
                        Directory.Delete(tmp, true))

            Reversible.FromComponents(delete, recover, fini)