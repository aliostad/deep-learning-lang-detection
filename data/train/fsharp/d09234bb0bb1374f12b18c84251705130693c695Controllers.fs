namespace MvcBench.Controllers

open Microsoft.AspNetCore.Mvc

type HelloHandler = HelloHandler of (string option -> string)
module HelloHandler =
  let run (HelloHandler f) x = f x
  let impl = HelloHandler <| function
    | Some name -> sprintf "Hello %s!" name
    | None -> "Hello World!"

[<Route("hello")>]
type HelloController (handler:HelloHandler) =
  inherit Controller()

  [<HttpGet>]
  member x.Get() =
    base.Ok(HelloHandler.run handler None)

  [<HttpGet("{name}")>]
  member x.GetByName(name: string) =
    base.Ok(HelloHandler.run handler (Some name))
