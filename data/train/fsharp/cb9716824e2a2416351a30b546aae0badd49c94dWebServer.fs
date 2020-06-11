module internal Octopus.OctopusService.WebServer

open System.Text
open System.Collections.Generic
open System.Security.Cryptography.X509Certificates
open System.Security.Principal


//------------------------------------------------------------------------------

type HandlerResponse =
| Raw
| Json
| Html
| JavaScript
| Css
| Png
| Gif
| Jpg
| Bmp

type private PageHandler =
  val private _t : HandlerResponse
  val private _fooText : HttpServer.RequestEventArgs -> string
  val private _fooBinary : HttpServer.RequestEventArgs -> byte array

  new(t:HandlerResponse, f:HttpServer.RequestEventArgs -> string) =
    {
      _t = t
      _fooText = f
      _fooBinary = fun _ -> null
    }
    then
      ()

  new(t:HandlerResponse, f:HttpServer.RequestEventArgs -> byte array) =
    {
      _t = t
      _fooText = fun _ -> null
      _fooBinary = f
    }
    then
      ()

  member x.HType with get() = x._t
  member x.HFooText with get() = x._fooText
  member x.HFooBinary with get() = x._fooBinary

let private pageHandlers = new Dictionary<string, PageHandler>()

//------------------------------------------------------------
//---- Security tools

type RoleRequestMode =
| Any
| All
| Noone

type RoleRequest =
  val private roles : System.Collections.Generic.List<string>
  val mutable private mode : RoleRequestMode

  member x.Roles with get() = x.roles
  member x.Mode with get() = x.mode and set(v) = x.mode <- v
  member x.IsInRoles(pal:IPrincipal) =
    if pal = null then false
    else match x.mode with
         | Any -> x.roles |> Seq.exists (fun r -> pal.IsInRole(r))
         | All -> x.roles |> Seq.forall (fun r -> pal.IsInRole(r))
         | Noone -> x.roles |> Seq.forall (fun r -> not(pal.IsInRole(r)))

  new (rr:string array) as this =
    { roles = new System.Collections.Generic.List<string>(); mode = RoleRequestMode.Any }
    then
      if rr.Length = 0 then failwith "RoleRequest needs at least one role"
      for r in rr do this.Roles.Add(r)

  new (rr:string array,m:RoleRequestMode) as this =
    RoleRequest(rr)
    then
      this.Mode <- m

//------------------------------------------------------------

let addHandlerRaw (path:string) (hfoo:HttpServer.RequestEventArgs -> unit) (roleRequested:RoleRequest option) =
    let handler = fun (e:HttpServer.RequestEventArgs) ->
                    match roleRequested with
                    | Some x -> if not(x.IsInRoles(e.AuthenticatedUser)) then UserAuth.requestAuthentication()       // raises an exception catched by the web server
                    | None -> ()
                    hfoo e
                    ""
    let hh = new PageHandler(HandlerResponse.Raw, handler)
    pageHandlers.Add(path, hh)

let addHandlerJson (path:string) (hfoo:(IPrincipal * IDictionary<string,string>) -> string) (roleRequested:RoleRequest option) =
    let handler = fun (e:HttpServer.RequestEventArgs) ->
                    match roleRequested with
                    | Some x -> if not(x.IsInRoles(e.AuthenticatedUser)) then UserAuth.requestAuthentication()       // raises an exception catched by the web server
                    | None -> ()
                    let p = dict [ for x in e.Request.Parameters -> (x.Name, x.Value)
                                   yield ("_ipAddress", e.Context.RemoteEndPoint.Address.ToString())
                                   let u = e.Request.Uri.AbsoluteUri in yield ("_uri", u)
                                   let c = e.Request.Cookies.["authToken"] in if c <> null then yield ("_authToken", c.Value) ]
                    hfoo (e.AuthenticatedUser, p)
    let hh = new PageHandler(HandlerResponse.Json, handler)
    pageHandlers.Add(path, hh)

