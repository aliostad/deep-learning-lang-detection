namespace XLCatlin.DataLab.XCBRA.ApiAuth

open XLCatlin.DataLab.XCBRA.DomainModel
open WebUtilities

module WebParts =
    open Suave                 // always open suave
    open Suave.Operators       // for >=>

    type AuthError =
        | AuthHeaderMissing
        | AuthHeaderBadFormat


    let toApiAuthorization (s:string) = 
        s.Split(' ') 
        |> Array.map (fun s -> s.Trim())
        |> function
            | [|key;user;authToken|] when key = ApiAuthorization.Domain ->
                //TODO: decrypt the authToken
                Ok {ApiAuthorization.Username=Username user; AuthToken=authToken}
            | _ -> 
                Error AuthHeaderBadFormat


    let apiAuthorization =
        request (fun r _ ->
            tryGetHeader r "Authorization"
            |> Option.map toApiAuthorization 
            |> ifNone (Error AuthHeaderMissing)
            )


    let emptyAuthorization = {
        ApiAuthorization.Username = Username ""
        ApiAuthorization.AuthToken = ""
        }

    /// Authenticate the protectedPart
    let authenticate (protectedPart:WebPart) : WebPart =
        //TODO: implement authentication
        protectedPart

    /// Authorize the protectedPart
    let authorize (protectedPart:WebPart) : WebPart =
        //TODO: implement authorization
        protectedPart
