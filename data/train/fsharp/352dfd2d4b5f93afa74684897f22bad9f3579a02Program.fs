#if INTERACTIVE
#load "Critical.fs"
#endif

open System.IO
open System

open Critical

type User       = {Name:string; Age:int}

// Simulate errors in a (key, value) database. The caller can recover from some of those.
let dbQuery     = function
    | "parseError.user"     -> "parseError"
    | "notFound.user"       -> raise (FileNotFoundException())
    | "notAuthorized.user"  -> raise (UnauthorizedAccessException())
    | "unknown.user"        -> failwith "Unknown error reading the file"
    | _                     -> "FoundUser"

// Simulate errors in parsing. The caller cannot recover from any of it.
let parseUser   = function
    | "parseError"          -> failwith "Error parsing the user text"
    | u                     -> {Name = u; Age = 43}
    
// Misleadingly simple function that forces user to catch implementation related exceptions
// to figure out if a user exist. It also doesn't check emptyornull precondition.
// But overall it looks very much like standard .net code
// BTW: you cannot add an 'existUser' function because expensive
let fetchUser userName =
    let userText            = dbQuery (userName + ".user")
    let user                = parseUser(userText)
    user

// Test each of the subsequent versions of fetchuser
let test fetchUser =
    let p x                 = try printfn "%A" (fetchUser x) with ex -> printfn "%A %s" (ex.GetType()) ex.Message
    p "found"
    p "notFound"
    p "notAuthorized"
    p "parseError"
    p "unknown"
    

// Type representing the possible error condition that a caller can manage
type UserFetchError =
| UserNotFound  of exn
| NotAuthorized of int * exn // int introduced to show how to pass additional information about the error case

// 1. Changed name to tryXXX to convey that things can go wrong that might need to be recovered
// 2. Added precondition test
// 3. Signature now convey the recoverable error conditions and don't expose implementation detail
// 4. But the code is convoluted and difficult to read
// 5. Impossible to know if the programmer decided to propagate the exceptions from parseUser or just forgot to handle them
let tryFetchUser1 userName =
    if String.IsNullOrEmpty userName then invalidArg "userName" "userName cannot be null/empty"

    // Could check for file existence in this case, but often not (i.e. db)
    let userResult =    try
                            Success(dbQuery(userName + ".user"))
                        with
                        | :? FileNotFoundException as ex        -> Failure(UserNotFound ex)
                        | :? UnauthorizedAccessException as ex  -> Failure(NotAuthorized(2, ex))
                        | ex                                    -> reraise ()
    
    match userResult with
    | Success(userText) -> 
        let user        = Success(parseUser(userText))
        user
    | Failure(ex)       -> Failure(ex)

// 1. Explicitly marking each function call with contingent or throw
// 2. Using the Critical monad to avoid the second match on userResult
// 2. Most generic format, write whatever test for which exceptions to catch and whatever code to convert them to error results
// 3. But still  a bit ugly to specify, the common case could be better
let tryFetchUser2 userName =
    if String.IsNullOrEmpty userName then invalidArg "userName" "userName cannot be null/empty"

    critical {
        let! userText = contingentGen
                            (fun ex -> ex :? FileNotFoundException || ex :? UnauthorizedAccessException)
                            (fun ex ->
                                match ex with
                                       | :? FileNotFoundException       -> UserNotFound(ex)
                                       | :? UnauthorizedAccessException -> NotAuthorized(3, ex)
                                       | _ -> raise ex)
                            (fun _ -> dbQuery (userName + ".user"))
        
        return fault parseUser userText
    }


 // 1. Using a table to specify the mapping between exceptions and critical codes, more readable
 // 2. Things that I don't like, but could fix: cast to exn and need for Unauthorized function
let tryFetchUser3 userName =
    if String.IsNullOrEmpty userName then invalidArg "userName" "userName cannot be null/empty"

    critical {
        let Unauthorized (ex:exn) = NotAuthorized (ex.Message.Length, ex) // depends on ex
        let! userText = contingent1
                            [FileNotFoundException()        :> exn, UserNotFound;
                             UnauthorizedAccessException()  :> exn, Unauthorized]
                            dbQuery (userName + ".user")
        
        return fault parseUser userText
    }


let createAndReturnUser userName = critical { return {Name = userName; Age = 43}}

// 1. Shows how to manage one of the critical cases directly inside the monad, i.e. if user not found create one
// 2. Obviously UserFetchcritical should be changed to contain just NotAuthorized
let tryFetchUser4 userName =
    if String.IsNullOrEmpty userName then invalidArg "userName" "userName cannot be null/empty"

    critical {
        let Unauthorized (ex:exn) = NotAuthorized (ex.Message.Length, ex) // depends on ex
        let userFound = contingent1
                            [FileNotFoundException()        :> exn, UserNotFound;
                             UnauthorizedAccessException()  :> exn, Unauthorized]
                            dbQuery (userName + ".user")

        match userFound with
        | Success(userText)         -> return  fault parseUser userText
        | Failure(UserNotFound(_))  -> return! createAndReturnUser(userName)
        | Failure(x)                -> return! Failure(x)
    }

type GenericError = GenericError of exn

 // 1. Wrapper that prevents exceptions for escaping the method by wrapping them in a generic critical result
let tryFetchUserNoThrow userName =
    if String.IsNullOrEmpty userName then invalidArg "userName" "userName cannot be null/empty"

    critical {
        let! userText = neverThrow1 GenericError dbQuery (userName + ".user")
        
        return fault parseUser userText
    }

exception GenericException of GenericError

// 1. Cannot manage any error fetching users, so throwing if anything wrong happens
let operateOnExistingUser userName =
    let user = alwaysThrow GenericException tryFetchUserNoThrow userName
    ()
    

[<EntryPoint>]
let main args =
    0
