module Transactions

open System
open System.Linq
open Microsoft.FSharp.Linq
open Microsoft.FSharp.Linq.NullableOperators
open EveAI
open EveAI.Live
open EveAI.Live.Account
open EveWarehouse.Data

let saveTransactions walletId accountKey transactions =
    let toEntity (entry:TransactionEntry) =
        new EveWarehouse.ServiceTypes.Live_Transaction(
            TransactionId = entry.TransactionID,
            Date = entry.Date,
            WalletId = walletId,
            ItemId = entry.TypeID,
            ItemName = entry.TypeName,
            StationId = entry.StationID,
            StationName = entry.StationName,
            ClientId = entry.ClientID,
            ClientName = entry.ClientName,
            Price = (decimal)entry.Price,
            Quantity = entry.Quantity,
            TransactionFor = (int)entry.TransactionFor,
            TransactionType = (int)entry.TransactionType
        )
        
    use context = EveWarehouse.GetDataContext()
    let lastDate =
        let dates = 
            context.Live_Transaction
            |> Seq.filter (fun t -> t.WalletId = walletId)
            |> Seq.map (fun t -> t.Date)
        match Seq.length dates with
        | 0 -> None
        | _ -> dates |> Seq.max |> Some
    
    transactions
    |> Seq.map toEntity
    |> Seq.filter (fun t -> lastDate.IsNone || t.Date > lastDate.Value)
    |> context.Live_Transaction.InsertAllOnSubmit

    context.DataContext.SubmitChanges()

let updateTransactions =
    use context = EveWarehouse.GetDataContext()
    
    let corporationWallets = 
        query {
            for apiKey in context.Live_ApiKey do
            where (apiKey.KeyType = (int)APIKeyInfo.APIKeyType.Corporation)
            join char in context.Live_Character on (apiKey.Id =? char.CorpApiKeyId)
            join corp in context.Live_Corporation on (char.CorporationId = corp.Id)
            join wallet in context.Live_Wallet on (corp.Id =? wallet.CorporationId)
            select (apiKey.Id, apiKey.Code, char.Id, wallet.Id, wallet.AccountKey)
        }
    for (keyId, code, charId, walletId, accountKey) in corporationWallets do
        try
            let api = new EveApi(keyId, code, charId)
            api.GetCorporationWalletTransactions(accountKey)
            |> saveTransactions walletId accountKey
            printfn "Updated corporation transactions for wallet %i" walletId
        with 
        | ex -> printfn "Failed to update corporation transactions for wallet %i" walletId

    let characterWallets =
        query {
            for apiKey in context.Live_ApiKey do
            where (apiKey.KeyType <> (int)APIKeyInfo.APIKeyType.Corporation)
            join char in context.Live_Character on (apiKey.Id =? char.ApiKeyId)
            join wallet in context.Live_Wallet on (char.Id =? wallet.CharacterId)
            select (apiKey.Id, apiKey.Code, char.Id, wallet.Id, wallet.AccountKey)
        }
    for (keyId, code, charId, walletId, accountKey) in characterWallets do
        try
            let api = new EveApi(keyId, code, charId)
            api.GetCharacterWalletTransactions()
            |> saveTransactions walletId accountKey
            printfn "Updated character transactions for wallet %i" walletId
        with
        | ex -> printfn "Failed to update character transactions for wallet %i" walletId