let addHandlerText (path:string) (htype:HandlerResponse) (hfoo:(IPrincipal * IDictionary<string,string>) -> string) (roleRequested:RoleRequest option) =
  match htype with
  | Html | JavaScript | Css ->
    let handler = fun (e:HttpServer.RequestEventArgs) -> 
                    match roleRequested with
                    | Some x -> if not(x.IsInRoles(e.AuthenticatedUser)) then UserAuth.requestAuthentication()       // raises an exception catched by the web server
                    | None -> ()
                    let p = dict [ for x in e.Request.Parameters -> (x.Name, x.Value)
                                   yield ("_ipAddress", e.Context.RemoteEndPoint.Address.ToString())
                                   let u = e.Request.Uri.AbsoluteUri in yield ("_uri", u)
                                   let c = e.Request.Cookies.["authToken"] in if c <> null then yield ("_authToken", c.Value) ]
                    hfoo (e.AuthenticatedUser, p)
    let hh = new PageHandler(htype, handler)
    pageHandlers.Add(path, hh)
  | _ ->
    failwith "The specified handler type is not of type 'Text'"

let addHandlerBinary (path:string) (htype:HandlerResponse) (hfoo:(IPrincipal * IDictionary<string,string>) -> byte array) (roleRequested:RoleRequest option) =
  match htype with
  | Png | Gif | Jpg | Bmp ->
    let handler = fun (e:HttpServer.RequestEventArgs) -> 
                    match roleRequested with
                    | Some x -> if not(x.IsInRoles(e.AuthenticatedUser)) then UserAuth.requestAuthentication()       // raises an exception
                    | None -> ()
                    let p = dict [ for x in e.Request.Parameters -> (x.Name, x.Value)
                                   yield ("_ipAddress", e.Context.RemoteEndPoint.Address.ToString())
                                   let u = e.Request.Uri.AbsoluteUri in yield ("_uri", u)
                                   let c = e.Request.Cookies.["authToken"] in if c <> null then yield ("_authToken", c.Value) ]
                    hfoo (e.AuthenticatedUser, p)
    let hh = new PageHandler(htype, handler)
    pageHandlers.Add(path, hh)
  | _ ->
    failwith "The specified handler type is not of type 'Binary'"



let handleTextFile (file:System.IO.FileInfo) _ : string =
  use ff = file.OpenText()
  ff.ReadToEnd()

let handleBinaryFile (file:System.IO.FileInfo) _ : byte array =
  use ff = file.OpenRead()
  let byteArray = Array.zeroCreate<byte>(int ff.Length)
  ff.Read(byteArray, 0, int ff.Length) |> ignore
  byteArray


let private execute_handler_for_Raw (h:PageHandler) (e:HttpServer.RequestEventArgs) =
  try
    h.HFooText e |> ignore      // returns always ""
  with
    | :? HttpServer.AuthenticationRequiredException ->
            reraise()
    | ex ->
            e.Response.Status <- System.Net.HttpStatusCode.BadRequest   // 400
            e.Response.Reason <- "Bad Request"


let private execute_handler_for_Json (h:PageHandler) (e:HttpServer.RequestEventArgs) =
  e.Response.Add(new HttpServer.Headers.StringHeader("Cache-Control", "private, no-cache, no-store, must-revalidate"))
  e.Response.Add(new HttpServer.Headers.StringHeader("Pragma", "no-cache"))
  e.Response.ContentType <- new HttpServer.Headers.ContentTypeHeader("application/json; charset=UTF-8")
  e.Response.Connection.Type <- HttpServer.Headers.ConnectionType.Close

  try
    let text = h.HFooText e

    let response = new System.Collections.Generic.Dictionary<string, obj>()
    response.["authenticated"] <- if e.AuthenticatedUser = null then null else e.AuthenticatedUser.Identity.Name
    response.["error"] <- false
    if text <> null && text.Length > 0 then response.["data"] <- Newtonsoft.Json.JsonConvert.DeserializeObject(text)

    let buffer = Encoding.UTF8.GetBytes(Newtonsoft.Json.JsonConvert.SerializeObject(response))
    e.Response.Body.Write(buffer, 0, buffer.Length)
    e.Response.Encoding <- Encoding.UTF8

  with
    | :? HttpServer.AuthenticationRequiredException ->
            reraise()
    | ex ->
            e.Response.Status <- System.Net.HttpStatusCode.InternalServerError   // 500
            e.Response.Reason <- "Internal Server Error"

            let response = new System.Collections.Generic.Dictionary<string, obj>()
            response.["authenticated"] <- if e.AuthenticatedUser = null then null else e.AuthenticatedUser.Identity.Name
            response.["error"] <- true
            response.["reason"] <- ex.Message

            let buffer = Encoding.UTF8.GetBytes(Newtonsoft.Json.JsonConvert.SerializeObject(response))
            e.Response.Body.Write(buffer, 0, buffer.Length)
            e.Response.Encoding <- Encoding.UTF8
  

