namespace StructedSight.ApiEndpointMapper

open System.Reflection

type Type = {Name : string; Namespace:string}
type Property = {Name:string; Type:string}
type Parameter = {Name:string; Type:Type}
type Method = 
    {Name:string; Parameters:Parameter seq; ReturnValue : Parameter; RoutePath:string; AcceptVerbs:string seq}
type Class = {Name:string; Namespace:string; Properties:Property seq; Methods : Method seq; RoutePrefix:string}


module Mapper = 
    
    let IsApiControllerType () = true

    let GetWebApiControllerTypesFromAssembly (assembly:Assembly) = 
        ""

