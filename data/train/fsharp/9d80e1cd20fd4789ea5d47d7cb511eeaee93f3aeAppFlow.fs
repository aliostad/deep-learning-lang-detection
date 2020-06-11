namespace Trustpilot.FSharp

module AppFlow =
    open System

    type ApiResponseError<'a> =
        | ApiException of Exception * string
        | ApiError of 'a

    type StorageError<'a> =
        | StorageException of Exception * string
        | StorageError of 'a

    type StoreFlow<'a, 'e> = Flow<'a, StorageError<'e>>

    type ApiFlow<'a, 'e> = Flow<'a, ApiResponseError<'e>>

    type AppError<'a> =
        | StoreError of Exception * string
        | RequestError of Exception * string
        | UnhandledError of Exception
        | BusinessError of 'a

    type AppFlow<'a, 'e> = Flow<'a, AppError<'e>>
    
    
    module AppError =  
        let fromStorageError =
            function
            | StorageException (ex, msg) -> StoreError (ex, msg)
            | StorageError error -> BusinessError <| error

        let fromApiError  =
            function
            | ApiException (ex, msg) -> RequestError (ex, msg)
            | ApiError error ->  BusinessError <| error

        let map (f : 'a -> 'b) : AppError<'a> -> AppError<'b>  = 
            function
            | BusinessError a    -> BusinessError <| f a
            | StoreError (e,s)   -> StoreError (e,s)
            | RequestError (e,s) -> RequestError (e,s)
            | UnhandledError e   -> UnhandledError e

    let mapFailure (f : 'a -> 'b)  (ma : AppFlow<_,'a>) : AppFlow<_,'b> =
        Flow.mapFailure (AppError.map f) ma

    let resolveUnitError (ma : AppFlow<'a,unit>) : AppFlow<'a,'b> =
        async {
            let! a = ma
            match a with
            | Success s -> return Success s
            | Failure (BusinessError ()) -> return Failure    <| UnhandledError (System.Exception("flow was set to have no business errors, 
                                                                                                   but still has an business error, 
                                                                                                   will stop gracefully"))
            | Failure (UnhandledError ex) -> return Failure   <| UnhandledError ex
            | Failure (StoreError (m,ex)) -> return Failure   <| StoreError (m,ex)
            | Failure (RequestError (m,ex)) -> return Failure <| RequestError (m,ex)
        }

    let fromApiFlow (ma : ApiFlow<'a,'b>) : AppFlow<'a,'b> =
        async {
            let! a = ma
            return Result.mapFailure AppError.fromApiError a
        }

    let fromStoreFlow (ma : StoreFlow<'a,'b>) : AppFlow<'a,'b> =
        async {
            let! a = ma
            return Result.mapFailure AppError.fromStorageError a
        }

    let catchUnhandled<'r,'e> (fa : AppFlow<'r,'e>) : AppFlow<'r,'e> =
        fa
        |> Flow.catchMap UnhandledError