let private execute_handler_for_Text (h:PageHandler) (e:HttpServer.RequestEventArgs) =
  match h.HType with
  | Html -> e.Response.ContentType <- new HttpServer.Headers.ContentTypeHeader("text/html; charset=UTF-8")
  | JavaScript -> e.Response.ContentType <- new HttpServer.Headers.ContentTypeHeader("text/javascript")
  | Css -> e.Response.ContentType <- new HttpServer.Headers.ContentTypeHeader("text/css")
  | _ -> raise (new System.ArgumentException("PageHandler.HType"))

  e.Response.Connection.Type <- HttpServer.Headers.ConnectionType.Close

  try
    let text = h.HFooText e

    let buffer = Encoding.UTF8.GetBytes(text)
    e.Response.Body.Write(buffer, 0, buffer.Length)
    e.Response.Encoding <- Encoding.UTF8

  with
    | :? HttpServer.AuthenticationRequiredException ->
            reraise()
    | _ ->
            e.Response.Status <- System.Net.HttpStatusCode.InternalServerError   // 500
            e.Response.Reason <- "Internal Server Error"


let private execute_handler_for_Binary (h:PageHandler) (e:HttpServer.RequestEventArgs) =
  match h.HType with
  | Png -> e.Response.ContentType <- new HttpServer.Headers.ContentTypeHeader("image/png")
  | Gif -> e.Response.ContentType <- new HttpServer.Headers.ContentTypeHeader("image/gif")
  | Jpg -> e.Response.ContentType <- new HttpServer.Headers.ContentTypeHeader("image/jpeg")
  | Bmp -> e.Response.ContentType <- new HttpServer.Headers.ContentTypeHeader("image/bmp")
  | _ -> raise (new System.ArgumentException("PageHandler.HType"))

  e.Response.Connection.Type <- HttpServer.Headers.ConnectionType.Close

  try
    let buffer = h.HFooBinary e
    e.Response.Body.Write(buffer, 0, buffer.Length)

  with
    | :? HttpServer.AuthenticationRequiredException ->
            reraise()
    | _ ->
            e.Response.Status <- System.Net.HttpStatusCode.InternalServerError   // 500
            e.Response.Reason <- "Internal Server Error"



let private handleSessionAuthorization (e:HttpServer.RequestEventArgs) =
  let authToken =
    let c = e.Request.Cookies.["authToken"]
    if c = null then null else c.Value

  if e.AuthenticatedUser = null && authToken <> null then
      let p = UserAuth.lookupSession authToken
      if p <> null then e.SetPrincipal(p)
      else e.Response.Cookies.Add(new HttpServer.Messages.ResponseCookie("authToken", "expired", System.DateTime.Now.AddDays(-1.)))
  elif e.AuthenticatedUser <> null && authToken = null then
      let authToken = string( System.Guid.NewGuid() )
      UserAuth.addSession authToken e.AuthenticatedUser
      e.Response.Cookies.Add(new HttpServer.Messages.ResponseCookie("authToken", authToken, System.DateTime.MinValue))
  elif e.AuthenticatedUser <> null && authToken <> null then
      UserAuth.renewSession authToken e.AuthenticatedUser


