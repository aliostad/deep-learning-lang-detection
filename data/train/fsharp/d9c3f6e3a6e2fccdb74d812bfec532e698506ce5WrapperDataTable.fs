// ----------------------------------------------------------------------------
// This file is subject to the terms and conditions defined in
// file 'LICENSE.txt', which is part of this source code package.
// ----------------------------------------------------------------------------
namespace Yaaf.GameMediaManager.Primitives

[<System.Runtime.CompilerServices.Extension>]
[<AutoOpen>]
module WrapperDataTable = 
    open System.Data
    open System
    open Yaaf.GameMediaManager.Primitives
    open Yaaf.GameMediaManager.Primitives.Reflection
    type ItemData<'T> = {
        Original : 'T
        Copy : 'T }
    type ItemChangedData<'T> = {
        Items : ItemData<'T>
        ChangedCopy : bool ref }

    type InitRowData<'T> = {
        CopyOrTempItem : 'T }
    type UserAddedRowData<'T> = {
        OriginalItem : 'T }
    type DeletedRowData<'T> = {
        CopyItem : 'T }
    /// Wrapps an DataTable in a type-safe manner.
    /// Does not write though into the item collection, but on a copy.
    type WrapperTable<'T when 'T : not struct and 'T : equality and 'T : null> 
        internal(
                    /// The columns for the table
                    createColumns: unit -> DataColumn seq, 
                    /// Update a row from data (data -> row -> ())
                    updateRowFun: 'T -> DataRow -> unit, 
                    /// Update item from row (row -> copydata -> ())
                    updateCopyItemFun: DataRow -> 'T -> unit, 
                    /// Update item from another item (isDestOriginal -> dest -> source -> ())
                    importChangesFun: bool -> 'T -> 'T -> unit,
                    /// Init the data (initOriginal -> data)
                    initFun: bool -> 'T) =   
        let table = new DataTable()  
        let itemChanged = new Event<ItemChangedData<'T>>()
        let initRow = new Event<InitRowData<'T>>()
        let userAddedRow = new Event<UserAddedRowData<'T>>()        
        let deletedRow = new Event<DeletedRowData<'T>>()        
        do
            for c in createColumns() do
                table.Columns.Add c

        let rowReferences = new System.Collections.Generic.Dictionary<_,_>()
        let copyRowReferences = new System.Collections.Generic.Dictionary<_,_>()
        let itemReferences = new System.Collections.Generic.Dictionary<_,_>()
        let copyItemReferences = new System.Collections.Generic.Dictionary<_,_>()
        let copyLinqData = new System.Collections.Generic.HashSet<_>()
        
        let mutable isListening = false
        let withoutListening f = 
            let old = isListening
            try
                isListening <- false
                f()
            finally
                isListening <- old

        let updateCopyItem = updateCopyItemFun 
        let importChanges = importChangesFun 
        let importToOriginal original copy = importChanges true original copy
        let importToCopy copy external = importChanges false copy external
        
        
        
        let updates = new System.Collections.Generic.List<_>()
        let inserts = new System.Collections.Generic.List<_>()
        let deletions = new System.Collections.Generic.List<_>()
        let checkIfUpdate row = 
            if not <| updates.Contains row
               && not <| inserts.Contains row 
               && not <| deletions.Contains row then
                updates.Add row

        let updateRowRaw item row = 
            withoutListening (fun _ -> updateRowFun item row)
        let updateRowWithUpdate item row = 
            checkIfUpdate row
            updateRowRaw item row

        let triggerRowChanged row = 
            let copyItem = copyRowReferences.Item row
            let updateCopy = ref false
            itemChanged.Trigger({ Items = { Original = rowReferences.Item row; Copy = copyItem}; ChangedCopy = updateCopy})
            if !updateCopy then
                withoutListening (fun _ ->
                    updateRowRaw copyItem row)

        let handleUpdate row = 
            checkIfUpdate row
            let copyItem = copyRowReferences.Item row
            updateCopyItem row copyItem
            triggerRowChanged row

        
        let addCopyForRow row = 
            let copy = initFun false
            updateCopyItem row copy
            copyLinqData.Add copy |> ignore
            copyRowReferences.Add(row, copy)
            copyItemReferences.Add(copy, row)  

        let addReferencesForNewItem row data =  
            rowReferences.Add(row, data)
            itemReferences.Add(data, row)  
            addCopyForRow row

        let addData data = 
            let newRow = table.NewRow()
            updateRowRaw data newRow
            addReferencesForNewItem newRow data
            table.Rows.Add(newRow)


        let addAllData data = 
            for d in data do
                addData d
        
        let handleDeletion row = 
            let copyItem = copyRowReferences.Item row
            deletedRow.Trigger { CopyItem = copyItem }
            if inserts.Contains row then
                inserts.Remove row |> ignore
            else
                updates.Remove row |> ignore
                deletions.Add row
            copyLinqData.Remove copyItem |> ignore

        let handleInsertion row = 
            if deletions.Contains row then
                invalidOp "can't revive dead row"
                deletions.Remove row |> ignore
                copyLinqData.Add (copyRowReferences.Item row) |> ignore
            else
                inserts.Add row
                if updates.Contains row then
                    updates.Remove row |> ignore
                if not <| rowReferences.ContainsKey row then
                    let newItem = initFun true
                    // INCONSISTENCY: This is no copy but we do this anyway to get the latest changes from user
                    updateCopyItem row newItem
                    //updateItem false row newItem
                    userAddedRow.Trigger { OriginalItem = newItem }
                    addReferencesForNewItem row newItem
                    triggerRowChanged row

        let handleNewRow row = 
            let newItem = initFun false
            initRow.Trigger { CopyOrTempItem = newItem }
            updateRowRaw newItem row

        do 
            table.RowChanged
                |> Event.add 
                    (fun e ->
                        if isListening then
                            match e.Action with
                            | DataRowAction.Commit -> ()
                            | DataRowAction.Add -> handleInsertion e.Row
                            | _ -> handleUpdate e.Row)
            table.RowDeleting |> Event.add (fun e -> if isListening then handleDeletion e.Row)
            table.TableNewRow |> Event.add (fun e -> if isListening then handleNewRow e.Row)

        let startListen () =
            table.AcceptChanges()
            isListening <- true

        let getInfo = (fun r -> rowReferences.Item r, r)
        let mutable invalidated = false
        let invalidate() = 
            deletions.Clear()
            updates.Clear()
            inserts.Clear()
            invalidated <- true

        let checkValid() = 
            if invalidated then
                invalidOp "This object has been invalidated!"

        let updateFromChangedData copied = 
            let row = copyItemReferences.Item copied
            updateRowWithUpdate copied row 
            
        let updateItem originalItem newItem = 
            let row = itemReferences.Item originalItem
            let copy = copyRowReferences.Item row
            importToCopy copy newItem
            updateRowWithUpdate copy row


        let importChanges (otherTable:WrapperTable<'T>) = 
            let mapToRow = Seq.map 

            for itemInfo in otherTable.Inserts  do
                addData itemInfo.Original
                updateItem itemInfo.Original itemInfo.Copy

            for currentRow in 
                    otherTable.Deletions 
                        |> Seq.map (fun (itemRef) -> itemRef.Original)
                        |> Seq.map (fun (item) -> itemReferences.Item item) do
                currentRow.Delete()

            for itemInfo in otherTable.Updates  do
                updateItem itemInfo.Original itemInfo.Copy

            table.AcceptChanges()
            otherTable.Invalidate()


        let fromCopiedData copiedData = 
            let newTable = new WrapperTable<_>(createColumns, updateRowFun, updateCopyItemFun, importChangesFun, initFun)
            for copyData, origData in 
                copiedData 
                    |> Seq.map 
                        (fun copy -> 
                            copy, 
                            let row = copyItemReferences.Item copy
                            rowReferences.Item row) do
                newTable.InternalAdd origData
                newTable.UpdateItem(origData, copyData)

            newTable.StartListening()
            newTable
        let clone () = 
            fromCopiedData copyLinqData
            
        member internal x.StartListening () = 
            startListen()

        member x.UpdateItem (orig, changed) = 
            updateItem orig changed
            table.AcceptChanges()

        /// Update the given changed copy
        member x.UpdateItem (changedCopy) = updateFromChangedData(changedCopy)
        member internal x.InternalAddItems items = addAllData items
        member internal x.InternalAdd item = addData item

        /// Add the given item (will not be changed)
        member x.Add item = 
            checkValid()
            addData item
            table.AcceptChanges()

        /// Adds the given items (they will not be changed)
        member x.AddRange items = 
            checkValid()
            addAllData items
            table.AcceptChanges()

        /// Delete the row represented by this copy
        member x.DeleteCopyItem item = 
            checkValid()
            let row = copyItemReferences.Item item
            row.Delete()

        /// Delete the row represented by this item (throws an exception if already deleted)
        member x.DeleteItem item = 
            checkValid()
            let row = itemReferences.Item item
            row.Delete()

        /// Invalidates the current table (use this wenn you processed the changes)
        member x.Invalidate() = 
            table.Clear()
            table.AcceptChanges()
            invalidate()

        /// Checks if this object is still usable
        member x.IsInvalidated
            with get () = invalidated
            
        /// Update the given original item from the saved changes (will finally write through into the items)
        member x.ImportChangesToOriginal dest source = 
            checkValid()
            importToOriginal dest source

        member internal x.InternalGetCopyItem row = copyRowReferences.Item row

        /// Gets the copyitem for the given row, None is given for not fully added rows. (Or Rows from other tables)
        member x.GetCopyItem row = 
            checkValid()
            match copyRowReferences.TryGetValue row with
            | true, v -> Some v
            | _ -> None

        /// Gets the item-data for the given row
        member x.GetRowData row = 
            checkValid()
            match x.GetCopyItem row with
            | Some copyItem ->
                Some { Original = rowReferences.Item row; Copy = copyItem }
            | None -> None

        /// Indexer for rows
        member x.Item
            with get(row) = 
                checkValid()
                x.GetRowData row

        /// Indexer for copyItems
        member x.CopyItemToRow
            with get(item) = 
                checkValid()
                copyItemReferences.Item item

        /// Indexer for copyItems
        member x.OriginalItemToRow
            with get(item) = 
                checkValid()
                itemReferences.Item item

        /// Gets the original item from the copy item
        member x.CopyItemToOriginal
            with get (copy ) = 
                checkValid()
                let row = copyItemReferences.Item copy
                rowReferences.Item row

        /// Gets the item for the given row
        member x.GetItem row = 
            checkValid()
            rowReferences.Item row

        /// Gets the row for the given original item
        member x.GetRow item = 
            checkValid()
            itemReferences.Item item
        
        /// Gets the row for the given copyied item
        member x.GetRowFromCopy item =
            checkValid()
            copyItemReferences.Item item

        /// Clones this Wrapper
        member x.Clone () = 
            clone()

        /// Imports the changes from another table
        member x.ImportChanges o = 
            checkValid()
            importChanges o
        
        /// Gets a new Table with the given copied data (must be from this table for example from the CopyLinqData member)
        member x.GetCopiedTableFromCopyData copyData = 
            fromCopiedData copyData

        /// Will be triggered when we need a new Row (and some init data for it)
        [<CLIEvent>]
        member x.InitRow = initRow.Publish

        /// Will be triggered when there was finally added a new row on the sourcetable (will not be called on add methods).
        /// This (original) item will not be modified any further. Changes to the item will not be displayed.
        [<CLIEvent>]
        member x.UserAddedRow = userAddedRow.Publish
        
        /// Will be triggered when a row was deleted (given the copy item)
        [<CLIEvent>]
        member x.DeletedRow = deletedRow.Publish

        /// Will be triggered when a item was changed Parameters: originalItem, copyItem, changedCopyItem
        /// Call set last parameter to true when you change the copyItem properties.
        [<CLIEvent>]
        member x.ItemChanged = itemChanged.Publish

        /// Gets the Source table for manipulation or data-binding
        member x.SourceTable 
            with get() = 
                checkValid()
                table

        /// Gets a IEnumerable of current copy-items for LINQ
        member x.CopyLinqData 
            with get() = 
                copyLinqData :> seq<_>


        member x.Inserts 
            with get() = inserts |> Seq.map (fun row -> x.[row].Value) |> Seq.cache
        member x.Deletions 
            with get() = deletions  |> Seq.map (fun row -> x.[row].Value) |> Seq.cache
        member x.Updates 
            with get() = updates |> Seq.map (fun row -> x.[row].Value) |> Seq.cache

    
    let getProps<'a> filter = 
        typeof<'a>    
            |> getProperties allFlags 
            |> Seq.filter filter

    let getPropsDelegate<'a> (filter:Func<_,_>) = 
        getProps<'a> filter.Invoke
        
    let getFilter propNames = 
        (fun (prop:Reflection.PropertyInfo) -> 
            propNames |> Array.exists (fun name -> name = prop.Name))
    
    let getFilterDelegate propNames = 
        new Func<_,_>(getFilter propNames)

    let getTable createColumns init updateRow updateCopyItem importChanges data = 
        let wrapper = 
            new WrapperTable<_>(
                createColumns, updateRow, updateCopyItem, importChanges, init)
        wrapper.InternalAddItems(data)
        wrapper.StartListening()
        wrapper
    
    /// Create a typed table from the given data
    [<System.Runtime.CompilerServices.Extension>]
    let CreateTable data (createColumns:Func<_>) (init:Func<_,_>) (updateRow:Action<_,_>) (updateCopyItem:Action<_,_>) (importChanges:Action<_,_,_>) =
        getTable 
            createColumns.Invoke 
            init.Invoke
            (fun i r -> updateRow.Invoke(i, r)) 
            (fun r i -> updateCopyItem.Invoke(r, i)) 
            (fun isOriginal toImport fromImport -> importChanges.Invoke(isOriginal, toImport, fromImport)) 
            data

    let getSimpleTable<'a when 'a : (new : unit -> 'a) and 'a : not struct and 'a : equality and 'a : null> (createColumns:unit -> DataColumn seq) updateRow updateItem (data: 'a seq) = 
        let helperTable = new DataTable()
        for c in createColumns() do
            helperTable.Columns.Add c
        let updateCopyItem = (fun row copy -> updateItem false row copy)
        let importChanges = 
            (fun toOriginal toImport fromImport -> 
                let row = helperTable.NewRow()
                updateRow fromImport row
                updateItem toOriginal row toImport)
        getTable createColumns (fun isOrig -> new 'a()) updateRow updateCopyItem importChanges data
    
    /// the first parameter of updateItem indicates whether we are updating an original item => true (or a copy => false)
    [<System.Runtime.CompilerServices.Extension>]
    let CreateSimpleTable data (createColumns:Func<_>) (updateRow:Action<_,_>) (updateItem:Action<_,_,_>) =
        getSimpleTable createColumns.Invoke (fun i r -> updateRow.Invoke(i, r)) (fun isOriginal r i -> updateItem.Invoke(isOriginal, r, i)) data
    

    [<System.Runtime.CompilerServices.Extension>]
    let ConvertValueToDb value= 
        if obj.ReferenceEquals(value, null) then System.DBNull.Value:>obj else value

    [<System.Runtime.CompilerServices.Extension>]
    let ConvertValueBack (value:obj) (defaultValue:'a) = 
        match value with
        | :? System.DBNull -> defaultValue
        | _ -> value :?> 'a

    let getWrapper filter (data:'a seq) = 
        let props = getProps<'a> filter |> Seq.cache
        let createColumns() =
            props 
                |> Seq.map (fun prop -> prop.Name, prop.PropertyType)
                |> Seq.map 
                    (fun (name, t) ->
                        name,
                        if t.IsGenericType && t.GetGenericTypeDefinition() = typedefof<Nullable<_>> then
                            Nullable.GetUnderlyingType t
                        else t)
                |> Seq.map (fun (name, t) -> new DataColumn(name, t))
            

        let updateRow (data:'T) (row:DataRow) =
            for name, value in
                    props 
                        |> Seq.map (fun prop -> prop.Name, data |> Reflection.getPropertyValue prop) do
                row.[name] <- ConvertValueToDb value

        let updateItem isOriginal (row:DataRow) (data:'T) =
            for prop, value in
                    props 
                        |> Seq.map (fun prop -> prop, row.[prop.Name]) do
                let oldValue = Reflection.getPropertyValue prop data 
                let newValue = ConvertValueBack value null
                    
                if (oldValue <> newValue) then
                    Reflection.setProperty prop data newValue

        getSimpleTable createColumns updateRow updateItem data
        
    [<System.Runtime.CompilerServices.Extension>]
    let GetWrapper (data:'a seq) (filter:Func<_,_>) = 
        getWrapper filter.Invoke data

    let updateTable (table:System.Data.Linq.Table<'T>) (wrapper:WrapperTable<'T>) = 
        let getOriginal = (fun itemData -> itemData.Original)
        let importchanges seq = 
            for orig, copy in seq |> Seq.map (fun data -> data.Original, data.Copy) do
                wrapper.ImportChangesToOriginal orig copy

        let inserts = wrapper.Inserts
        table.InsertAllOnSubmit(inserts |> Seq.map getOriginal)
        importchanges inserts

        for d in wrapper.Deletions |> Seq.map getOriginal do
            if table.GetOriginalEntityState(d) <> null then
                table.DeleteOnSubmit(d)

        importchanges wrapper.Updates

        wrapper.Invalidate()

    [<AutoOpen>]
    module WrapperTableExtensions = 
        type WrapperTable<'T when 'T : not struct and 'T : equality and 'T : null> with
            member x.UpdateTable table = x |> updateTable table

    [<System.Runtime.CompilerServices.Extension>]
    let UpdateTable (wrapper:WrapperTable<_>) table = wrapper |> updateTable table