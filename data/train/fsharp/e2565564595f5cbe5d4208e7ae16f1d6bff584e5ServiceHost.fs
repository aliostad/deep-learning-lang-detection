namespace SkyVue.Host

open Nancy
open ServiceStack.Text

open System
open System.Collections.Generic
open System.Linq
open System.Reflection

open SkyVue.Data
open SkyVue.Error
open SkyVue.Interface
open SkyVue.Service

type public ServiceHost() =
    inherit Nancy.NancyModule()
    
    let path = @"Server=localhost\SQLEXPRESS;Integrated security=SSPI;Initial Catalog=skyvuetest"
    let db = Schema.GetDataContext(path)
    let services = [|
        JoinService(db):>obj;
        LogonService(db):>obj;
        UsersService(db):>obj;
        MailService(db, LogonService(db)):>obj;
        ManageService(db, LogonService(db)):>obj;
        SubscribeService(db, LogonService(db)):>obj;
        PostService(db, LogonService(db)):>obj
    |]

    do
        // obtains the uri pattern for a service and method
        let patternFor (service : obj) (call : MethodInfo) =
            let serviceName = service.GetType().Name
            let callName = call.Name
            call.GetParameters()
            |> Seq.map (fun parameter -> "{" + parameter.Name + "}/")
            |> String.concat ""
            |> sprintf "/%s/%s/%s" serviceName callName
        // handle input parameters for a method call
        let handlerFor (service:obj) (call : MethodInfo) (parameters : DynamicDictionary) =
            let values =
                call.GetParameters()
                |> Seq.map (fun parameter ->
                    let value = parameters.[parameter.Name].ToString()
                    match parameter.ParameterType.Name with
                    | "Int32" -> Int32.Parse(value) :> obj
                    | "String" -> value :> obj
                    | "Boolean" -> Boolean.Parse(value) :> obj
                    | "DateTime" -> DateTime.Parse(value) :> obj
                    | observedTypeName ->
                        let message = sprintf "Unrecognized %s on %s" observedTypeName parameter.Name
                        raise (new ArgumentException(message)))
                |> Seq.toArray
            try
                call.Invoke(service, values)
                |> JsonSerializer.SerializeToString
                :> obj
            with
            | :? TargetInvocationException as e ->
                match e.InnerException with
                | AccessDenied(message) -> HttpStatusCode.Forbidden
                | AccountLockedOut(message) -> HttpStatusCode.Unauthorized
                | AlreadyExists(message) -> HttpStatusCode.Conflict
                | BadIdentityOrPassword(message) -> HttpStatusCode.NotAcceptable
                | DatastoreNotReady(message) -> HttpStatusCode.ServiceUnavailable
                | NotFound(message) -> HttpStatusCode.NotFound
                | NullOrEmptyInput(message) -> HttpStatusCode.BadRequest
                | ProtectedChannel(message) -> HttpStatusCode.Locked
                | _ -> HttpStatusCode.InternalServerError
                :> obj
            
        // configure the individual service calls
        let calls = query {
            for service in services do
            for serviceInterface in service.GetType().GetInterfaces() do
            for call in serviceInterface.GetMethods() do
            select (patternFor service call, handlerFor service call)
        }
        for (pattern, handler) in calls do
            base.Get.[pattern] <- (fun x -> x :?> DynamicDictionary |> handler)


        // configure a root index of all service calls
        base.Get.["/"] <- (fun x ->
            calls
            |> Seq.map fst
            |> Seq.map (fun pattern -> "<li>" + pattern + "</li>\n")
            |> String.concat ""
            |> (fun patterns -> "<ul>" + patterns + "</ul>" :> obj))
