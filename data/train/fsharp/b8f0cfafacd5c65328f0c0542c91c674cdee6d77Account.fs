module Account

open System
open System.Linq
open Microsoft.FSharp.Linq.NullableOperators
open EveAI.Live
open EveAI.Live.Account
open EveAI.Live.Corporation
open EveWarehouse.Common
open EveWarehouse.Data

exception InputError of string

let getKeyInfo id code =
    try
        let api = new EveApi(id, code)
        api.getApiKeyInfo() |> succeed
    with
    | ex -> fail ex.Message

let saveApiKey id code (details: APIKeyInfo) =
    use context = EveWarehouse.GetDataContext()
    
    match context.Live_ApiKey |> Seq.tryFind (fun x -> x.Id = id) with
    | Some key ->
        key.AccessMask <- details.AccessMask
        key.Expires <- Nullable(details.Expires)
        key.KeyType <- (int)details.KeyType
    | None ->
        new EveWarehouse.ServiceTypes.Live_ApiKey(
            Id = id,
            Code = code,
            AccessMask = details.AccessMask,
            Expires = Nullable(details.Expires),
            KeyType = (int)details.KeyType
        )
        |> context.Live_ApiKey.InsertOnSubmit
    
    context.DataContext.SubmitChanges()

//let upsert (table: Linq.Table<'A>) seq mapId insert update = 
//    let ids = seq |> Seq.map fst |> Seq.toArray
//    let entityMap =
//        table
//        |> Seq.filter (fun x -> Seq.exists ((=) (mapId x)) ids)
//        |> Seq.map (fun x -> (mapId x, x))
//        |> Map.ofSeq
//
//    let updateOrInsert x =
//        let id = fst x
//        match entityMap.TryFind id with
//        | Some ent -> update x ent
//        | None -> insert x |> table.InsertOnSubmit
//
//    seq |> Seq.iter updateOrInsert

let updateCharactersAndCorporations keyId code (details: APIKeyInfo) =
    use context = EveWarehouse.GetDataContext()

    let api = new EveApi(keyId, code)
    let entries = api.GetAccountEntries()

    let corpIds = entries |> Seq.map (fun e -> e.CorporationID) |> Seq.distinct |> Seq.toArray
    let charIds = entries |> Seq.map (fun e -> e.CharacterID) |> Seq.distinct |> Seq.toArray

    let existingCorps = 
        context.Live_Corporation
        |> Seq.filter (fun x -> Seq.exists ((=) x.Id) corpIds)
        |> Seq.map (fun x -> (x.Id, x))
        |> Map.ofSeq

    let existingChars = 
        context.Live_Character
        |> Seq.filter (fun x -> Seq.exists ((=) x.Id) charIds)
        |> Seq.map (fun x -> (x.Id, x))
        |> Map.ofSeq

    let updateOrInsertCorp (id, name) =
        match existingCorps.TryFind id with
        | Some entity ->
            entity.Name <- name
        | None ->
            new EveWarehouse.ServiceTypes.Live_Corporation(Id = id, Name = name, ApiKeyId = keyId)
            |> context.Live_Corporation.InsertOnSubmit
    
    let updateOrInsertChar (id, name, corpId) =
        let entity = 
            match existingChars.TryFind id with
            | Some entity ->
                entity.Name <- name
                entity.CorporationId <- corpId
                entity
            | None ->
                let entity = new EveWarehouse.ServiceTypes.Live_Character(Id = id, Name = name, CorporationId = corpId)
                context.Live_Character.InsertOnSubmit(entity)
                entity
        match details.KeyType with
        | APIKeyInfo.APIKeyType.Corporation -> 
            entity.CorpApiKeyId <- Nullable(keyId)
        | APIKeyInfo.APIKeyType.Character
        | APIKeyInfo.APIKeyType.Account ->
            entity.ApiKeyId <- Nullable(keyId)
        | _ -> raise (InputError "Invalid key type")

    entries 
    |> Seq.map (fun x -> (x.CorporationID, x.CorporationName))
    |> Seq.distinct
    |> Seq.iter updateOrInsertCorp

