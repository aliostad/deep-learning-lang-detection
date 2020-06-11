// Simple asynchronous function that capitalizes a string
let capitalizeAsync (s:string) = async {
  return s.ToUpper() }

// Simple asynchronous function that appends "Hello" to front
let addHelloAsync (s:string) = async {
  return "Hello " + s + "!" }

// Asynchronous function that calls two other asynchronous 
// functions asynchronously and uses 'try .. with' to 
// handle exceptions that may occur in a standard way
let processWord (s:string) = async {
  try
    let! cap = capitalizeAsync(s)
    let! hcap = addHelloAsync(cap)
    return hcap
  with e ->
    return "Exception occurred!" }


processWord "wk" |> Async.RunSynchronously |> printfn "%A"
