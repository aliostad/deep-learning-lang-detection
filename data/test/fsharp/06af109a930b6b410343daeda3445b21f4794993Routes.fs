module Nikeza.Server.Routes

open Microsoft.AspNetCore.Http
open Giraffe.HttpContextExtensions
open Giraffe.HttpHandlers
open Nikeza.Server.Authentication

let authScheme = "Cookie"
let private registrationHandler = 
    fun(context: HttpContext) -> 
        async {
            let! data = context.BindJson<RegistrationRequest>()
            match register data with
              | Success profile -> return! json profile context
              | Failure         -> return! (setStatusCode 400 >=> json "registration failed") context
        }

let private loginHandler  (authFailedHandler : HttpHandler) = 
    fun(context: HttpContext) -> 
        async {
            let! data = context.BindJson<LogInRequest>()
            if  authenticate data.UserName data.Password
                then let user = getUserClaims data.UserName authScheme
                     do! context.Authentication.SignInAsync(authScheme, user) |> Async.AwaitTask 
                     return Some context 
                else return! authFailedHandler context                                                           
        }

open Nikeza.Server.Model
open Nikeza.Server.Command
open Nikeza.Server.Store

let private followHandler = 
    fun(context: HttpContext) -> 
        async { let! data = context.BindJson<FollowRequest>()
                ignore (execute <| Follow data)
                return Some context
        } 

let private unsubscribeHandler = 
    fun(context: HttpContext) -> 
        async { let! data = context.BindJson<UnsubscribeRequest>()
                ignore (execute <| Unsubscribe data)
                return Some context                  
        } 

let private featureLinkHandler = 
    fun(context: HttpContext) -> 
        async { let! data = context.BindJson<FeatureLinkRequest>()
                ignore (execute <| FeatureLink data)
                return Some context
        }

let private updateProfileHandler = 
    fun(context: HttpContext) -> 
        async { let! data = context.BindJson<ProfileRequest>()
                ignore (execute <| UpdateProfile data)
                return Some context
        }

let private addSourceHandler = 
    fun(context: HttpContext) -> 
        async { let! data = context.BindJson<AddSourceRequest>()
                ignore (execute <| AddSource data)
                return Some context
        }

let private removeSourceHandler = 
    fun(context: HttpContext) -> 
        async { let! data = context.BindJson<RemoveSourceRequest>()
                ignore (execute <| RemoveSource data)
                return Some context
        }

let private addLinkHandler = 
    fun(context: HttpContext) -> 
        async { let! data = context.BindJson<AddLinkRequest>()
                ignore (execute <| AddLink data)
                return Some context
        }

let private removeLinkHandler = 
    fun(context: HttpContext) -> 
        async { let! data = context.BindJson<RemoveLinkRequest>()
                ignore (execute <| RemoveLink data)
                return Some context
        }

let private setCode (handler:HttpHandler)= 
    fun(context: HttpContext) ->     
        let response =
             if context.Response.Body.ToString() = ""
                then setStatusCode 401
                else handler
        response context

open Nikeza.Server.YouTube
open Nikeza.Server.YouTube.Authentication
open Nikeza.Server.Wordpress

let private fetchYoutube (apiKey, channelId) (context : HttpContext) = 
    async { let  youtube = youTubeService apiKey
            let! videos =  uploadList youtube <| ChannelId channelId
            return! json videos context
    }

let private fetchWordpress (feedUrl) (context : HttpContext) =
    async { let! response = jsonRssFeed feedUrl
            return! json response context
    }

let private fetchProviders =  json <| getProviders()

let private fetchPlatforms  = json <| getPlatforms()

let private fetchLinks (providerId) (context : HttpContext) =
    let response = getLinks providerId
    json response context
    
let private fetchFollowers (providerId) (context : HttpContext) =
    let response = getFollowers providerId
    json response context
    
let private fetchSubscriptions (providerId) (context : HttpContext) =
        let response = getSubscriptions providerId
        json response context

let private fetchSources (providerId) (context : HttpContext) =
    let response = getSources providerId
    json response context
    
let private fetchContentTypeToId (contentType) (context : HttpContext) =
    let response = contentTypeToId contentType
    json response context
         
let webApp : HttpContext -> HttpHandlerResult = 

    choose [
        GET >=>
            choose [
                //route "/" >=> htmlFile "/hostingstart.html"
                route  "/"              >=>  htmlFile "/home.html"
                route  "/options"       >=>  setHttpHeader "Allow" "GET, OPTIONS, POST" // CORS support
                route  "/platforms"     >=>  fetchPlatforms
                route  "/providers"     >=>  fetchProviders
                routef "/youtube/%s/%s"      fetchYoutube
                routef "/wordpress/%s"       fetchWordpress
                routef "/links/%s"           fetchLinks
                routef "/followers/%s"       fetchFollowers
                routef "/subscriptions/%s"   fetchSubscriptions
                routef "/sources/%s"         fetchSources
                routef "/contenttypetoid/%s" fetchContentTypeToId
            ]
        POST >=> 
            choose [
                route "/register"      >=> registrationHandler
                route "/login"         >=> loginHandler (setStatusCode 401 >=> text "invalid credentials")
                route "/logout"        >=> signOff authScheme >=> text "logged out"
                route "/follow"        >=> followHandler
                route "/unsubscribe"   >=> unsubscribeHandler
                route "/featurelink"   >=> featureLinkHandler
                route "/updateprofile" >=> updateProfileHandler
                route "/addsource"     >=> addSourceHandler
                route "/removesource"  >=> removeSourceHandler
                route "/addLink"       >=> addLinkHandler
                route "/removeLink"    >=> removeLinkHandler
            ]
            
        setStatusCode 404 >=> text "Not Found" ]