#r "node_modules/fable-core/Fable.Core.dll"

open Fable.Core
open Fable.Core.JsInterop

[<Pojo>]
type LambdaContext =
  {
    callbackWaitsForEmptyEventLoop : bool
    logGroupName : string
    logStreamName : string
    functionName : string
    memoryLimitInMB : string
    functionVersion : string
    invokeid : string
    awsRequestId : string
  }

type NativeHandler<'Request, 'Response> = System.Func<'Request, LambdaContext, (System.Func<exn option, 'Response option, unit>), unit>

type AsyncHandler<'Request, 'Response> = LambdaContext -> 'Request -> Async<'Response>

let handler (handler : AsyncHandler<'Request, 'Response>) : NativeHandler<'Request, 'Response> =
  System.Func<_,_,_,_>(fun request context callback ->
    async {
      try
        let! response = handler context request
        callback.Invoke(None, Some response)
      with ex ->
        callback.Invoke(Some ex, None)
    } |> Async.StartImmediate)
