namespace FsIntegrator

open System.IO
open System.Xml.XPath
open FsIntegrator
open FsIntegrator.Core
open FSharp.Data.UnitSystems.SI.UnitSymbols


    module FileConsumerDefaults =
        let afterSuccessDefault = NoFileScript
        let afterErrorDefault  = NoFileScript
        let endpointFailureStrategy = FileOption.EndpointFailureStrategy(WaitAndRetryInfinite(5.0<s>))
        let defaultConsumerOptions = [AfterSuccess(afterSuccessDefault); AfterError(afterErrorDefault); endpointFailureStrategy]

    module SubRouteConsumerDefaults =
        let defaultConsumerOptions = []

    module ConsumersInternal =
        let substituteAllXPath<'a when 'a : comparison> (map:Map<'a,string>) msg =
            let xpath = XPathDocument(new StringReader(msg)).CreateNavigator()
            map 
            |> Map.toSeq 
            |> Seq.map(fun (k, v) -> k, InternalUtility.substituteSingleXPath xpath v)
            |> Map.ofSeq


        let CallWithMapping mapper f (msg:FsIntegrator.Message) =
            let mapping = substituteAllXPath mapper msg.Body
            f mapping msg

        let CallWithMacroMapping (mapper:Map<'a, StringMacro>) f (msg:FsIntegrator.Message) =
            let mapping = 
                mapper
                |> Map.toSeq
                |> Seq.map(fun (k,v) -> k, v.Substitute msg)
                |> Map.ofSeq
            f mapping msg

        let CallAndReturnInput f m = f m ; m    // returns m


type To = struct end
type To with
    /// Store a message's body in a File
    static member File(path: string) =
        File(path, FileConsumerDefaults.defaultConsumerOptions) :> IConsumer
        
    /// Store a message's body in a File
    static member File(path : string, options) = 
        File(path, FileConsumerDefaults.defaultConsumerOptions @ options) :> IConsumer

    /// Store a message's body in a File
    static member File(path: StringMacro) =
        File(path, FileConsumerDefaults.defaultConsumerOptions) :> IConsumer
        
    /// Store a message's body in a File
    static member File(path : StringMacro, options) = 
        File(path, FileConsumerDefaults.defaultConsumerOptions @ options) :> IConsumer

    /// Send a message to an active subroute
    static member SubRoute(name : string) = 
        SubRoute(name, SubRouteConsumerDefaults.defaultConsumerOptions) :> IConsumer

    /// Send a message to an active subroute
    static member SubRoute(name : string, options) = 
        SubRoute(name, SubRouteConsumerDefaults.defaultConsumerOptions @ options) :> IConsumer

    /// Send a message to an active subroute
    static member SubRoute(name : StringMacro) = 
        SubRoute(name, SubRouteConsumerDefaults.defaultConsumerOptions) :> IConsumer

    /// Send a message to an active subroute
    static member SubRoute(name : StringMacro, options) = 
        SubRoute(name, SubRouteConsumerDefaults.defaultConsumerOptions @ options) :> IConsumer

    /// Process a Message with a custom function
    static member Process (func : Message -> unit) = 
        ProcessStep(ConsumersInternal.CallAndReturnInput func)

    /// Process a Message with a custom function
    static member Process (func : Message -> Message) = 
        ProcessStep(func)

    /// Process a Message with a custom function, using an XPath mapping
    static member Process<'a when 'a : comparison> (mapper : Map<'a, StringMacro>, func : Map<'a,string> -> Message -> Message) =
        ProcessStep(ConsumersInternal.CallWithMacroMapping mapper func)

    /// Process a Message with a custom function, using an XPath mapping
    static member Process<'a when 'a : comparison> (mapper : Map<'a, StringMacro>, func : Map<'a,string> -> Message -> unit) =
        ProcessStep(ConsumersInternal.CallAndReturnInput(ConsumersInternal.CallWithMacroMapping mapper func))

    /// Process a Message with a custom function, using an XPath mapping
    static member Process<'a when 'a : comparison> (mapper : Map<'a,string>, func : Map<'a,string> -> Message -> Message) =
        let macroMapper = mapper |> Map.toSeq |> Seq.map(fun (k,v) -> k, XPath(v)) |> Map.ofSeq
        To.Process(macroMapper, func)

    /// Process a Message with a custom function, using an XPath mapping
    static member Process<'a when 'a : comparison> (mapper : Map<'a,string>, func : Map<'a,string> -> Message -> unit) =
        let macroMapper = mapper |> Map.toSeq |> Seq.map(fun (k,v) -> k, XPath(v)) |> Map.ofSeq
        To.Process(macroMapper, func)

    /// Choose one of the routes, specified by its condition
    static member Choose (conditions : ConditionalRoute list) =
        DefinitionType.Choose(conditions)

