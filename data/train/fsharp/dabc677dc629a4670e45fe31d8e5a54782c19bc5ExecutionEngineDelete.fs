namespace ExecutionEngine
module Delete =

    open System.IO
    open System
    open databaseStructure.databaseStructure
    open ReturnControl.Main



    // Copies a linked list of cell nodes onto another linked list, pointed to by the provided pointer
    let rec copyBox box tranBox prevTran =
        match !box with
        | INilBox -> ()
        | BoxNode (value, colName, prev, next) ->
            let nextTran = ref INilBox
            tranBox := BoxNode (value, colName, prevTran, nextTran)
            copyBox next nextTran tranBox

    // Copies a linked list of row nodes onto another linked list, pointed to by the provided pointer
    let rec copyRow row (tranRow : table) =
        match !row with
        | INilRow -> ()
        | RowNode (vals, last) ->
            let rowHead = ref INilBox
            let rowCopy = ref INilBox
            copyBox vals rowCopy rowHead
            let nextTran = ref INilRow
            tranRow := RowNode (rowCopy, nextTran)
            copyRow last nextTran

    // Copies a linked list of table nodes onto another linked list, pointed to by the provided pointer     
    let copyTable db tranTable =
        match !db with
        | INilTable -> ()
        | TableNode (thisTable, tabName, cols, _) ->
            let rowHead = ref INilRow
            copyRow thisTable rowHead
            let nextTable = ref INilTable
            tranTable := TableNode (rowHead, tabName, cols, nextTable)

    // Used to "delete" entire tables. This is done by copying over the tables not on the list for deletion, 
    // but skipping the tables on the list for deletion
    let rec deleteTablesRec deleteList db (transTable : tableList ref)=
        match deleteList, !db with
        | [], INilTable -> Result () // Finished list for deletion and the database
        | [], TableNode (_, _, _, tableTail) -> // Finished list for deletion so will copy table over
            copyTable db transTable
            match !transTable with
            | INilTable -> Error "DELETE: Table unsuccessfully copied"
            | TableNode (_, _, _, nextTable) ->
                deleteTablesRec deleteList tableTail nextTable
        | t1 :: tTail, INilTable -> Error ("DELETE: '" + t1 + "' specified for deletion but not found.") // Finished database but not list for deletion
        | t1 :: tTail, TableNode (thisTable, tabName, cols, tableTail) when tabName = t1 -> // Found a table to delete
            deleteTablesRec tTail tableTail transTable
        | _, TableNode (thisTable, tabName, cols, tableTail) -> // This table should not be deleted so will copy it over
            copyTable db transTable
            match !transTable with
            | INilTable -> Error "DELETE: Table unsuccessfully copied"
            | TableNode (_, _, _, nextTable) ->
                deleteTablesRec deleteList tableTail nextTable
                
    // "deletes" certain rows from a table by only copying over the other rows. The rows to be deleted are specified by
    // the testfunction.
    let rec deleteCertainRows (thisTable : table) testFunction transTable =
        match !thisTable with
        | INilRow -> Result ()
        | RowNode (values, nextRow) ->
            let rowMap = transformRowMap values
            match testFunction rowMap with
            | Error e -> Error e
            | Result b when b = true -> deleteCertainRows nextRow testFunction transTable
            | Result _ -> 
                let boxHead = ref INilBox
                let beforeHead = ref INilBox
                copyBox values boxHead beforeHead
                let newRow = ref INilRow
                transTable := RowNode (boxHead, newRow)
                deleteCertainRows nextRow testFunction newRow

    // Used to delete certain rows from certain tables. Done by calling deleteCertainRows on tables specified in the deleteList,
    // and copying over the entire table if they are not in said list.
    let rec deleteRowsRec deleteList testFunction db transTable =
        match deleteList, !db with
        | [], INilTable -> Result()
        | [], TableNode (thisTable, tabName, cols, tableTail) ->
            copyTable db transTable
            match !transTable with
            | INilTable -> Error "DELETE: Table unsuccessfully copied"
            | TableNode (_, _, _, nextTable) ->
                deleteRowsRec deleteList testFunction tableTail nextTable
        | t1 :: tTail, INilTable -> Error ("DELETE: '" + t1 + "' specified for deletion but not found.")
        | t1 :: tTail, TableNode (thisTable, tabName, cols, tableTail) when tabName = t1 ->
            let rowHead = ref INilRow
            match deleteCertainRows thisTable testFunction rowHead with
            | Error e -> Error e
            | Result _ ->
                let nextTable = ref INilTable
                transTable := TableNode(rowHead, tabName, cols, nextTable)
                deleteRowsRec tTail testFunction tableTail nextTable
        | t1 :: tTail, TableNode (thisTable, tabName, cols, tableTail) ->
            copyTable db transTable
            match !transTable with
            | INilTable -> Error "DELETE: Table unsuccessfully copied"
            | TableNode (_, _, _, nextTable) ->
                deleteRowsRec deleteList testFunction tableTail nextTable

    // Function called by execution engine parser to implement deleting either entire tables or certain rows in certain tables in a database
    let delete (deleteList : string list) (testFunctionOption : (Map<string,boxData> -> ReturnCode<bool>) option) (db : database) : ReturnCode<unit> =
        let head = ref INilTable
        match testFunctionOption with
        | None -> 
            match deleteTablesRec deleteList db head with // Delete whole tables as no function was given do decide what rows should be deleted
            | Error e -> Error e // If an error occurs then return error, and the original database remains unchanged
            | Result _ ->  // If the deletion is successfull then move the database pointer to point to the new database
                db := !head 
                Result ()
        | Some testFunction -> // Delete certain rows, as specified by the testing function
            match deleteRowsRec deleteList testFunction db head with
            | Error e -> Error e // If an error occurs then return error, and the original database remains unchanged
            | Result _ -> // If the deletion is successfull then move the database pointer to point to the new database
                db := !head
                Result ()