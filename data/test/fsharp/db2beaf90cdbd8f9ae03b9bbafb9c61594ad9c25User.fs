module Tests

open Expecto
open ExpectoFsCheck
open Feezer.Domain.User
open System
open Tests.Common
open Newtonsoft.Json
open Feezer.Domain.Protocol

[<AutoOpen>]
module Auto =
    let private config = GenEx.addToConfig FsCheckConfig.defaultConfig
    let testProp name = testPropertyWithConfig config name
    let ptestProp name = ptestPropertyWithConfig config name
    let ftestProp stdgen name = ftestPropertyWithConfig stdgen config name
    let appId = "id"
    let appSecrete = "secrete"
    let code = "code"
    let authCallbackUrl = "http://localhost:8080/auth"
    let fromJson<'a> value = JsonConvert.DeserializeObject<'a>(value)
    let downloadJsonStub json uri = async {
      return json
    }

    let getDateTimeNow () = DateTime(2017,07,26, 12, 15, 0) //26.07.2017 12:15

[<Tests>]
let tests =
  testList "Authorization" [

    testProp "stringify permissions" (fun (GenEx.ListOfAtLeast1 permissions) ->
      let composition = permissions |> List.fold (<||>) (Authorization.PermissionComposition(None))
      let expectedString = permissions |> List.map (fun item -> item.Value) |> List.toSeq
      Expect.containsAll expectedString (composition.AsQueryString.Split(',') |> Array.toSeq) ""
    )

    testCase "crete uri for authorization" <| fun _ ->
      let permissions = Authorization.Email <||> Authorization.Basic <||> Authorization.DeleteLibrary <||> Authorization.ManageLibrary <||> Authorization.OfflineAccess
      let uri = Authorization.buildLoginUri appId authCallbackUrl permissions
      let expectedUri = Authorization.deezerBaseAuthUri+"app_id="+appId+"&redirect_uri="+authCallbackUrl+"&perms="+permissions.AsQueryString
      Expect.equal expectedUri uri ""

    // testAsync "get authorize token which never expires" {
    //   let response = """
    //     {
    //       "access_token":"tokeeeen",
    //       "expires":0
    //     }
    //   """
    //   let downloadContent = downloadJsonStub response
    //   let getAccessTokeWithParams = Authorization.getAccessToken code appId appSecrete fromJson<Authorization.AuthorizationResult>
    //   let! (token, expiration) = downloadContent |> getAccessTokeWithParams getDateTimeNow
    //   Expect.equal "tokeeeen" token "token"
    //   Expect.equal Never expiration "expiration"
    // }

    // testAsync "get authorize token with expiration" {
    //   let response = """
    //     {
    //       "access_token":"tokeeeen2",
    //       "expires": 172800
    //     }
    //   """
    //   let downloadContent = downloadJsonStub response

    //   let getAccessTokeWithParams = Authorization.getAccessToken code appId appSecrete fromJson<Authorization.AuthorizationResult>
    //   let! (token, expiration) = downloadContent |> getAccessTokeWithParams getDateTimeNow
    //   let expectedDate = getDateTimeNow().AddSeconds(172800|>float)
    //   Expect.equal "tokeeeen2" token "token"
    //   match expiration with
    //   | Never -> failtest "should be exact expiration date"
    //   | Date date -> Expect.equal expectedDate date "expiration dates not matched"
    // }

  ]
