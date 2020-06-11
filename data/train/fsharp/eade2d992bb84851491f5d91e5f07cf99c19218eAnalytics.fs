namespace Website

open Shared
open System.Data.SqlClient
open System.Data
open System.Runtime.Caching

type AnalyticsData = {
    IsMobile: bool
    User1: string
    User2: string
    CreationDate: System.DateTimeOffset
    Login: string option
    Tweet: string option
}

module Analytics =
    let pushAt = 100
    let resetAt = 50
    let mutable isPushAvailable = true
    let analyticsQueue = System.Collections.Concurrent.ConcurrentQueue<AnalyticsData>()
    let viewQueue = System.Collections.Concurrent.ConcurrentQueue<string*System.DateTimeOffset>()

    let analyticsPush =
        async {
            use table = new System.Data.DataTable() 
            table.Columns.Add(new System.Data.DataColumn("IsMobile",typeof<bool>,AllowDBNull=false))
            table.Columns.Add(new System.Data.DataColumn("User1",typeof<string>,AllowDBNull=false))
            table.Columns.Add(new System.Data.DataColumn("User2",typeof<string>,AllowDBNull=false))
            table.Columns.Add(new System.Data.DataColumn("CreationDate",typeof<System.DateTimeOffset>,AllowDBNull=false))
            table.Columns.Add(new System.Data.DataColumn("Login",typeof<string>,AllowDBNull=true))
            table.Columns.Add(new System.Data.DataColumn("Tweet",typeof<string>,AllowDBNull=true))
            while not analyticsQueue.IsEmpty do
                let mutable tempItem = {IsMobile = false; User1 = ""; User2 = ""; CreationDate = System.DateTimeOffset.MinValue; Login = None; Tweet = None}
                if analyticsQueue.TryDequeue(&tempItem) then
                    let row = table.NewRow()
                    row.["IsMobile"] <- tempItem.IsMobile
                    row.["User1"] <- tempItem.User1
                    row.["User2"] <- tempItem.User2
                    row.["CreationDate"] <- tempItem.CreationDate
                    match tempItem.Login with
                    | Some l -> row.["Login"] <- l
                    | None -> row.["Login"] <- System.DBNull.Value
                    match tempItem.Tweet with
                    | Some l -> row.["Tweet"] <- l
                    | None -> row.["Tweet"] <- System.DBNull.Value
                    table.Rows.Add(row)

            use connection = createSqlConnection()
            let bulkCopy = new System.Data.SqlClient.SqlBulkCopy(connection,BulkCopyTimeout = 0, DestinationTableName = "AnalyticsLog")

            seq {for c in table.Columns -> c.ColumnName}
            |> Seq.iter (fun cn -> bulkCopy.ColumnMappings.Add(cn,cn) |> ignore)
            
            connection.Open()
            bulkCopy.WriteToServer(table)
            connection.Close()
            connection.Dispose()
            return ()
        }

    let writeAnalytics (data: AnalyticsData) = 
        async {
            if analyticsQueue.Count <= resetAt then
                isPushAvailable <- true
            analyticsQueue.Enqueue(data)
            if isPushAvailable && analyticsQueue.Count >= pushAt then
                isPushAvailable <- false
                Async.Start analyticsPush
            return ()
            }
            

    let viewPush =
        async {
            use table = new System.Data.DataTable() 
            table.Columns.Add(new System.Data.DataColumn("ViewDate",typeof<System.DateTimeOffset>,AllowDBNull=false))
            table.Columns.Add(new System.Data.DataColumn("Login",typeof<string>,AllowDBNull=false))
            while not viewQueue.IsEmpty do
                let mutable tempItem = ("",System.DateTimeOffset.MinValue)
                if viewQueue.TryDequeue(&tempItem) then
                    let row = table.NewRow()
                    row.["Login"] <- fst tempItem
                    row.["ViewDate"] <- snd tempItem
                    table.Rows.Add(row)

            use connection = createSqlConnection()
            let bulkCopy = new System.Data.SqlClient.SqlBulkCopy(connection,BulkCopyTimeout = 0, DestinationTableName = "ViewLog")

            seq {for c in table.Columns -> c.ColumnName}
            |> Seq.iter (fun cn -> bulkCopy.ColumnMappings.Add(cn,cn) |> ignore)
            
            connection.Open()
            bulkCopy.WriteToServer(table)
            connection.Close()
            connection.Dispose()
            return ()
        }

    let writeView (login: string) (viewDate:System.DateTimeOffset) = 
        async {
            if viewQueue.Count <= resetAt then
                isPushAvailable <- true
            viewQueue.Enqueue((login,viewDate))
            if isPushAvailable && viewQueue.Count >= pushAt then
                isPushAvailable <- false
                Async.Start viewPush
            return ()
            }