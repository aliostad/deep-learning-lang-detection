namespace PoeExchange.TradeAPI.Watcher.Lib

type UpdateStats(id) =
    let mutable changeId:string = id
    let mutable requestTime:int64 = 0L
    let mutable processTime: int64 = 0L
    let mutable insertedItems:int64 = 0L
    let mutable itemCount:int64 = 0L
    let mutable deletedItems:int64 = 0L
    let mutable stashCount:int64 = 0L

    member this.ChangeId with get() = changeId and set(v) = changeId <- v

    member this.RequestTime with get() = requestTime and set(v) = requestTime <- v

    member this.ProcessTime with get() = processTime and set(v) = processTime <- v

    member this.InsertedItems with get() = insertedItems and set(v) = insertedItems <- v

    member this.ItemCount with get() = itemCount and set(v) = itemCount <- v

    member this.DeletedItems with get() = deletedItems and set(v) = deletedItems <- v

    member this.StashCount with get() = stashCount and set(v) = stashCount <- v
