namespace FsIntegrator


// Contains the Core consumers, reference "FsIntegrator.Core.dll" to use it.
type To = struct end
type To with
    /// Store a message's body in a File
    static member File : string -> IConsumer
        
    /// Store a message's body in a File
    static member File : string * FileOption list -> IConsumer

    /// Store a message's body in a File
    static member File : StringMacro -> IConsumer
        
    /// Store a message's body in a File
    static member File : StringMacro * FileOption list -> IConsumer

    /// Send a message to an active subroute
    static member SubRoute : name: string -> IConsumer 

    /// Send a message to an active subroute
    static member SubRoute : name: string * options : SubRouteOption list -> IConsumer 

    /// Send a message to an active subroute
    static member SubRoute : name: StringMacro -> IConsumer 

    /// Send a message to an active subroute
    static member SubRoute : name: StringMacro * options : SubRouteOption list -> IConsumer 

    /// Process a Message with a custom function
    static member Process : func : (Message -> unit) -> DefinitionType

    /// Process a Message with a custom function
    static member Process : func : (Message -> Message) -> DefinitionType

    /// Process a Message with a custom function, using an XPath mapping
    static member Process<'a when 'a : comparison> : mapper : Map<'a,string> * func : (Map<'a,string> -> Message -> Message) -> DefinitionType

    /// Process a Message with a custom function, using an XPath mapping
    static member Process<'a when 'a : comparison> : mapper : Map<'a,string> * func : (Map<'a,string> -> Message -> unit) -> DefinitionType

    /// Choose one of the routes, specified by its condition
    static member Choose : ConditionalRoute list -> DefinitionType