//    let corps = entries |> Seq.map (fun x -> (x.CorporationID, x.CorporationName))
//    let mapId (x:EveWarehouse.ServiceTypes.Live_Corporation) = x.Id
//    let insert (id, name) = new EveWarehouse.ServiceTypes.Live_Corporation(Id = id, Name = name, ApiKeyId = keyId)
//    let update (id, name) (x:EveWarehouse.ServiceTypes.Live_Corporation) = x.Name <- name
//    upsert context.Live_Corporation corps mapId insert update

    entries 
    |> Seq.map (fun x -> (x.CharacterID, x.Name, x.CorporationID))
    |> Seq.distinct
    |> Seq.iter updateOrInsertChar

    try
        context.DataContext.SubmitChanges() |> succeed
    with
    | ex -> fail ex.Message

let updateCharacterWallet keyId code characterId =
    use context = EveWarehouse.GetDataContext()
    let api = new EveApi(keyId, code, characterId)
    
    let accounts = api.GetCharacterAccountBalance()
    
    let upsert (item: AccountBalance) (entity: Option<EveWarehouse.ServiceTypes.Live_Wallet>) =
        match entity with
        | Some e ->
            e.Balance <- item.Balance
        | None ->
            let character =
                context.Live_Character
                |> Seq.find (fun e -> e.Id = characterId)
                
            new EveWarehouse.ServiceTypes.Live_Wallet(
                Id = item.AccountID,
                AccountKey = item.AccountKey,
                Balance = item.Balance,
                Description = character.Name,
                CharacterId = Nullable(character.Id)
            )
            |> context.Live_Wallet.InsertOnSubmit
            
    accounts
    |> Seq.map (fun x -> x, context.Live_Wallet |> Seq.tryFind (fun e -> e.Id = x.AccountID))
    |> Seq.iter (fun (x, e) -> upsert x e)
    
    context.DataContext.SubmitChanges()
    sprintf "Updated wallet for character %i" characterId

let updateCorporationWallets keyId code characterId corporationId =
    use context = EveWarehouse.GetDataContext()
    let api = new EveApi(keyId, code, characterId)
    
    let upsert (item:AccountBalance) (entity: Option<EveWarehouse.ServiceTypes.Live_Wallet>) =
        match entity with
        | Some e ->
            e.Balance <- item.Balance
        | None ->
            new EveWarehouse.ServiceTypes.Live_Wallet(
                Id = item.AccountID,
                AccountKey = item.AccountKey,
                Balance = item.Balance,
                Description = "",
                CorporationId = Nullable(corporationId)
            )
            |> context.Live_Wallet.InsertOnSubmit
    
    api.GetCorporationAccountBalance()
    |> Seq.map (fun x -> x, context.Live_Wallet |> Seq.tryFind (fun e -> e.Id = x.AccountID))
    |> Seq.iter (fun (x, e) -> upsert x e)
    
    context.DataContext.SubmitChanges()
    sprintf "Updated wallets for corporation %i" corporationId

let addApiKey keyId code =
    getKeyInfo keyId code 
    >>= tryCatch (tee (saveApiKey keyId code))
    >>= updateCharactersAndCorporations keyId code
    |> printfn "%A"
    
let updateCharactersWallet = 
    use context = EveWarehouse.GetDataContext()
    
    query {
        for key in context.Live_ApiKey do
        where (key.KeyType <> (int)APIKeyInfo.APIKeyType.Corporation)
        join char in context.Live_Character on (key.Id =? char.ApiKeyId)
        select (key.Id, key.Code, char.Id)
    }
    |> Seq.map (tryCatch (fun (id, code, charId) -> updateCharacterWallet id code charId))
    |> Seq.iter (printfn "%A")
    
let updateCorporationsWallets =
    use context = EveWarehouse.GetDataContext()
    query {
        for apiKey in context.Live_ApiKey do
        where (apiKey.KeyType = (int)APIKeyInfo.APIKeyType.Corporation)
        join char in context.Live_Character on (apiKey.Id =? char.CorpApiKeyId)
        join corp in context.Live_Corporation on (char.CorporationId = corp.Id)
        select (apiKey.Id, apiKey.Code, char.Id, corp.Id)
    }
    |> Seq.map (tryCatch (fun (id, code, charId, corpId) -> updateCorporationWallets id code charId corpId))
    |> Seq.iter (printfn "%A")

