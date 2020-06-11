namespace Strangelights.PicoMvc
open System
open System.IO
open System.Text
open System.Web
open System.Web.Routing
open System.Web.SessionState
open System.Reflection
open Microsoft.FSharp.Reflection
open Strangelights.Log4f

type ControllerAttribute() =
    inherit Attribute()

type DynamicControllerAttribute() =
    inherit Attribute()

type ErrorMessage =
    { Code: int
      Error: string }

type RenderingData =
    { Model: option<obj>
      Error: option<ErrorMessage>
      Exception: option<Exception>
      ValidationMessages: Map<string,string> }
    with
        static member Default =
            { Model = None
              Error = None
              Exception = None
              ValidationMessages = Map.empty }

type File =
    { ContentLength: int
      ContentType: string
      FileName: string
      InputStream: Stream }

type ModuleResult =
    | NewProperties of List<string*obj>

type ControllerResult =
    | Result of obj
    | ResultAndValidationMessages of obj * Map<string,string>
    | Redirect of string
    | Error of int * string
    | NoResult

type Cookie =
    { Domain: option<string>
      Expires: option<DateTime>
      HttpOnly: bool
      Name: string
      Path: string
      Secure: bool
      Values: Map<string,string> }
    with
        member x.AddOrAlterValue key value =
            { x with Values = Map.add key value x.Values }
        member x.RemoveValue key =
            { x with Values = Map.remove key x.Values }
        static member Make name = 
            { Domain = None
              Expires = None
              HttpOnly = false
              Name = name
              Path = "/"
              Secure = false
              //Value = None
              Values = Map.empty }
        static member Make (name, key, value) = 
            { Domain = None
              Expires = None
              HttpOnly = false
              Name = name
              Path = "/"
              Secure = false
              //Value = None
              Values = Map.add key value Map.empty }

type PicoRequest(urlPart: string, 
                 urlExtension: string: string, 
                 verb: string, 
                 parameters: Map<string, string>, 
                 headers: Map<string, string>, 
                 cookies: Map<string, Cookie>,
                 files: Map<string, File>,
                 rawStream: Stream, 
                 requestStream: StreamReader) =
    member x.UrlPart = urlPart
    member x.UrlExtension = urlExtension
    member x.Verb = verb
    member x.Parameters = parameters
    member x.Headers = headers
    member x.Cookies = cookies
    member x.Files = files
    member x.RawStream = rawStream
    member x.RequestStream = requestStream

type PicoResponse(rawStream: Stream, 
                  responceStream: StreamWriter,
                  // TODO get headers working
//                  defaultHeaders: Map<string, string>,
//                  overrideDefaultHeaders: Map<string, string> -> unit,
                  setStatusCode: int -> unit, 
                  writeCookie: Cookie -> unit,
                  redirect: string -> unit) =
    member x.RawStream = rawStream
    member x.ResponceStream = responceStream
                  // TODO get headers working
//    member x.DefaultHeaders = defaultHeaders
//    member x.OverrideDefaultHeaders headers = overrideDefaultHeaders headers
    member x.SetStatusCode code = setStatusCode code
    member x.WriteCookie cookie = writeCookie cookie
    member x.Redirect url = redirect url

type PicoContext(request: PicoRequest, response: PicoResponse, properties: Map<string,obj>, mapPath: string -> string) =
    let mutable properties = properties
    member internal x.UpdateProperties props = properties <- props
    member x.Request = request
    member x.Response = response
    member x.Properties = properties
    member x.MapPath path = mapPath path


