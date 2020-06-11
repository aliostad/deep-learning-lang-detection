namespace ODataClient
open Types
open Microsoft.Data.OData
open Microsoft.Data.Edm
open System.Collections.Generic
open System.IO
open System.Net
open System
module Facade=
  type ObjectProperty={Name:string;Value:obj}
  type ObjectInfo={ObjectType:string;Properties:ObjectProperty list}

  type ParserSettings<'TOutput,'TInput,'TMetadata>( ResponseHandler:Func<Stream,'TOutput seq>,
                                                    WebExceptionHandler:Action<WebException>,
                                                    FatalExceptionHandler:Action<Exception>,
                                                    InputEntryHandler:Func<'TInput,ODataEntry>,
                                                    MetadataHandler:Func<IEdmModel,'TMetadata seq> )=
       let getFunc (func:Func<'a,'b>)= fun x-> func.Invoke(x) 
       let getAction (func:Action<'a>)=fun x-> func.Invoke(x) 
                                                     
       member this.ResponseHandler with get()=(fun (r:HttpWebResponse)->r.GetResponseStream() |> (getFunc ResponseHandler))
       member this.WebExceptionHandler with get()=getAction WebExceptionHandler
       member this.FatalExceptionHandler with get()=getAction FatalExceptionHandler
       member this.InputEntryHandler with get()=getFunc InputEntryHandler
       member this.MetadataHandler with get()=getFunc MetadataHandler
  type Key={Name:string;Value:obj}
  type PullSettings={Collection:string;Filter:string;Skip:string;Top:string}

  type IODataClient<'TOutput,'TInput,'TMetadata>=
      abstract member Read:Key->'TOutput
      abstract member List:unit->seq<'TOutput>
      abstract member GetMetadata:unit->seq<'TMetadata>
      abstract member ClearMetadata:unit->unit
      abstract member Update :'TInput->unit


  type private ODataClient<'TOutput,'TInput,'TMetadata>(settings:ODataSettings,parserSettings:ParserSettings<'TOutput,'TInput,'TMetadata>)=
    
    let applyFunctors x = x parserSettings.InputEntryHandler  parserSettings.WebExceptionHandler parserSettings.FatalExceptionHandler 
    let get uriBuilder=OData.Get settings uriBuilder |> (fun x-> x parserSettings.FatalExceptionHandler  parserSettings.WebExceptionHandler parserSettings.ResponseHandler  ) 
    let post uriBuilder=OData.Post settings uriBuilder |> applyFunctors
    let put uriBuilder=OData.Put settings uriBuilder |> applyFunctors
    let patch uriBuilder=OData.Patch  uriBuilder settings  |> applyFunctors





  let CreateClient<'TOutput,'TInput,'TMetadata> settings parserSettings=ODataClient(settings,parserSettings):>IODataClient<'TOutput,'TInput,'TMetadata>

