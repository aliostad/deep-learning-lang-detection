namespace GabeSoft.FOPS.Core

open System

type ItemType = 
   /// copy/delete a single file
   | FileMode 
   /// copy/delete all contents of a directory recursively
   | DirectoryMode 
   /// copy/delete a list of files that match a wildcard pattern
   | PatternMode

/// File operations job item.
type Item = 
   /// Copy (src, dst, force, exclude, type)
   | Copy of string * string * bool * string list * ItemType
   /// Hard link (src, dst, force, exclude, type)
   | Link of string * string * bool * string list * ItemType
   /// Delete (src)
   | Yank of string * ItemType
   /// Constructs a copy item.
   static member copy c (s, d, f, e) = Copy (s, d, f, e, c)
   /// Constructs a link item.
   static member link c (s, d, f, e) = Link (s, d, f, e, c)
   /// Constructs a delete item.
   static member yank c s = Yank (s, c)

/// File operations job.
type Job (items:Item list, ?id, ?baseSrc, ?baseDst) =
  let _id = match id with Some e -> e | _ -> Guid.NewGuid().ToString()
  let _baseSrc = match baseSrc with Some b -> b | _ -> String.Empty
  let _baseDst = match baseDst with Some b -> b | _ -> String.Empty

  let empty s = String.IsNullOrEmpty(s)
  let complete parent path = 
    let parent = parent |> Path.normalize
    let path = match empty parent with
                | true  -> path |> Path.normalize
                | false -> path |> Path.trim |> Path.normalize
    match Path.rooted path, empty parent with
    | true, _      -> path
    | false, true  -> Path.combine Path.cwd path
    | false, false -> Path.combine parent path
  let completeDst = complete _baseDst
  let completeSrc = complete _baseSrc
    
  let makePathsAbsolute = function
  | Copy (s, d, f, e, c)  -> 
    Copy (completeSrc s, completeDst d, f, List.map completeSrc e, c)
  | Link (s, d, f, e, c)  -> 
    Link (completeSrc s, completeDst d, f, List.map completeSrc e, c)
  | Yank (s, c)           -> Yank (completeSrc s, c)

  let _items = items |> List.map makePathsAbsolute

  member x.Id with get() = _id
  member x.Items with get() = _items
  member x.BaseSrc with get() = _baseSrc
  member x.BaseDst with get() = _baseDst
  member x.WithSrc baseSrc = new Job(items, _id, baseSrc, _baseDst)
  member x.WithDst baseDst = new Job(items, _id, _baseSrc, baseDst)