type RoutingTable private (staticHandlersMap: Map<string * string, (string*Type)[] * (obj[] -> obj)>, dynamicHandlers, modules: list<(string*Type)[] * (obj[] -> obj)>) =
    static let httpVerbs = [ "get"; "put"; "post"; "delete"; ]
    static let logger = LogManager.getLogger()

    let getDynamicFunction func =
        let t = func.GetType()
        if FSharpType.IsFunction t then
            let invokeMethod = 
                t.GetMethods()
                |> Seq.filter (fun x -> x.Name = "Invoke")
                // strange way to say invoke overload with most parameters
                |> Seq.sortBy (fun x -> x.GetParameters().Length)
                |> Seq.toList |> List.rev |> List.head
            let parameters = invokeMethod.GetParameters() |> Seq.map (fun x -> x.Name, x.ParameterType) |> Seq.toArray
            let invoke = fun parameters -> invokeMethod.Invoke(func, parameters)
            parameters, invoke
        else failwith "not a function"
    member x.Modules = modules

    member x.GetHandlerFunction (request: PicoRequest) =
        let key = request.Verb.ToLowerInvariant(), request.UrlPart
        if staticHandlersMap.ContainsKey key then
            let handler = staticHandlersMap.[key]
            Some handler
        else
            List.tryFind (fun (accpetFunc, _) -> accpetFunc request) dynamicHandlers
            |> Option.map snd

    static member LoadFromAssemblies(assems: Assembly[]) =
        do for assem in assems do logger.Info "Checking for Controllers: %s" assem.FullName

        let getAssemblies (assem: Assembly) =
            try 
                assem.GetTypes()
            with ex ->
                logger.Warn(ex, "Failed to load types from assembly %s") assem.FullName
                [||]

        let fsModules =
            assems 
            |> Seq.collect getAssemblies
            |> Seq.filter (fun typ -> FSharpType.IsModule typ)
            |> Seq.toList
        let rootHandlerModules = fsModules |> Seq.filter (fun typ -> typ.IsDefined(typeof<ControllerAttribute>, false))
        do for handler in rootHandlerModules do logger.Info "Found root handler: %s" handler.FullName

        let rec walkSubHandlers (types: seq<Type>) =
            seq { for typ in types do
                    yield! walkSubHandlers (typ.GetNestedTypes())
                    if FSharpType.IsModule  typ then
                        yield typ }

        let allHandlers = walkSubHandlers rootHandlerModules
        let urlOfName (typ: Type) =
            let name =
                if typ.IsNested then
                    typ.FullName.[typ.Namespace.Length + 1 .. ].Replace('+', '/')
                else
                    typ.Name
            name.ToLowerInvariant()
        let handlerFromType (typ: Type) verb =
            let handler = typ.GetMethod(verb, BindingFlags.Static ||| BindingFlags.Public)
            if handler <> null then
                let parameters = handler.GetParameters() |> Array.map (fun p -> p.Name, p.ParameterType)
                Some (parameters, fun parameters -> handler.Invoke(null, parameters))
            else
                None
        let handlersMap = 
            allHandlers 
            |> Seq.collect (fun typ -> 
                            httpVerbs 
                            |> Seq.choose (fun verb ->  handlerFromType typ verb |> Option.map (fun x -> (verb, urlOfName typ), x) ))
            |> Map.ofSeq
        do for entry in handlersMap do logger.Info "Found handler, (verb, url): %A" entry.Key

        let dynamicHandlerModules = fsModules |> Seq.filter (fun typ -> typ.IsDefined(typeof<DynamicControllerAttribute>, false))
        do for handler in rootHandlerModules do logger.Info "Found dynamic handler: %s" handler.FullName

        let getDynamicHandler (typ: Type) =
            let acceptFunc = typ.GetMethod("accept", BindingFlags.Static ||| BindingFlags.Public)
            let func = typ.GetMethod("handle", BindingFlags.Static ||| BindingFlags.Public)
            if acceptFunc = null || func = null then
                failwithf "didn't find 'accept' and 'handle' in module %s" typ.Name
            // TODO map rough generic parameters to string ?
            let parameters = func.GetParameters() |> Array.map (fun p -> p.Name, p.ParameterType)
            let acceptFunc = fun (request:PicoRequest) -> acceptFunc.Invoke(null, [| request :> obj |]) :?> bool
            let func = parameters, fun parameters -> func.Invoke(null, parameters)
            acceptFunc, func

        let dynamicHandlers = dynamicHandlerModules |> Seq.map getDynamicHandler |> Seq.toList

        // TODO should we provide an attribute to allow us to declare a module?
        new RoutingTable(handlersMap, dynamicHandlers, [])

    static member LoadFromCurrentAssemblies() =
        let assems = AppDomain.CurrentDomain.GetAssemblies()
        RoutingTable.LoadFromAssemblies assems

    member x.AddStaticHandler((verb, url), func) =
        let dynamicFunc = getDynamicFunction func
        let handlersMap' = staticHandlersMap.Add((verb, url), dynamicFunc)
        new RoutingTable(handlersMap', dynamicHandlers, modules)

    member x.AddDynamicHandler(acceptFunc: PicoRequest -> bool, func) =
        let dynamicFunc = getDynamicFunction func
        let handlersMap' = (acceptFunc, dynamicFunc) :: dynamicHandlers
        new RoutingTable(staticHandlersMap, handlersMap', modules)

    member x.AddModule(func) =
        let dynamicFunc = getDynamicFunction func
        let modules' = dynamicFunc :: modules
        new RoutingTable(staticHandlersMap, dynamicHandlers, modules')
     
type ParameterAction =
    { CanTreatParameter: PicoContext -> string -> Type -> bool
      ParameterAction: PicoContext -> string -> Type -> obj }

type ResultAction =
    { CanTreatResult: PicoContext -> RenderingData -> bool
      ResultAction: PicoContext -> RenderingData -> unit }

type IOActions =
    { TreatModuleParameterActions: List<ParameterAction>
      TreatHandlerParameterActions: List<ParameterAction>
      TreatResultActions: List<ResultAction> }

module ParamaterActions =
    let defaultParameterAction  =
        let canTreat (context: PicoContext) name _ =
            context.Request.Parameters.ContainsKey name
        let action (context: PicoContext) name t =
            match t with
            | x when x = typeof<string> -> context.Request.Parameters.[name] :> obj
            | x when x = typeof<int> -> int context.Request.Parameters.[name] :> obj
            | x when x = typeof<float> -> float context.Request.Parameters.[name] :> obj
            | _ -> null
        { CanTreatParameter = canTreat
          ParameterAction = action }

    let contextParameterAction  =
        let canTreat (context: PicoContext) _ t =
            t = typeof<PicoContext> || t = typeof<PicoResponse> || t = typeof<PicoRequest>
        let action (context: PicoContext) _ t =
            match t with
            | x when x = typeof<PicoContext> -> context :> obj
            | x when x = typeof<PicoRequest> -> context.Request :> obj
            | x when x = typeof<PicoResponse> -> context.Request :> obj
            | _ -> null
        { CanTreatParameter = canTreat
          ParameterAction = action }

module ControllerMapper =
    type TempResult =
        | Res of ControllerResult
        | Exc of Exception

    let logger = LogManager.getLogger()

    let handleRequest (routingTables: RoutingTable) (context: PicoContext) (ioActions: IOActions) =
        let path = context.Request.UrlPart

        logger.Info "Processing %s request for %s" context.Request.Verb path

        let parameterOfType  actions (name:string, t:Type) = 
            let res =
                actions
                |> List.tryFind (fun pa -> pa.CanTreatParameter context name t)
            match res with
            | Some pa -> pa.ParameterAction context name t
            | None -> null
         

        // do the modules
        let execModule acc (parametersTypes, handler: obj[] -> obj) =
            let parameters =
                parametersTypes 
                |> Array.map (parameterOfType ioActions.TreatModuleParameterActions)
            let res = 
                try
                    let res = handler(parameters) :?> ModuleResult
                    logger.Info "Successfully handled %s request for %s" context.Request.Verb path
                    res
                with ex ->
                    logger.Error(ex, "Error handling module %s request for %s, error was") context.Request.Verb path
                    reraise()
            match res with
            | NewProperties props -> 
                // TODO, should we update props as we go?
                props @ acc

        let props = routingTables.Modules |> Seq.fold execModule []

        context.UpdateProperties (props |> Map.ofList)

        // handle the main request
        let handler = routingTables.GetHandlerFunction context.Request

        match handler with
        | Some (parametersTypes, handler) ->
            let parameters =
                parametersTypes 
                |> Array.map (parameterOfType ioActions.TreatHandlerParameterActions)
            let paramPair = Seq.zip parametersTypes parameters |> Seq.map(fun ((name,_), v) -> sprintf "%s: %A" name v)
            logger.Info "Parameters for %s request for %s: %s" context.Request.Verb path (String.Join(", ", paramPair))

            let res = 
                try
                    let res = handler(parameters) :?> ControllerResult
                    logger.Info "Successfully handled %s request for %s" context.Request.Verb path
                    Res res
                with ex ->
                    // TODO maybe better to rethrow the exception here can't decide 
                    logger.Error(ex, "Error handling %s request for %s, error was") context.Request.Verb path
                    Exc ex
            let treatResult obj =
                let res =
                    ioActions.TreatResultActions 
                    |> List.tryFind (fun pa -> pa.CanTreatResult context obj)
                match res with
                | Some pa -> pa.ResultAction context obj
                | None -> ()
            match res with
            | Res (Result model) -> treatResult { RenderingData.Default with Model = Some model }
            | Res (ResultAndValidationMessages (model, messages)) -> 
                treatResult { RenderingData.Default with Model = Some model; ValidationMessages = messages }
            | Res (Redirect url) -> context.Response.Redirect url
            | Res (Error(code, message)) -> 
                context.Response.SetStatusCode code
                let error = { Code = code; Error = message }
                treatResult { RenderingData.Default with Error = Some error }
            | Res (NoResult) -> ()
            | Exc (ex) -> 
                context.Response.SetStatusCode 500
                treatResult { RenderingData.Default with Exception = Some ex }
        | None ->
            logger.Warn "Did not find handler for %s request for %s" context.Request.Verb path
            // TODO raising an http exception doesn't really seem to work, why?
            //raise (new HttpException("not found", 404)) 
            context.Response.SetStatusCode 404
            context.Response.ResponceStream.Write("not found")