(* WebOnCont continuation passing style web framework *)
(* Http Server module *)
(* @author Timur Abishev (abishev.timur@gmail.com) *)
(* GPL license http://www.gnu.org/licenses/gpl.html *)
module mw.server
open mw.httpcontinuation
open System.Net

type template = string -> string

(* main global declaration *)
let random = System.Random()
let mutable storage = Map [("0", fun (request : HttpListenerRequest, feedback : UserFeedback) -> ())]
let mutable sessions = Map [("0", "0")]

(* methods for store callbacks *)
let getKey = fun () -> (sprintf "%A" (random.Next 10000000))
let registerCallback f oldKey =
  let key = getKey ()
  let session = 
    match oldKey with
    | null -> key
    | oldKey -> sessions.[oldKey]
  sessions <- sessions.Add (key, session)
  printfn "added key %A" key;
  storage <- storage.Add (key, f);
  key  

(* main request method *)
let request (template : template) : (HttpListenerRequest HttpContinuation) = 
  fun ((response : HttpListenerResponse, oldKey : string), f) ->
    let key = registerCallback f oldKey
    let message = template key
    let bytes = System.Text.Encoding.UTF8.GetBytes(message)
    response.OutputStream.Write(bytes, 0, bytes.Length);
    ();

(* method for session retrieval *)
let getSession : (string HttpContinuation) = 
  fun ((response : HttpListenerResponse, oldKey : string), f) ->
    f((sessions.[oldKey]), (response, oldKey)); () 

let callbackForNewClient (handler : 'a HttpContinuation) = 
  registerCallback (fun (a, b) -> (handler (b, (fun c -> () )))) null

(* methods for handlers register *)
let mutable handlers = Map [("", httpContinuation { return () } )]

let registerHandler (name : string) (handler : unit HttpContinuation) = 
  handlers <- handlers.Add (name, handler)
let processHandler handlerName = httpContinuation {
  do! handlers.[handlerName]
}

(* http handler *) 
let serviceClient (handler : 'a HttpContinuation) (client: HttpListenerContext) =
  let key = client.Request.QueryString.["key"]
  let key = 
    match storage.ContainsKey key with 
    | true -> key
    | false -> callbackForNewClient handler
  storage.[key] (client.Request, (client.Response, key));
  client.Response.Close()

(* http listener *)
let startServer serverPrefix handlerName =
  let handler = handlers.[handlerName]
  let listener = new HttpListener()
  listener.Prefixes.Add (serverPrefix);
  listener.Start();
   
  while (true) do serviceClient handler (listener.GetContext())

