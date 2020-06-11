namespace GabeSoft.FOPS.Core

open System

type OperationException (message:string, ?innerException:Exception) =
   inherit Exception (
      message, 
      match innerException with | Some ex -> ex | None -> null)

/// Operations engine.
type Engine(server: IOServer, ?log:Log) =
  let info, warn, fail =   
    let logger = match log with 
                  | Some l -> l 
                  | None -> new LogImpl () :> Log
    logger.Info, logger.Warn, logger.Fail
  let copy src dst = server.Provider.Copy (src, dst)
  let link src dst = server.Provider.Link (src, dst)
  let yank src = server.Provider.DeleteFile src
  let yankd src = server.Provider.DeleteDirectory (src, true)

  let cinfo src dst = sprintf "COPY: %s -> %s (DONE)" src dst |> info
  let cwarn src dst reason = sprintf "COPY: %s -> %s (%s)" src dst reason |> warn
  let cfail src dst reason = sprintf "COPY: %s -> %s (ERROR: %s)" src dst reason |> fail
  let linfo src dst = sprintf "LINK: %s -> %s (DONE)" src dst |> info
  let lwarn src dst reason = sprintf "LINK: %s -> %s (%s)" src dst reason |> warn
  let lfail src dst reason = sprintf "LINK: %s -> %s (ERROR: %s)" src dst reason |> fail
  let yinfo src = sprintf "DELETE: %s (DONE)" src |> info
  let ywarn src reason = sprintf "DELETE: %s (%s)" src reason |> warn
  let yfail src reason = sprintf "DELETE: %s (ERROR: %s)" src reason |> fail
  let ydinfo src = sprintf "DELETE-DIR: %s (DONE)" src |> info
  let ydwarn src reason = sprintf "DELETE-DIR: %s (%s)" src reason |> warn
  let ydfail src reason = sprintf "DELETE-DIR: %s (ERROR: %s)" src reason |> fail

  let getNode path spec = path |> server.Node |> Filter.apply spec

  let yankPattern src = 
    let spec = {
      Pattern = Wildcard.toRegex src
      Exclude = []
      Recursive = Wildcard.isRecursive src }
    let node = getNode (Wildcard.root src) spec
    node.AllFiles |> Seq.iter (fun f -> 
                                  yank f.Path
                                  yinfo f.Path)

  let yankDir src =
    let exists = server.Provider.DirectoryExists
    match exists src with
    | false   -> ydwarn src "SKIPPED: folder does not exist"
    | true    ->
        yankd src 
        match exists src with
        | true  -> ydwarn src "DONE: some files could not be deleted"
        | false -> ydinfo src

  let copyFile (copy, info, warn) (src, dst, force) =
    let exists = server.Provider.FileExists
    let mkdir = server.Provider.CreateDirectory
    match exists src with
    | false -> warn src dst "SKIPPED: source file does not exist"
    | true  ->
        match exists dst, force with
        | true, false   ->  warn src dst "SKIPPED: destination file already exists"
        | true, true    ->  dst |> Path.directory |> mkdir
                            yank dst
                            copy src dst
                            warn src dst "DONE: replaced"
        | false, _      ->  dst |> Path.directory |> mkdir
                            copy src dst
                            info src dst
  
  let rec copyDeep (copy, info, warn) (fdst, force) (node:IONode) =
    let src = node.Path
    let dst = fdst src
    match node.Type with
    | FileNode      -> copyFile (copy, info, warn) (src, dst, force)
    | DirectoryNode    -> 
      node.Files 
      |> Seq.append node.Directories
      |> Seq.iter (copyDeep (copy, info, warn) (fdst, force))
    | _             -> fail "unsupported node type"

  let copyDir (copy, info, warn) (src, dst, force, excludes) =
    let excludes = excludes |> List.map Wildcard.toRegex    
    let dstExists = server.Provider.DirectoryExists dst
    let spec = {
      Pattern = (Wildcard.matchAll src)
      Exclude = (Wildcard.matchAll dst) :: excludes
      Recursive = true }
    let node = getNode src spec
    let fdst = 
      let dst = match dstExists with 
                | true -> Path.combine dst (Path.file src) 
                | false -> dst
      fun path -> Path.combine dst (Path.part src path)
    copyDeep (copy, info, warn) (fdst, force) node

  let copyPattern (copy, info, warn) (src, dst, force, excludes) =
    let excludes = excludes |> List.map Wildcard.toRegex
    let spec = {
      Pattern = (Wildcard.toRegex src)
      Exclude = (Wildcard.matchAll dst) :: excludes
      Recursive = Wildcard.isRecursive src }
    let node = getNode (Wildcard.root src) spec
    let fdst path = Path.combine dst (Path.file path)
    node.AllFiles |> Seq.iter (copyDeep (copy, info, warn) (fdst, force))

  let runSafe fail run =
    try 
      run ()
    with
      | :? ArgumentException as e -> fail e.Message
      | :? System.Reflection.TargetInvocationException as e -> 
        match e.InnerException with
        | null    -> raise e
        | inner   -> fail inner.Message

  let runItem = function
  | Copy (s, d, o, e, c)  -> 
    runSafe (cfail s d)
            (fun () ->
              match c with
              | FileMode    -> copyFile (copy, cinfo, cwarn) (s, d, o)
              | DirectoryMode  -> copyDir (copy, cinfo, cwarn) (s, d, o, e)
              | PatternMode -> copyPattern (copy, cinfo, cwarn) (s, d, o, e))
  | Link (s, d, o, e, c)  ->
    let srcRoot = Path.root s
    let dstRoot = Path.root d
    let equal a b = String.Equals(a, b, StringComparison.OrdinalIgnoreCase)
    match equal srcRoot dstRoot with
    | false -> lfail s d "the source and destination paths must be on the same volume"
    | true  -> 
      runSafe (lfail s d)
              (fun () ->
                match c with
                | FileMode    -> copyFile (link, linfo, lwarn) (s, d, o)
                | DirectoryMode  -> copyDir (link, linfo, lwarn) (s, d, o, e)
                | PatternMode -> copyPattern (link, linfo, lwarn) (s, d, o, e))
  | Yank (s, t)   ->  
    runSafe (match t with
            | DirectoryMode -> ydfail s
            | _             -> yfail s)
            (fun () ->
              match t with
              | FileMode    -> yfail s "invalid mode for delete"
              | DirectoryMode  -> yankDir s
              | PatternMode -> yankPattern s)

  let runJob (job:Job) = Seq.iter runItem job.Items
  
  member x.Run job = runJob job  
  member x.Run jobs = Seq.iter runJob jobs
