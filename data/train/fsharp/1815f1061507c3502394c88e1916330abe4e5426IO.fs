namespace ClusterManagement

module IO =

    // http://stackoverflow.com/questions/3453220/how-to-detect-if-console-in-stdin-has-been-redirected
    let isConsoleSizeZero =
        try (0 = (System.Console.WindowHeight + System.Console.WindowWidth))
        with _ -> true

    //let isOutputRedirected = isConsoleSizeZero && not System.Console.KeyAvailable
    //let isInputRedirected = isConsoleSizeZero && System.Console.KeyAvailable
    // see http://stackoverflow.com/a/36258285/1269722
    let stdInTTy =
        try Mono.Unix.Native.Syscall.isatty (0)
        // Windows doesn't support syscall
        with :? System.DllNotFoundException -> not isConsoleSizeZero
    //let stdOutTTy = Mono.Unix.Native.Syscall.isatty (1)
    //let stdErrTTy = Mono.Unix.Native.Syscall.isatty (2)

    //type CopyOptions =
    //    | Rec
    //    | Overwrite
    //    | IntegrateExisting
    //    | UseExisitingFiles
    //    | IgnoreErrors of (System.IO.IOException -> unit)
    type CopyOptions =
        { IsRecursive : bool
          DoOverwrite : bool
          IntegrateExisting : bool
          UseExisting : bool
          IgnoreErrors : option<System.IO.IOException -> unit> }
        static member Default =
            { IsRecursive = false
              DoOverwrite = false
              IntegrateExisting = false
              UseExisting = false
              IgnoreErrors = None }

    open System.IO
    /// Copes the source directory to the destination with the given CopyOptions
    let rec cp (options:CopyOptions) source dest =
        let doOverwrite = options.DoOverwrite // options |> List.exists (fun o -> match o with CopyOptions.Overwrite -> true | _ -> false)
        let useExisting = options.UseExisting //|> List.exists (fun o -> match o with CopyOptions.UseExisitingFiles -> true | _ -> false)
        let isRec = options.IsRecursive //|> List.exists (fun o -> match o with CopyOptions.Rec -> true | _ -> false)
        let integrateExisting = options.IntegrateExisting // |> List.exists (fun o -> match o with CopyOptions.IntegrateExisting -> true | _ -> false)
        if doOverwrite && useExisting then
            failwith "either overwrite, ignore or none but not both!"
        // assume we have cp /item1 /item2
        let doIgnore = options.IgnoreErrors //|> List.choose (fun o -> match o with CopyOptions.IgnoreErrors f -> Some f | _ -> None) |> Seq.tryHead
        let ignoreFun e =
            match doIgnore with
            | Some f -> f e
            | _ -> printfn "Ignoring: %O" e
        match true with
        |_ when File.Exists source ->
            try
                if File.Exists dest then
                    if not <| useExisting then
                        File.Copy(source, dest, doOverwrite)
                elif Directory.Exists dest then
                    // Copy to /item1/item2
                    let name = Path.GetFileName source
                    let newDest = Path.Combine(dest, name)
                    File.Copy(source, newDest, doOverwrite)
                else
                    File.Copy(source, dest, doOverwrite)
            with | :? IOException as e when doIgnore.IsSome ->  ignoreFun e
        |_ when Directory.Exists source ->
            try
                let toCopy = Directory.EnumerateFileSystemEntries(source)
                let doCopy dest items =
                    if isRec then
                        items
                        |> Seq.map
                            (fun item ->
                                let name = Path.GetFileName item
                                let dest = Path.Combine(dest, name)
                                item, dest)
                        |> Seq.iter
                            (fun (newSrc, newDest) -> cp { options with IntegrateExisting = true} newSrc newDest)
                    else ()
                if Directory.Exists dest then
                    // we copy all items into /item2/item1 when IntegrateExisting is not set
                    // when IntegrateExisting is set we copy all items into /item2
                    let dest =
                        if integrateExisting then
                            dest
                        else
                            let newDest = Path.Combine(dest, Path.GetFileName source)
                            Directory.CreateDirectory newDest |> ignore
                            newDest
                    toCopy
                    |> doCopy dest
                else
                    // Just copy to this dir
                    Directory.CreateDirectory(dest)|>ignore
                    toCopy
                    |> doCopy dest
            with | :? IOException as e when doIgnore.IsSome ->  ignoreFun e
        | _ -> failwith "Source not found!"

    type ChownOptions =
        | None = 0
        | Rec = 1
    let rec doRec traverse f item =
        match true with
        |_ when File.Exists item ->
            f true item
        |_ when Directory.Exists item ->
            f false item
            if traverse then
                Directory.EnumerateFileSystemEntries(item)
                    |> Seq.iter (fun item -> doRec true f item)
        | _ -> failwithf "item %s not found" item
    let chown (options:ChownOptions) (user:Mono.Unix.UnixUserInfo) (group:Mono.Unix.UnixGroupInfo) dest =
        let chownSimple _ item =
            let entry = Mono.Unix.UnixFileSystemInfo.GetFileSystemEntry item
            entry.SetOwner(user, group)

        doRec (options.HasFlag ChownOptions.Rec) chownSimple dest


    type CmodOptions =
        | None = 0
        | Rec = 1

    /// http://www.tutorialspoint.com/unix_system_calls/chmod.htm
    let chmod (options:CmodOptions) rights dest =
        if Env.isLinux then
            //let entry = Mono.Unix.UnixFileSystemInfo.GetFileSystemEntry dest
            let chmodSimple _ item =
                let r = Mono.Unix.Native.Syscall.chmod (item, rights)
                Mono.Unix.UnixMarshal.ThrowExceptionForLastErrorIf (r)
            doRec (options.HasFlag CmodOptions.Rec) chmodSimple dest
        else
            eprintfn "Ignoring chmod on windows"

    let getResourceText name =
        if Env.isVerbose then
            printfn "extracting resource '%s'" name
        let resourceStream = System.Reflection.Assembly.GetExecutingAssembly().GetManifestResourceStream(name)
        let reader = new System.IO.StreamReader(resourceStream)
        reader.ReadToEnd()

