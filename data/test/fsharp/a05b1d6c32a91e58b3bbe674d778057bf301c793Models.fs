namespace SC.KPI.API.PostData.FSharp.WebAPI.Models

open System
open System.Collections.Generic
open System.Collections.Concurrent

type Category = {
    Key : string
    Name : string
    Sorting : int
}

type CategoryRepository = {
    Add : Category -> Option<Category>
    GetAll : unit -> seq<Category>
    Find : string -> Option<Category>
    Remove : string -> Option<Category>
    Update : Category -> Option<Category>
}

module CategoryRepositoryDb =
    let private categories = new ConcurrentDictionary<string, Category>()

    let add category =
        let copy = { category with Key = Guid.NewGuid().ToString() }
        if categories.TryAdd(copy.Key, copy) then
            Some(copy)
        else 
            None

    let getAll (key:unit) = categories.Values |> Seq.cast

    let find key =
        let (success, value) = categories.TryGetValue(key)
        if success then
            Some(value)
        else 
            None
    
    let remove key =
        let (success, value) = categories.TryRemove(key)
        if success then
            Some(value)
        else 
            None
    
    let update category =
        let tryupdate current =
            if categories.TryUpdate(category.Key, category, current) then
                Some(category)
            else 
                None
        find category.Key |> Option.bind tryupdate

    let categoryRepositoryDb = {
        Add = add
        GetAll = getAll
        Find = find
        Remove = remove
        Update = update
    }
