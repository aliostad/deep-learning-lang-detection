namespace Xake.Tasks

open Xake
open System.IO
open Xake.FileTasksImpl

[<AutoOpen>]
module CpImpl =

    type CpArgs = {
        dir: string
        file: string
        files: Fileset
        todir: string
        flatten: bool
        verbose: bool
        overwrite: bool
        dryrun: bool
    } with static member Default = {
            dir = null
            file = null
            files = Fileset.Empty
            todir = null
            flatten = false
            verbose = false
            overwrite = false
            dryrun = false
        }

    module internal impl =
        let makeRelPath (root: string) =
            let rootLen = root.Length
            if rootLen <= 0 then id
            else
                let root', rootLen' =
                    if root.[rootLen - 1] = Path.DirectorySeparatorChar then
                        root, rootLen
                    else
                        root + (System.String (Path.DirectorySeparatorChar, 1)), rootLen + 1

                fun (path: string) ->
                    if path.StartsWith root' then
                        path.Substring rootLen'
                    else
                        path

        let getBasedirFullPath projectRoot fileset =
            let (Fileset ({BaseDir = basedir'}, _)) = fileset

            let basedir = basedir' |> function | None -> projectRoot | Some s -> Path.Combine(projectRoot, s)
            FileInfo(basedir).FullName

    let Cp (args: CpArgs) = recipe {
        do! trace Level.Debug "Copy: args=%A" args

        let! ctx = getCtx()

        let copyFile target getRelativePath file =
            let fullname = file |> File.getFullName
            let tofile = target </> (getRelativePath file)

            ctx.Logger.Log
                (if args.verbose then Level.Message else Level.Debug)
                "[copy] '%A' -> '%s'" fullname tofile

            if not args.dryrun then
                ensureDirCreated tofile

                if args.overwrite || not (File.Exists tofile) then
                    File.Copy(fullname, tofile, true)
                else
                    ctx.Logger.Log Level.Info "[copy] skipped ('%s' already exists while overwrite option is off)" tofile

        let projectRoot = ctx.Options.ProjectRoot
        let targetDir = args.todir |> function | null -> projectRoot | s -> System.IO.Path.Combine(projectRoot, s)

        let fileset =
            args
            |> function
            | { files = f } when f <> Fileset.Empty ->
                ctx.Logger.Log Level.Message "[copy] fileset"
                f
            | { file = fileMask } when fileMask <> null ->
                ctx.Logger.Log Level.Message "[copy] %A" fileMask
                !!fileMask
            | { dir = dirMask } when dirMask <> null ->
                !!(dirMask </> "**/*.*")
            | _ -> Fileset.Empty

        // in single file mode always flatten
        let flatten = args.flatten || args.file <> null
        let getRelativePath = flatten |> function
            |true -> File.getFileName
            | _ ->
                let baseFullPath = impl.getBasedirFullPath projectRoot fileset
                File.getFullName >> (impl.makeRelPath baseFullPath)

        do! trace Level.Debug "[copy] materializing fileset %A at folder %s" fileset projectRoot
        let (Filelist files) = fileset |> (toFileList projectRoot)
        
        do! needFiles (Filelist files)

        for file in files do
            copyFile targetDir getRelativePath file

        do! trace Level.Info "[copy] Completed"    
        return ()
    }

    /// <summary>
    /// Copies one file to another location.
    /// </summary>
    /// <param name="src">Source file name</param>
    /// <param name="tgt">Target file location and name.</param>
    let copyFile (src: string) tgt = recipe {
        do! need [src]
        do! trace Level.Info "[copyFile] '%A' -> '%s'" src tgt

        do ensureDirCreated tgt

        File.Copy(src, tgt, true)
    }

    /// <summary>
    /// Requests the file and writes under specific name
    /// </summary>
    let copyFrom (src: string) = recipe {
        let! tgt = getTargetFullName()
        do! copyFile src tgt
    }

    type CopyBuilder() =

        [<CustomOperation("file")>]    member this.File(a :CpArgs, value) =   {a with file = value }
        [<CustomOperation("dir")>]     member this.Dir(a :CpArgs, value) =    {a with dir = value}
        [<CustomOperation("files")>]   member this.Fileset(a :CpArgs, value)= {a with files = value}
        [<CustomOperation("todir")>]   member this.ToDir(a :CpArgs, value)=   {a with todir = value}
        [<CustomOperation("verbose")>] member this.Verbose(a :CpArgs) =        {a with verbose = true}
        [<CustomOperation("overwrite")>] member this.Overwrite(a :CpArgs) =    {a with overwrite = true}
        [<CustomOperation("flatten")>] member this.Flatten(a :CpArgs) =        {a with flatten = true}
        [<CustomOperation("dryrun")>] member this.Dryrun(a :CpArgs) =          {a with dryrun = true}

        member this.Bind(x, f) = f x
        member this.Yield(()) = CpArgs.Default
        member x.For(sq, b) = for e in sq do b e

        member this.Zero() = CpArgs.Default
        member this.Run(args:CpArgs) = Cp args

    let copy = CopyBuilder()
    let cp = copy
