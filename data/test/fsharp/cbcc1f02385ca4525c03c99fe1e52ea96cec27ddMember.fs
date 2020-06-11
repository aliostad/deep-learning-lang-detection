namespace Route4MeSdk.FSharp

open System
open System.Collections.Generic
open FSharpExt
open FSharp.Data
open Newtonsoft.Json
open Newtonsoft.Json.Linq

[<CLIMutable>]
type Member = {
    [<JsonProperty("member_id")>]
    Id : int option
        
    [<JsonProperty("OWNER_MEMBER_ID")>]
    OwnerId : int option
        
    [<JsonProperty("member_type")>]
    Type : MemberType
        
    [<JsonProperty("member_first_name")>]
    FirstName : string
        
    [<JsonProperty("member_last_name")>]
    LastName : string
        
    [<JsonProperty("member_email")>]
    Email : string 
        
    [<JsonProperty("member_phone")>]
    Phone : string

    [<JsonProperty("READONLY_USER")>]
    ReadOnly : bool option

    [<JsonProperty("member_password")>]
    Password : string
        
    [<JsonProperty("date_of_birth")>]
    DateOfBirth : string //DateTime option
        
    [<JsonProperty("timezone")>]
    TimeZone : string
        
    [<JsonProperty("member_zipcode")>]
    ZipCode : string    
        
    [<JsonProperty("preferred_language")>]
    PreferedLanguage : string

    [<JsonProperty("preferred_units")>]
    PreferedUnit : DistanceUnit option

    [<JsonProperty("SHOW_ALL_DRIVERS")>]
    ShowAllDrivers : bool option
        
    [<JsonProperty("SHOW_ALL_VEHICLES")>]
    ShowAllVehicles : bool option
        
    [<JsonProperty("HIDE_ROUTED_ADDRESSES")>]
    HideRoutedAddresses : bool option
        
    [<JsonProperty("HIDE_VISITED_ADDRESSES")>]
    HideVisitedAddresses : bool option
        
    [<JsonProperty("HIDE_NONFUTURE_ROUTES")>]
    HideNonFutureAddresses : bool option }

    with
        static member Get(memberId:int, ?apiKey) =
            let query = [("member_id", memberId.ToString())]
            
            Api.Get(Url.V4.user, [], query, apiKey)
            |> Result.map(Api.Deserialize<Member>)

        static member GetAll(?apiKey) =
            Api.Get(Url.V4.user, [], [], apiKey)
            |> Result.map(fun json -> 
                let dict = Api.Deserialize<Dictionary<string,obj>>(json)
                let results = dict.["results"] :?> JArray
                let itemsJson = results.ToString()
                Api.Deserialize<Member[]>(results.ToString()))

        static member Create(member' : Member, ?apiKey) =
            Api.Post(Url.V4.user, [], [], apiKey, member')
            |> Result.map Api.Deserialize<Member>

        static member Update(member', ?apiKey) =
            member'.Id
            |> Result.ofOption(ValidationError("Member Id must be supplied."))
            |> Result.andThen(fun id ->
                Api.Put(Url.V4.user, [], [], apiKey, member')
                |> Result.map Api.Deserialize<Member>)

        member self.Update(?apiKey) =
            match apiKey with
            | None -> Member.Update(self)
            | Some ak -> Member.Update(self, ak)

        static member Delete(member', ?apiKey) =
            member'.Id
            |> Result.ofOption(ValidationError("Member Id must be supplied."))
            |> Result.andThen(fun id ->
                let request = [("member_id", id)] |> dict
                Api.Delete(Url.V4.user, [], [], apiKey, request))

        member self.Delete(?apiKey) =
            match apiKey with
            | None -> Member.Delete(self)
            | Some ak -> Member.Delete(self, ak)

        // Note: Currently returns Html response despite the format = "json"
        static member Authenticate(email, password, ?apiKey) =
            let request = 
                [("format", "json")
                 ("strEmail", email)
                 ("strPassword", password)]
                |> dict
            
            Api.Post(Url.actionAuthenticate, [], [], apiKey, request)

        member self.SetConfig (key, value, ?apiKey) = 
            self.Id
            |> Result.ofOption(ValidationError("Member Id must be supplied."))
            |> Result.andThen(fun id ->
                let config = 
                    { Id = id
                      Key = key
                      Value = value }

                Api.Put(Url.V4.configSettings, [], [], apiKey, config))

        member self.GetConfig(?apiKey) =
            self.Id
            |> Result.ofOption(ValidationError("Member Id must be supplied."))
            |> Result.andThen(fun id ->
                let query = [("member_id", id.ToString())]
            
                Api.Get(Url.V4.configSettings, [], query, apiKey)
                |> Result.map(fun json -> 
                    let dict = Api.Deserialize<Dictionary<string,obj>>(json)
                    let data = dict.["data"] :?> JArray
                    Api.Deserialize<MemberConfig[]>(data.ToString())))

        member self.DeleteConfig(key, ?apiKey) =
            self.Id
            |> Result.ofOption(ValidationError("Member Id must be supplied."))
            |> Result.andThen(fun id ->
                let query = [("member_id", id.ToString())]
                let value = [("config_key", key)] |> dict

                Api.Delete(Url.V4.configSettings, [], query, apiKey, value))

        static member Register(firstName, lastName, email, password, deviceType : DeviceType, industry, plan, ?apiKey) =
            let query = 
                [("strFirstName", firstName)
                 ("strLastName", lastName)
                 ("strEmail", email)
                 ("format", "json")
                 ("chkTerms", "1")
                 ("device_type", deviceType.ToString())
                 ("strPassword_1", password)
                 ("strPassword_2", password)
                 ("strIndustry", industry)
                 ("plan", plan)]
                |> dict

            Api.Post(Url.actionRegister, [], [], apiKey, query)

        member self.ValidateSession(sessionId, ?apiKey) =
            self.Id
            |> Result.ofOption(ValidationError("Member Id must be supplied."))
            |> Result.andThen(fun id ->
                let request = 
                    [("member_id", id.ToString())
                     ("format", "json")
                     ("session_guid", sessionId)]
                    |> dict
                Api.Post(Url.validateSession, [], [], apiKey, request))