// Copyright (c) Wireclub Media Inc. All Rights Reserved. See License.md in the project root for license information.

module Settings

open System
open Wireclub.Models
open Wireclub.Boundary.Models
open Wireclub.Boundary.Settings

let avatar data =
    Api.upload<Image> "settings/doAvatar" "avatar" "avatar.jpg" data
    
let profile () =
    Api.req<ProfileFormData> "api/settings/profile" "get" []

let updateProfile username (gender:GenderType) (birthday:DateTime) country region city bio =
    Api.req<User> "api/settings/profile" "post" 
        [
            "userId", Api.userId
            "username", username
            "gender", string gender
            "birthday-year", string birthday.Year
            "birthday-month", string birthday.Month
            "birthday-day", string birthday.Day
            "bio", bio
            "country", country
            "region", region
            "city", city
        ]

let countries () =
    Api.req<LocationCountry[]> "api/settings/countries" "post" []

let regions country =
    Api.req<LocationRegion[]> "api/settings/regions" "post" [ "country", country ]
    
let email email confirmation password =
    Api.req<EmailFormData> "settings/doEmail" "post" [ "email", email; "confirmation", confirmation; "password", password ]

let password currentPassword password confirmation =
    Api.req<PasswordChangeFormData> "settings/doPassword" "post" [ "currentPassword", currentPassword; "password", password; "confirmation", confirmation ]

let notifications () =
    Api.req<NotificationsFormData> "api/settings/notifications" "get" []

let suppressNotifications (notifications:string list) =
    Api.req<NotificationsFormData> "settings/notifications" "post" (( "status", "true" ) :: (notifications |> List.map (fun notification -> "notifications", notification)))

let chat () =
    Api.req<ChatOptionsFormData> "api/settings/chat" "get" []

let updateChat (font:int) (color:int) (sounds:bool) (joinLeave:int) =
    Api.req<ChatOptionsFormData> "chat/options" "post" [ "font", string font ; "colorId", string color ; "playSounds", string sounds ; "joinLeaveMessages", string joinLeave ; ]

let privacy () =
    Api.req<PrivacyFormData> "api/settings/privacy" "get" []

let updatePrivacy contact privateChat viewProfile viewBlog viewPictures viewConversations commentProfile commentBlock gameChallenge (optOut:bool) =
    let relToString (rel:RelationshipRequiredType) = rel |> int |> string 
    Api.req<PrivacyFormData>
        "settings/doPrivacy"
        "post"
        [
            "requiredRelationshipToContact", relToString contact
            "requiredRelationshipToPrivateChat", relToString privateChat
            "requiredRelationshipToViewProfile", relToString viewProfile
            "requiredRelationshipToViewBlog", relToString viewBlog
            "requiredRelationshipToViewPictures", relToString viewPictures
            "requiredRelationshipToViewConversations", relToString viewConversations
            "requiredRelationshipToCommentOnProfile", relToString commentProfile
            "requiredRelationshipToCommentOnBlog", relToString commentBlock
            "requiredRelationshipToGameChallenge", relToString gameChallenge
            "optOutFromRatePictures", string optOut
        ]

let messaging () =
    Api.req<MessagingFormData> "api/settings/messaging" "get" []
    
let updateMessaging (picture:bool) (profile:bool) (verifiedEmail:bool) =
    Api.req<MessagingFormData> "settings/doMessaging" "post" [ "blockWithoutPicture", string picture; "blockWithoutProfile", string profile; "blockWithoutVerifiedEmail", string verifiedEmail ]

let blocked () =
    Api.req<BlockedFormData> "api/settings/blocked" "get" []

let unblock (ids:string list) =
    Api.req<BlockedFormData> "api/settings/unblock" "post"  (ids |> List.map (fun notification -> "ids", notification))

let updateContentOptions (showRatedR:bool) =
    Api.req<obj> "/chat/doContentRatingOptions" "post"  [ "showRatingR", string showRatedR ]

let registerDevice pushToken = async {
    let! resp = Api.req<string> "/api/settings/registerDevice" "post" [ "pushToken", pushToken ]
    return
        match resp with
        | Api.ApiOk result -> Api.ApiOk (result.Trim [|'"'|])
        | resp -> resp
}

let updateDevicePushToken deviceId token =
    Api.req<unit> "/api/settings/updateDevicePushToken" "post" [ "deviceId", deviceId; "token", token ]

let deleteDevice deviceId =
    Api.req<unit> "/api/settings/deleteDevice" "post" [ "deviceId", deviceId ]
