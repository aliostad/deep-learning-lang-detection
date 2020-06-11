namespace FunEve.Contracts

open System
open FSharp.Data
open System.Net
open FunEve.Utility

module Contracts =     
    type CourierContractListing = XmlProvider<Constants.CourierContractListing>
    type ItemExchangeContractListing = XmlProvider<Constants.ItemExchangeContractListing>        
    type MixedContractListing = XmlProvider<Constants.MixedContractListing>

    type ApiContractType = 
    | Item
    | Auction
    | Courier

    type ApiContractStatus =
    | Open 
    | InProgress 
    | Completed
    | Failed 

    type ApiQueryPerson = 
    | Character
    | Corp

    type Contract = {
        Status : ApiContractStatus
        Availability : string
        IssueDate : DateTime
        CompleteDate : DateTime option
        AcceptorId : int
        ContractType : ApiContractType
    }
    
    let (|Item|Auction|Courier|) (cText:string) = 
        if cText = "ItemExchange" then Item
        else if cText = "Courier" then Courier
        else Auction
        
    let (|Open|InProgress|Completed|Failed|) (cText:string) = 
        if cText = "Open" then Open
        else if cText = "InProgress" then InProgress
        else if cText = "Completed" then Completed
        else Failed

    let matchContractType cText = 
        match cText with
        | Item -> Item
        | Auction -> Auction
        | Courier -> Courier
                
    let matchContractStatus cText = 
        match cText with
        | Open -> Open
        | InProgress -> InProgress
        | Completed -> Completed
        | Failed -> Failed
        
        

    let contractUrlBase apiPerson = 
        match apiPerson with
        | ApiQueryPerson.Character -> @"https://api.eveonline.com/char/Contracts.xml.aspx"
        | ApiQueryPerson.Corp -> @"https://api.eveonline.com/corp/Contracts.xml.aspx"
        

    let formApiUrl keyId vCode apiPerson = 
        contractUrlBase apiPerson
        |> fun url -> sprintf @"%s?keyID=%s&vCode=%s" url keyId vCode             

    let LoadContractListing keyId vCode apiPerson =                 
        formApiUrl keyId vCode apiPerson
        |> fun xmlUrl -> 
            HttpTools.loadWithEmptyResponse xmlUrl Constants.EmptyContractResult
        |> fun contents -> 
            CourierContractListing.Parse contents
        |> fun response -> 
            [
                for row in response.Result.Rowset.Rows do
                    let dateCompleted = 
                        match row.Status, row.Type with
                        | Completed, Courier -> Some row.DateCompleted
                        | Completed, Item -> Some row.DateAccepted
                        | _ -> None

                    yield {
                        Status = matchContractStatus row.Status
                        Availability = row.Availability
                        IssueDate = row.DateIssued
                        CompleteDate = dateCompleted
                        AcceptorId = row.AcceptorId
                        ContractType = matchContractType row.Type
                    }                     
            ]
        
    let LoadCorpContracts keyId vCode = 
        LoadContractListing keyId vCode Corp

    let LoadCharacterContracts keyId vCode =
        LoadContractListing keyId vCode Character