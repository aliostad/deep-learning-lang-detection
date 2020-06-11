namespace XLCatlin.DataLab.XCBRA.CommandStatusStore

(*
Types and interfaces for the CommandStatusStore.

The CommandStatusStore will likely be implemented as a SQL database or Azure Tables or Redis cache.

*)

type ApiCommandId = XLCatlin.DataLab.XCBRA.DomainModel.ApiCommandId
type ApiCommandStatus = XLCatlin.DataLab.XCBRA.DomainModel.ApiCommandStatus

type CommandStatusStoreError =
    | NotFound
    | OtherError of string

type ICommandStatusStore = 
    abstract member GetCommandStatus : key:ApiCommandId -> Result<ApiCommandStatus,CommandStatusStoreError>
    abstract member SetCommandStatus : key:ApiCommandId * value:ApiCommandStatus -> Result<unit,CommandStatusStoreError>
