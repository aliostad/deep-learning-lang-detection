namespace Feezer.Domain.User

module Authorization =
    open System

    type Permission =
        | Basic
        | Email
        | OfflineAccess
        | ManageLibrary
        | ManageCommunity
        | DeleteLibrary
        | ListeningHistory
        with
        member x.Value =
             match x with
             | Basic -> "basic_access"
             | Email -> "email"
             | OfflineAccess -> "offline_access"
             | ManageLibrary -> "manage_library"
             | ManageCommunity -> "manage_community"
             | DeleteLibrary -> "delete_library"
             | ListeningHistory -> "listening_history"
        static member inline (<||>) (perm1, perm2) =
            let composition = PermissionComposition(Some perm1)
            composition.Compose perm2

    and PermissionComposition(permission:Permission option) =
        let mutable permissions:Permission list =
            match permission with
            | None -> []
            | Some p -> [p]

        let rec toQueryString str perm =
            match perm with
                | []->str
                | [item:Permission]-> str+item.Value
                | head::tail-> toQueryString (str+head.Value+",") tail
        new() = PermissionComposition(None)

        with
            member x.Compose permission =
                if (permissions |> List.contains permission)
                then x
                else permissions <- permission::permissions
                     x
            member x.AsQueryString = toQueryString "" permissions
            member x.Items with get() = permissions
            static member inline (<||>) (x:PermissionComposition, perm:Permission) = x.Compose perm
    let deezerBaseAuthUri = "https://connect.deezer.com/oauth/auth.php?"

    let deezerBaseTokenUri = "https://connect.deezer.com/oauth/access_token.php?"

    let authCodeParamName = "code"

    let buildLoginUri appId redirectUri (permissions:PermissionComposition) =
        deezerBaseAuthUri+"app_id="+appId+"&redirect_uri="+redirectUri+"&perms="+permissions.AsQueryString

    let buildTokenUri appId appSecret code =
        deezerBaseTokenUri+"app_id="+appId+"&secret="+appSecret+"&code="+code+"&output=json"