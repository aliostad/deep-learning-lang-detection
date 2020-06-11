// Learn more about F# at http://fsharp.net. See the 'F# Tutorial' project
// for more guidance on F# programming.

open System

type Message =
    {
        Header : string
        Body   : string
    }


type RouteStep =
    |   Process of (Message -> Message)

type Endpoint =
    |   Uri of string
    with
        static member (=>=) ((source:Endpoint), (destination:(Message->Message)))=
            let newId = Guid.NewGuid()
            { id = newId; Endpoint = source; Route = [Process(destination)]}

and RouteDef = {
        id       : Guid
        Endpoint : Endpoint
        Route    : RouteStep list
    }
    with
//        static member convert (func:(Message->'a)) (original:Message) = 
//            let result = func original
//            {original with Body = "testconversion" }
//        static member (=>=) ((source:RouteDef), (destination:(Message->Message))) = 
//            { source with Route = Process(destination) :: source.Route}
//        static member (=>=) ((source:RouteDef), (destination:(Message->'a))) = 
//            { source with Route = Process(RouteDef.convert destination) :: source.Route }


let processor m = m

let from (s:string) = Uri(s)


//  the first steps of our DSL
from("test") =>= processor =>= processor =>= processor 

