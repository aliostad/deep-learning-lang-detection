namespace Machete.RegExp

open System.Collections
open System.Collections.Generic

type Captures =

    val captures : List<string>

    new (cs:string seq) = {
        captures = List<string> (cs)
    }

    private new (cs:List<string>) = {
        captures = cs
    }
    
    member x.Length = x.captures.Count

    member x.Item index = x.captures.[index]

    member x.CopyWith (index:int, value:string) =
        let cs = x.captures.ToArray ()
        cs.[index] <- value
        Captures cs
        
    interface IEnumerable<string> with
        member x.GetEnumerator () : IEnumerator<string> =
            x.captures.GetEnumerator () :> IEnumerator<string>
    interface IEnumerable with
        member x.GetEnumerator () : IEnumerator =
            x.captures.GetEnumerator () :> IEnumerator
