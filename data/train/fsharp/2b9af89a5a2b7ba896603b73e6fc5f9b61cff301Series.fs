namespace Series

open System
open System.Collections
open System.Collections.Generic

///allocationless circular buffer with Lookback from end
///Indexing is based from the end of the series.
///Enumeration is from the front... 
[<Sealed>]
type Series<'a> (items:'a[], head, tail) = //, factory:(unit -> 'a)
    let added = Event<'a>()
    let data = items
    let mutable head = head
    let mutable tail = tail
    let count = ref (head - tail + 1)
    let capacity = items.Length 
    let incrm x y = (x + y) % capacity
    let decr x y = (x - y + capacity) % capacity
    let forward i = 
        if !count = 0 || i >= !count then raise (IndexOutOfRangeException())
        data.[incrm tail i]
    let lookback i = 
        if !count = 0 || i >= !count then raise (IndexOutOfRangeException())
        data.[decr head i]
    let advance() =            
        if capacity > 1 then 
            incr count
            if !count > capacity then
                count := capacity
                tail <- incrm tail 1
            head <- incrm head 1
            data.[head] <- Unchecked.defaultof<'a>
        elif capacity = 1 && head = -1 then 
            count := 1
            head <- 0

    new(capacity) = Series(Array.zeroCreate capacity, -1, 0) 
    new() = Series(Array.zeroCreate 512, -1, 0) 
    new(items:'a[]) = Series(items, items.Length - 1, 0)
    [<CLIEvent>]
    member this.Added = added.Publish
    member this.Capacity with get() = capacity
    member this.Length with get() = !count
    member this.Lookback x = lookback x
    member this.Forward x = forward x
    member this.Add item = 
        advance()
        data.[head] <- item
        added.Trigger item
    member this.Current with get() = data.[head]
    member this.Item with get i = lookback i
    member this.Load (toLoad:'a[]) =
        for d in toLoad do 
            advance()
            data.[head] <- d
    member this.Clear() = 
        head <- -1
        tail <- 0
        count := 0
    member this.FillArray (result:'a[]) = 
        let i = result.Length
        //Array.Clear(result, 0, result.Length)
        match i with
        | 0 -> false
        | a when a <= !count && tail = 0 -> 
            Array.Copy(data, !count-a ,result, 0 , a)
            true
        | a when a <= !count &&  a <= tail -> 
            Array.Copy(data, head + 1 - a , result, 0, a);
            true
        | a when a <= !count && tail > 0 -> 
            let firstLength = tail
            let secondLength = a - firstLength
            let offset = !count - secondLength
            Array.Copy(data, head + 1 - firstLength , result, a - firstLength, firstLength)
            Array.Copy(data, offset , result, 0, secondLength)
            true
        | a when a > !count -> false
        | _ -> false
    member this.FillArray (result:'a[], indexes:int[])= 
        //assert they match lengths...
        let last = indexes.[indexes.Length-1]
        if last > this.Length then false else
        Array.iteri (fun i i2 -> result.[i] <- this.Lookback i2) indexes
        true   
    member this.ToArray i =
        match i with
        | 0 -> [||]
        | a when a <= !count && tail = 0 -> 
            let result = Array.zeroCreate<'a> a
            Array.Copy(data, !count-a ,result, 0 , a)
            result
        | a when a <= !count &&  a <= tail -> 
            let result = Array.zeroCreate<'a> a
            Array.Copy(data, head + 1 - a , result, 0, a);
            result
        | a when a <= !count && tail > 0 -> 
            let result = Array.zeroCreate<'a> a
            let firstLength = tail
            let secondLength = a - firstLength
            let offset = !count - secondLength
            Array.Copy(data, head + 1 - firstLength , result, a - firstLength, firstLength)
            Array.Copy(data, offset , result, 0, secondLength)
            result
        | a when a > !count -> this.ToArray(!count)
        | _ -> [||]
    member this.ToArray() = this.ToArray(!count)

    interface IEnumerable<'a> with 
        member this.GetEnumerator() = 
          let index = ref -1
          let current = ref(Unchecked.defaultof<'a>)
          { new IEnumerator<'a> with
                member e.Current with get() = !current
              interface System.IDisposable with
                member e.Dispose () = ()
              interface IEnumerator with
                member e.Reset () = index := -1; current := Unchecked.defaultof<'a>
                member e.Current with get() = box current
                member e.MoveNext () = 
                  incr index
                  if (!index >= !count) then false
                  else current := forward !index; true  }
        member this.GetEnumerator () =
          (this:>IEnumerable<'a>).GetEnumerator() :> IEnumerator   


[<CompilationRepresentation (CompilationRepresentationFlags.ModuleSuffix)>]
module Series = 
    let nth (s:Series<'a>) n = s.[n]

    //let map s f = 
    //let fold s f a = 