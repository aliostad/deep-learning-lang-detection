namespace Fazuki.Server

open System

module Handlers = 
    
    type Request<'req> = {
        Path : string
        Message : 'req
    }

    type Reply<'rep> = {
        Status : string
        Message : 'rep
    }

    type Handler<'req,'rep> = Request<'req> -> Reply<'rep>

    type internal UntypedHandler = Request<obj> -> Reply<obj>

    type internal Route<'req,'rep> = {
        Path : string
        RequestType : Type
        ReplyType : Type
        Handler : UntypedHandler
    }

//    let addRoute handler routes = 
//        let untypedHandler req =
//            let reqType = 
//            let typedReq = {
//                Path = req.Path
//                Message = req.Message :> obj
//            } 

        