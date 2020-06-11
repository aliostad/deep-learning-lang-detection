namespace EasySales.Common.Infrastructure
open MediatR
open System.Threading.Tasks

type IQuery<'TResponse> =
    inherit IRequest<'TResponse>

type IPagedQuery<'TResponse> =
    inherit IQuery<'TResponse>
    abstract member Page: int with get
    abstract member Results: int with get
    abstract member OrderBy: string with get

type IQueryHandler<'TQuery, 'TResponse when 'TQuery :> IQuery<'TResponse>> =
    inherit IAsyncRequestHandler<'TQuery, 'TResponse>

type ICommand =
    inherit IRequest

type ICommandHandler<'TCommand when 'TCommand :> ICommand> =
    inherit IAsyncRequestHandler<'TCommand>

type IEvent =
    inherit INotification

type IEventHandler<'TEvent when 'TEvent :> IEvent> =
    inherit IAsyncNotificationHandler<'TEvent>

type IBus = 
    abstract member SendCommandAsync: #ICommand -> Task
    abstract member SendQueryAsync: #IQuery<'TResponse> -> Task<'TResponse>
    abstract member PublishEventAsync: #IEvent -> Task

type Bus(mediator: IMediator) = 
    interface IBus with
        member this.SendCommandAsync(command: #ICommand) = mediator.Send(command)
        member this.SendQueryAsync(query: #IQuery<'TResponse>) = mediator.Send(query)
        member this.PublishEventAsync(evt: #IEvent) = mediator.Publish(evt)