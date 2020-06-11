namespace Fazuki.Server

open System
open System.Collections.Generic
open Fazuki.Common

type MessageStream = IObservable<string> 

type UntypedHandler = {
    Consume : obj -> obj;
    Id : byte[];
    Request : Type;
    Response : Type;
}

type Handler<'req, 'rep> = {
    Consume : 'req -> 'rep;
    Name : string;
}

type ReceiveSuccess = {EncodedRequest:byte[]}
type GetHandlerSuccess = {Handler:UntypedHandler; Body:byte[]}
type DeserializeSuccess = {Handler:UntypedHandler; Message:obj}
type ExecuteSuccess = {Handler:UntypedHandler; Response:obj}
type SerializeSuccess = {SerializedResponse:byte[]}
type SendSuccess = unit

type PipelineSuccess = 
    | ReceiveSuccess of ReceiveSuccess
    | GetHandlerSuccess of GetHandlerSuccess
    | DeserializeSuccess of DeserializeSuccess
    | ExecuteSuccess of ExecuteSuccess
    | SerializeSuccess of SerializeSuccess
    | SendSuccess of SendSuccess

type PipelineException = {
    PipelineInputs : PipelineSuccess list;
    Exception : Exception
}

type GetHandlerError = 
    | MessageEmpty
    | NoContent
    | NoMessageName
    | HandlerNotFound
    | Unknown of Exception

type ServerError = 
    | ReceiveError of Exception
    | GetHandlerError of GetHandlerError
    | DeserializeError of Exception
    | ExecuteError of Exception
    | SerializeError of Exception
    | SendError of Exception

type StepResult<'res> =
    | Success of 'res
    | Failed of ServerError

type PipelineOutput<'res> = {
    Id : Guid
    StepResult : StepResult<'res> 
}
  
type ReceiveResult = PipelineOutput<ReceiveSuccess>
type GetHandlerResult = PipelineOutput<GetHandlerSuccess>
type DeserializeResult = PipelineOutput<DeserializeSuccess>
type ExecuteResult = PipelineOutput<ExecuteSuccess>
type SerializeResult = PipelineOutput<SerializeSuccess>
type SendResult = PipelineOutput<SendSuccess>

(*
type PipelineResult = 
    | ReceiveResult of ReceiveResult
    | DecodeResult of DecodeResult
    | GetHandlerResult of GetHandlerResult
    | DeserializeResult of DeserializeResult
    | ExecuteResult of ExecuteResult
    | SerializeResult of SerializeResult
    | EncodeResult of EncodeResult
    | SendResult of SendResult
    *)
type Filter = 
    | ReceiveFilter of (ReceiveResult -> ReceiveResult)
    | GetHandlerFilter of (GetHandlerResult -> GetHandlerResult)
    | DeserializeFilter of (DeserializeResult -> DeserializeResult)
    | ExecuteFilter of (ExecuteResult -> ExecuteResult)
    | SerializeFilter of (SerializeResult -> SerializeResult)
    | SendFilter of (SendResult -> SendResult)

type MetaMessage = {
    MessageId : Guid
    Success : bool
    Error : ServerError
}

type ServerConfig = {
    Serializer : Serializer
    Handlers : UntypedHandler list 
    Port : int
    Filters : Filter list
}    
