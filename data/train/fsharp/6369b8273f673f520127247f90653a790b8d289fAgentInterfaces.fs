
namespace NabfAgentLogic.AgentInterfaces
    open JSLibrary.IiLang;
    open JSLibrary.IiLang.DataContainers;
    open JSLibrary.Data.GenericEvents;
    open System;
    open NabfAgentLogic.AgentTypes

    

    type IAgentLogic = 
        abstract member SetGoal : Command -> unit
        abstract member HandlePercepts : IilPerceptCollection -> unit
        abstract member Close : unit -> unit
        [<CLIEvent>]
        abstract member SendAgentServerAction : IEvent<UnaryValueHandler<IilAction>, UnaryValueEvent<IilAction>>
        [<CLIEvent>]
        abstract member SendMarsServerAction : IEvent<UnaryValueHandler<IilAction>, UnaryValueEvent<IilAction>>
        [<CLIEvent>]
        abstract member EvaluationCompleted : IEvent<EventHandler, EventArgs>
        [<CLIEvent>]
        abstract member EvaluationStarted : IEvent<EventHandler, EventArgs>
        [<CLIEvent>]
        abstract member SimulationEnded : IEvent<EventHandler, EventArgs>
        
    
