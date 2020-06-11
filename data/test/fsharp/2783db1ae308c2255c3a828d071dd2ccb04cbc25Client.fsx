#if INTERACTIVE

#load "../../../../paket-files/include-scripts/net46/include.swaggerprovider.fsx"

#endif

open SwaggerProvider
open System.Collections.Generic


[<Literal>]
let private swaggerConfig  = __SOURCE_DIRECTORY__ + "./../schema/apiDocs.json"

type private Api = SwaggerProvider<swaggerConfig>

type T = 
  { add : int -> int -> int
  }

let create host = 
  let client = Api(host)
  
  let addImpl x y = 
    client.PostCalculateAdd(Api.AddRequest(X= Some x, Y= Some y)).Sum |> function | Some s -> s

  { add = addImpl }