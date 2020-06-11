module Feezer.Server.ActorModel.UserActor

open Proto
open Proto.Router
open Feezer.Server.ActorModel.FSharpApi
open Feezer.Domain
open Feezer.Domain.User
module Api = Feezer.Domain.DeezerApi
open Feezer.Server.Utils
open Feezer.Server.Config
open System

type AuthFlowMsg =
  | StartAuthFlow
  | CodeCallbackReceived of code:string

type Message =
  | Client of Protocol.Client
  | AuthFlow of AuthFlowMsg



let private handler config (mailbox:Actor<IContext, Message>) =

  let rec anonymous () = actor {
      let! (ctx,msg) = mailbox.Receive()

      match msg with
      | Client clientMsg ->
            match clientMsg with
            | Protocol.Authorize -> ctx.Self <!! AuthFlow(StartAuthFlow)
            | Protocol.GetUser -> Protocol.Server.CurrentUser(Anonymous) |> ConnectionActor.sendMessage

      | AuthFlow flow ->
          match flow with
          | StartAuthFlow ->
              let permissions = Authorization.Email <||> Authorization.Basic <||> Authorization.DeleteLibrary <||> Authorization.ManageLibrary <||> Authorization.OfflineAccess
              let uri = Authorization.buildLoginUri config.DeezerAppId "http://localhost:8080/auth" permissions
              ConnectionActor.sendMessage <| Protocol.Authorization(uri)

          | CodeCallbackReceived code ->
              async {
                  let tokenUri = Authorization.buildTokenUri config.DeezerAppId config.DeezerAppSecret code
                  let httpActor = HttpActor.createFromContext ctx
                  let! hr = httpActor <?? HttpActor.GET(tokenUri)
                  match hr with
                  | HttpActor.Success (_,result) ->
                      let result = fromJson<Api.User.AuthorizationResultJson> result
                      let expiration =
                        match result.expires with
                        | 0 -> Protocol.Never
                        | seconds -> Protocol.Date(DateTime.Now.AddSeconds(seconds|>float))
                      //TODO save token and expiration date in DB
                      Api.setToken result.access_token
                  | _ -> () //TODO handle errors
              } |> Async.RunSynchronously |> ignore
              ctx.Self <!! Client(Protocol.GetUser)
              return! authorized Anonymous

      return! anonymous()
    }

  and authorized (user:User) =
      actor {
          let! (ctx, msg) = mailbox.Receive()
          match msg with
          | Client clientMsg ->
              match clientMsg with
              | Protocol.GetUser ->
                  let currentUser =
                      match user with
                      | Authorized _ -> user
                      | Anonymous ->
                          async {
                             let httpActor = HttpActor.createFromContext ctx
                             let! httpResponse = httpActor <?? HttpActor.GET(Api.User.me())
                             match httpResponse with
                             | HttpActor.Success (uri, userJson) ->
                                  let userInfo = fromJson<Api.User.UserJson> userJson
                                  let currentUser = Authorized({id=1; name=userInfo.name; avatar=userInfo.picture_big})
                                  return currentUser
                             | HttpActor.Error _ -> return Anonymous
                          } |> Async.RunSynchronously
                  ConnectionActor.sendMessage <| Protocol.Server.CurrentUser(currentUser)
                  return! authorized currentUser
              | Protocol.Authorize -> return! authorized user
          | _ -> ()

          return! authorized user
      }

  anonymous()

let create (config:AppConfig) = handler config |> props