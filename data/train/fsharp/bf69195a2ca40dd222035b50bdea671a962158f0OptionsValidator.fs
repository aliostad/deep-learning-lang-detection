namespace GabeSoft.FOPS.Core

open System
open System.Collections.Generic

/// Object used to validate a set of command line options
/// and use them to create a list of jobs.
type OptionsValidator(log:Log) =
  let statusItems = new Queue<string * string * (string -> unit)>()
  let status write title value = 
    statusItems.Enqueue(title, value, write)
  let printStatus () =
    let pad n (text:string) =
      let len = text.Length
      if len >= n then text else
      Seq.init (n - len) (fun _ -> " ")
      |> Seq.append [text]
      |> String.concat ""
    let items = statusItems.ToArray()
    let maxl = 
      match items with
      | [||]  -> 0
      | _     -> items
                  |> Seq.map (fun (t, _, _) -> t.Length)
                  |> Seq.max
    items
    |> Seq.iter (fun (t, v, w) -> sprintf "- %s: %s" (pad maxl t) v |> w)

  let empty (s:string) = String.IsNullOrEmpty(s) 
  let action texts = status log.Info "ACTION" (String.concat " " texts)
  let info = status log.Info
  let fail = status log.Fail "ERROR"

  let iover v = info "OVERWRITE" (string v)
  let ipath = info "PATH"
  let ipatt = info "PATTERN"
  let idest = info "DESTINATION"

  let mkJobs items = [new Job(items)]

  let usage (opts:Options) = 
    opts.WriteUsage()
    []
  
  let ofFile (opts:Options) = 
    let path = Path.full opts.File
    let provider = new IOProviderImpl() :> IOProvider
    action ["run job(s) in FILE"]
    info "FILE" path
    match provider.FileExists(path) with
    | false ->  fail "FILE not found on disk"
                []
    | true  ->  
        let runAll = empty opts.JobId
        let jobs = 
          JobsParser.parseFile(path)
          |> List.filter (fun j -> runAll || j.Id = opts.JobId)
          |> List.map (fun j -> match empty opts.BaseSrc with
                                | true  -> j
                                | false -> j.WithSrc opts.BaseSrc)
          |> List.map (fun j -> match empty opts.BaseDst with
                                | true  -> j
                                | false -> j.WithDst opts.BaseDst)
        info "RUN JOB(S)" (jobs 
                            |> List.map (fun j -> j.Id) 
                            |> String.concat ", ")
        if not (empty opts.BaseSrc) then info "BASE SOURCE" opts.BaseSrc
        if not (empty opts.BaseDst) then info "BASE DESTINATION" opts.BaseDst
        jobs

  let ofYank actionMessage failMessage info mode (opts:Options) =
    action [actionMessage]
    info opts.Src
    match empty opts.Src with
    | true  ->  fail failMessage
                []
    | false ->  mkJobs [Yank (opts.Src, mode)]
    
  let ofYankPatt (opts:Options) = 
    ofYank  "delete all files matching PATTERN"
            "no PATTERN specified"
            ipatt PatternMode opts

  let ofYankDir (opts:Options) =
    ofYank  "delete directory at PATH"
            "no PATH specified" 
            ipath DirectoryMode opts

  let ofCopyPatt f desc (opts:Options) = 
    action [desc; "all files matching PATTERN to DESTINATION"]
    ipatt opts.Src
    idest opts.Dst
    iover opts.Force
    mkJobs [f (opts.Src, opts.Dst, opts.Force, [], PatternMode)]

  let ofCopy f desc mode (opts:Options) =
    action [desc; "from PATH to DESTINATION"]
    ipath opts.Src
    idest opts.Dst
    iover opts.Force
    mkJobs [f (opts.Src, opts.Dst, opts.Force, [], mode)]

  let ofMove desc copyMode yankMode (opts:Options) =
    action ["move"; desc; "from PATH to DESTINATION"]
    ipath opts.Src
    idest opts.Dst
    iover opts.Force
    mkJobs [  Copy (opts.Src, opts.Dst, opts.Force, [], copyMode)
              Yank (opts.Src, yankMode) ]

  /// Creates a list of jobs that match the 
  /// specified options.
  member x.CreateJobs (opts:Options) = 
    let actions = [
      opts.Help, usage
      not (empty opts.File), ofFile
      opts.Copy, ofCopyPatt Copy "copy"
      opts.CopyDir, ofCopy Copy "copy directory" DirectoryMode
      opts.CopyFile, ofCopy Copy "copy file" FileMode
      opts.Link, ofCopyPatt Link "link"
      opts.LinkDir, ofCopy Link "link directory" DirectoryMode
      opts.LinkFile, ofCopy Link "link file" FileMode
      opts.MoveDir, ofMove "directory" DirectoryMode DirectoryMode
      opts.MoveFile, ofMove "file" FileMode PatternMode
      opts.Yank, ofYankPatt
      opts.YankDir, ofYankDir ]
    let action = actions |> List.tryFind (fun (a, _) -> a)
    let jobs = match action with
                | Some (a, f)   ->  f opts
                | None          ->  fail "no action detected"
                                    []
    printStatus()
    jobs