let private server_RequestReceived (sender:obj) (e:HttpServer.RequestEventArgs) =
  handleSessionAuthorization e
  (* ---------------- *)
  let localPath = e.Request.Uri.LocalPath

  if not(pageHandlers.ContainsKey(localPath)) then
    e.Response.Connection.Type <- HttpServer.Headers.ConnectionType.Close
    e.Response.Status <- System.Net.HttpStatusCode.NotFound     // 404
    e.Response.Reason <- "Not Found"
  else
    let h = pageHandlers.[localPath]
    try
      match h.HType with
      | Raw -> execute_handler_for_Raw h e
      | Json -> execute_handler_for_Json h e
      | Html | JavaScript | Css -> execute_handler_for_Text h e
      | Png | Gif | Jpg | Bmp -> execute_handler_for_Binary h e
    with
    | :? HttpServer.AuthenticationRequiredException as ex ->
      if ex.Message = "local" then raise (new HttpServer.AuthenticationRequiredException(e.Request.Uri.Host))
      else
        match OAuth2Auth.getAuthenticationParameters() with
        | None ->
              raise (new HttpServer.AuthenticationRequiredException(e.Request.Uri.Host))
        | Some p ->
              let uri = OAuth2Auth.requestUserAuthorization p |> Async.RunSynchronously
              e.Response.Redirect(uri.AbsoluteUri)

//-------------------------------------

let init() =
    addHandlerJson "/admin/callAdminFunction.aspx" WebFunctions.Admin.callFunction (Some(new RoleRequest([|"Admin"|])))
    addHandlerJson "/api/callFunction.aspx" WebFunctions.Users.callFunction (Some(new RoleRequest([|"User"|])))
    addHandlerBinary "/api/getVmScreenBitmap.aspx" HandlerResponse.Png WebFunctions.Users.getVmScreenBitmap (Some(new RoleRequest([|"User"|])))
    addHandlerJson "/api/callDeployFunction.aspx" WebFunctions.Deployment.callFunction (Some(new RoleRequest([|"User"|])))
    addHandlerRaw "/api/authlocal.aspx" WebFunctions.Guests.authenticate_local None
    addHandlerRaw "/api/oauth.aspx" WebFunctions.Guests.oauth2Process None

    let webFiles = try General.getServiceBinPath.GetDirectories("wwwroot").[0].EnumerateFiles()
                   with _ -> Seq.empty

    for file in webFiles do
    let ext = file.Extension.ToLower()
    if ext = ".htm" || ext = ".html" then
        addHandlerText ("/" + file.Name) HandlerResponse.Html (handleTextFile file) (Some(new RoleRequest([|"User"|])))
    elif ext = ".css" then
        addHandlerText ("/" + file.Name) HandlerResponse.Css (handleTextFile file) (Some(new RoleRequest([|"User"|])))
    elif ext = ".js" then
        addHandlerText ("/" + file.Name) HandlerResponse.JavaScript (handleTextFile file) (Some(new RoleRequest([|"User"|])))
    elif ext = ".gif" then
        addHandlerBinary ("/" + file.Name) HandlerResponse.Gif (handleBinaryFile file) (Some(new RoleRequest([|"User"|])))
    elif ext = ".jpg" || ext = ".jpeg" then
        addHandlerBinary ("/" + file.Name) HandlerResponse.Jpg (handleBinaryFile file) (Some(new RoleRequest([|"User"|])))
    elif ext = ".png" then
        addHandlerBinary ("/" + file.Name) HandlerResponse.Png (handleBinaryFile file) (Some(new RoleRequest([|"User"|])))

//-------------------------------------

let private server =
  let pfxFile = System.IO.Path.Combine(General.getServiceBinPath.FullName, "octopus.pfx")
  let cert = new X509Certificate2(pfxFile, "octopus")
  let serv = new HttpServer.Server()
  serv.Add(new HttpServer.SecureHttpListener(System.Net.IPAddress.Any, 443, cert))
  serv.RequestReceived.AddHandler(fun s e -> server_RequestReceived s e)
  let auth = new HttpServer.Authentication.DigestAuthentication(new UserAuth.OctopusUserProvider())
  serv.AuthenticationProvider.Add(auth)
  serv

let startServer () =
  server.Start(5)

let stopServer () =
  server.Stop(true)