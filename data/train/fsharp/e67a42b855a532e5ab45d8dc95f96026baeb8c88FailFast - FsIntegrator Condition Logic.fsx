//  ============================================================================================================
//
//  This is to explore condition logic for the DSL.
//  These tests will be performed using a file listener (because its the easiest one)
//
//  Logs can be found under: ./src/TestScripts/logs/<scriptname>.log
//  
//  This scripts listens to folder: "../TestExamples/ConditionTestInbox"
//  You can use these test files: "/src/TestExamples/TestFiles/conditional-test-*.xml"
//  All output goes to the logfile..
//  
//  ============================================================================================================

#I __SOURCE_DIRECTORY__
#I ".." 
#I "../../packages" 
#r @"FsIntegrator.ActiveMQ/bin/Debug/Apache.NMS.dll"
#r @"FsIntegrator.ActiveMQ/bin/Debug/Apache.NMS.ActiveMQ.dll"
#r @"FsIntegrator.Core/bin/Debug/FsIntegrator.Core.dll"
#r @"FsIntegrator.ActiveMQ/bin/Debug/FsIntegrator.ActiveMQ.dll"
#r @"NLog/lib/net45/NLog.dll"

open System
open System.IO
open NLog
open FsIntegrator
open FsIntegrator.Core
open FsIntegrator.RouteEngine

//  Configure Nlog, logfile can be found under: ./src/TestScripts/logs/<scriptname>.log
#load "nlog.fsx"
NlogInit.With __SOURCE_DIRECTORY__ __SOURCE_FILE__

let logger = LogManager.GetLogger(__SOURCE_FILE__)

let fileListenerPath = Path.Combine( __SOURCE_DIRECTORY__, "../TestExamples/ConditionTestInbox")

//  Some condition tests, these may be used in a "When", see route below.
let c1 = Header("property") &= Header("property")
let c2 = Header("property") &= "test"
let c3 = Header("property").ToInt &= Int(11)
let c4 = Header("property").ToInt &= (12)
let c5 = Header("property").ToFloat &= Float(13.0)
let c6 = Header("property").ToInt &= 14
let c7 = Header("prop1").ToInt <&> XPath("//root/message").ToInt


//  XPath mappins
let typeMap = [("message-type", "//Message/Type")] |> Map.ofList     
let messageMap = [("message-content", "//Message/Content")] |> Map.ofList  


//  You can put part of a route into a value
let SetMessageType = 
    To.Process(typeMap, 
        fun mp m -> 
            logger.Debug(sprintf "SetMessageType: %s" mp.["message-type"])
            m.SetHeader("type", mp.["message-type"]))

//  And a value is reusable
let PrintMessageContent = 
    To.Process(messageMap, fun mp m -> logger.Debug(sprintf "%s" mp.["message-content"]))


//  This route listens for a file on a folder, and conditionally sends the message (=file content) to one of the conditional routes.
let Route1 = 
    From.File fileListenerPath 
        =>= SetMessageType
        =>= To.Choose [
                When(Header("type") &= "add")
                    =>= To.Process(fun m -> logger.Debug("Add Process"))
                    =>= PrintMessageContent
                When(Header("type") &= "delete") 
                    =>= To.Process(fun m -> logger.Debug("Delete Process"))
                    =>= PrintMessageContent
                When(Header("type") &= "update") 
                    =>= To.Process(fun m -> logger.Debug("Update Process"))
                    =>= PrintMessageContent
            ]
        =>= To.Process(fun m -> logger.Debug("After Choose"))


let id = Route1.Id

RegisterRoute Route1

RouteInfo() |> List.iter(fun e -> printfn "%A\t%A" e.Id e.RunningState)
StartRoute id
RouteInfo() |> List.iter(fun e -> printfn "%A\t%A" e.Id e.RunningState)

