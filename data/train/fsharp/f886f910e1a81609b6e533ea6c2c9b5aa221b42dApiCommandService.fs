namespace XLCatlin.DataLab.XCBRA.DomainModel

open System


// ==========================
// Event sourcing
// ==========================

/// Commands and events are associated with a particular "event stream"
/// When reading or saving events, the stream must be specified.
/// Typically, there is one stream for each Aggregate, as well as 
/// other streams for other events.
/// We will assume that all event streams are identified by a string.
/// Example:
///  * A particular location -- "LocationId:A"
///  * Summary of all locations -- "LocationSummary"
///
/// IMPORTANT: Each event stream must be completely independent from the others.
type EventStreamId = EventStreamId of string

/// A stream has a monotonically increasing version which is changed
/// every time the stream is modified.
/// When saving an event, an expected stream version must be provided,
/// and if the version does match current version of the stream,
/// a VersionConflict error is returned.
type EventStreamVersion = 
    EventStreamVersion of int
    with 
        // First version -- used when you believe you are writing the first event
        static member First = EventStreamVersion 0 

/// Passed in to Write operation for concurrency
/// See http://docs.geteventstore.com/dotnet-api/3.0.1/optimistic-concurrency-and-idempotence/
type ExpectedVersion =
    /// The stream version must match the one passed in
    | Expected of EventStreamVersion 
    /// Any stream version is allowed
    | Any



// ==========================
// Commands
// ==========================

/// A union of all possible commands in the domain
type DomainCommand =
    | Location of LocationCommand
    | Warehouse of WarehouseCommand

/// uniquely identifies the command. Eg a Guid
type ApiCommandId = Guid

/// Everything needed for a API command
/// Authentication/Authorization is performed out-of-band.
type ApiCommand = {
    /// uniquely identifies the command
    commandId : ApiCommandId 
    /// For concurrency -- may be represented by ETag
    expectedVersion : ExpectedVersion 
    /// the actual domain-specific command
    domainCommand : DomainCommand
    }

// ==========================
// Errors
// ==========================

type ValidationError = {
    Field: string
    Error: string
    }
    
/// Errors associated with a bad ApiCommand execution
type ApiCommandError =
    /// 400: The data in the command is invalid, return a list of errors
    | ValidationError of string
    /// 400: The command cannot be executed correctly - e.g. deleting an non-existent object
    | ExecutionError of string
    /// 401: Credentials are bad
    | AuthenticationError of string
    /// 500: A server side error
    | ServerError of string

// ==========================
// CommandExecution service
// ==========================

/// The result of a ApiCommand execution 
type ApiCommandExecutionResult = Result<unit,ApiCommandError>

/// The public API for using commands
type IApiCommandExecutionService = 

    /// Execute a command
    abstract member Execute : ApiCommand -> Async<ApiCommandExecutionResult>

// ==========================
// CommandStatus service
// ==========================

type ApiCommandStatus = 
    /// The command succeeded. The associated aggregate has been updated
    | Success
    /// The command has not completed. Try again later
    | Pending
    /// The command failed. The error message is included.
    | Failure of string

/// The result of a status check
type ApiCommandStatusResult = Result<ApiCommandStatus,ApiCommandError>

/// The public API for getting command status
type IApiCommandStatusService = 

    /// Get the status of a previous command
    abstract member Status : ApiCommandId -> Async<ApiCommandStatusResult>


    

