namespace WebApiWindow

open System.Reflection
open System

type Name = {Name:string; Namespace:string}

type ItemType = {Name:Name; Properties : ItemType seq}

type TypeStub = {Name:Name}

type Parameter = {Name:string; Type:TypeStub}

type Action = {Name:string}

type ApiMethod = {Name:string; Parameters:Parameter seq; ReturnType : TypeStub; 
    RoutePath:string option; Actions:Action seq}

type ApiController = {Name:Name; Type:Type; Methods:ApiMethod seq; RoutePrefix:string option}


module ApiControllers = 
 
    let rec GetTypeName (t:TypeInfo) = t.Name
        //if t.IsGenericType then

    let GetAttributes<'T> (m:MethodInfo) = 
        m.GetCustomAttributes(typeof<'T>) |> 
        Seq.cast<'T>

    let GetTypeAttributes<'T> (t:TypeInfo) = 
        t.GetCustomAttributes(typeof<'T>) |> 
        Seq.cast<'T>

    let GetActions (m:MethodInfo) = 
        let name =  match m.Name.ToLower() with 
                    | "get" | "post" | "put" | "delete" -> [m.Name]
                    | _ -> []

        let action = GetAttributes<System.Web.Http.ActionNameAttribute>(m)
                        |> Seq.map(fun a->a.Name)

        Seq.append action name |> Seq.map(fun a -> {Action.Name = a})

    let GetRoutePath (m:MethodInfo) = 
        GetAttributes<System.Web.Http.RouteAttribute>(m)
            |> Seq.map(fun a->a.Template)
            |> Seq.tryHead

    let GetRoutePrefix (t:Type) = 
        t.GetCustomAttributes(typeof<System.Web.Http.RoutePrefixAttribute>) 
            |> Seq.cast<System.Web.Http.RoutePrefixAttribute>
            |> Seq.map(fun x-> x.Prefix)
            |> Seq.tryHead
        

    let MakeTypeStub (t:Type) = 
        {TypeStub.Name = {Name = t.Name; Namespace = t.Namespace}}

    let MakeParameter (p:ParameterInfo) = 
        let typeStub = MakeTypeStub p.ParameterType
        {Parameter.Name = p.Name; Type = typeStub}

    let MapMethod (m:MethodInfo) = 
        let parameters = m.GetParameters() |> Seq.map MakeParameter
        let returnType = MakeTypeStub m.ReturnType
        let name = m.Name
        let routePath = GetRoutePath m
        let actions = GetActions m

        {Name = name; ReturnType = returnType; Parameters = parameters; RoutePath = routePath;
            Actions = actions }

    let MakeApiController (t:Type) = 
        let name = {Name = t.Name; Namespace = t.Namespace}
        let methods = t.GetMethods() |> Seq.map MapMethod
        let routePrefix = GetRoutePrefix t

        {Name = name; Methods = methods; RoutePrefix = routePrefix; Type = t}


    let rec IsApiController (t:Type) = 
       match t.BaseType.Name with 
       | "WebApiController" -> true
       | "Object" | "" | null -> false
       | cls -> IsApiController t.BaseType

    let GetApiControllers (assembly:Assembly) = 
       
        assembly.GetTypes() 
            |> Seq.where IsApiController
            |> Seq.map(MakeApiController)

