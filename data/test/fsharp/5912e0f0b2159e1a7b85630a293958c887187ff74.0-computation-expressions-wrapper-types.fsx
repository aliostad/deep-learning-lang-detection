(**
Maybe
*)
type MaybeBuilder() =
  member this.Bind(m, f) = // Option.bind f m
    match m with
    | None -> None
    | Some a -> f a


  member this.Return(x) = Some x

let maybe = new MaybeBuilder()

let strToInt str = 
  let ok, value = System.Int32.TryParse(str)
  if ok 
  then Some(value)
  else None

let result = 
    maybe 
        {
        let! anInt = strToInt "10"  // expression of Option<int>
        let! anInt2 = strToInt "20" // expression of Option<int>
        return anInt + anInt2 
        }    


(**
DbResult
*)

type DbResult<'a> = 
    | Success of 'a
    | Error of string

let getCustomerId name =
    if (name = "") 
    then Error "getCustomerId failed"
    else Success "Cust42"

let getLastOrderForCustomer custId =
    if (custId = "") 
    then Error "getLastOrderForCustomer failed"
    else Success "Order123"

let getLastProductForOrder orderId =
    if (orderId  = "") 
    then Error "getLastProductForOrder failed"
    else Success "Product456"

let product = 
    let r1 = getCustomerId "Alice"
    match r1 with 
    | Error _ -> r1
    | Success custId ->
        let r2 = getLastOrderForCustomer custId 
        match r2 with 
        | Error _ -> r2
        | Success orderId ->
            let r3 = getLastProductForOrder orderId 
            match r3 with 
            | Error _ -> r3
            | Success productId ->
                printfn "Product is %s" productId
                r3

type DbResultBuilder() =
  member this.Bind(m,f) =
    match m with
    | Error _ -> m
    | Success a ->
      printfn "\tsuccessful: %s" a
      f a

  member this.Return(x) =
    Success x

let dbResult = new DbResultBuilder()

let product' = 
    dbResult {
        let! custId = getCustomerId "Alice"
        let! orderId = getLastOrderForCustomer custId
        let! productId = getLastProductForOrder orderId 
        printfn "Product is %s" productId
        return productId
        }
printfn "%A" product'

(**
Every computation expression must have an associated wrapper type. 
And the wrapper type is often designed specifically to go hand-in-hand with the workflow that we want to manage.
*)


(**
let! - The let! has "unwrapped" the option before binding it to the value.

  member Bind : M<'T> * ('T -> M<'U>) -> M<'U>

  - Take a wrapped value
  - Unwrapped (usually with pattern matching) and could apply a (continuation) function to it
  - Return wrapped value


return -  the return has "wrapped" the raw value back into an option.
  
  member Return : 'T -> M<'T>

  - The output of Return can be fed to the input of a Bind

return! - return "wrapped" value as is.
  member ReturnFrom : M<'T> -> M<'T>

*)
