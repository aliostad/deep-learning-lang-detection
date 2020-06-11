let inline (++) (w : ^W when ^W : (static member IsMeasureAbbrev : ^tm * ^t -> unit)) (t : ^t) = (# "" t : ^tm #)
let inline (--) (w : ^W when ^W : (static member IsMeasureAbbrev : ^tm * ^t -> unit)) (tm : ^tm) = (# "" tm : ^t #)

open System

[<MeasureAnnotatedAbbreviation>]
type Guid<[<Measure>] 'Measure> = Guid

[<MeasureAnnotatedAbbreviation>]
type string<[<Measure>] 'Measure> = string

// use member constraints to statically establish a measure relationship between types
type UoM = | UoM 
with
    static member IsMeasureAbbrev(_ : Guid<'Measure>, _ : Guid) = ()
    static member IsMeasureAbbrev(_ : string<'Measure>, _ : string) = ()

[<Measure>]
type processId = class end

[<Measure>]
type taskId = class end

type Entry = { ProcessId : Guid<processId> ; TaskId : Guid<taskId> }
with
    static member New() = { ProcessId = UoM ++ Guid.NewGuid() ; TaskId = UoM ++ Guid.NewGuid() }

match Entry.New () with
| { ProcessId = pid ; TaskId = tid } -> 
    { ProcessId = pid ; TaskId = tid }
//    { ProcessId = pid ; TaskId = pid } // uncomment for type error