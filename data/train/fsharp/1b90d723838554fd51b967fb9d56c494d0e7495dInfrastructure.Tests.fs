namespace EasySales.Common.Tests

open System
open Expecto
open MediatR
open EasySales.Common.Infrastructure
open System.Collections.Generic
open System.Threading.Tasks
open System.Linq

module Infrastructure =

  type ServiceLocator() =
    let services = new Dictionary<Type, obj list>()

    member this.Register(typ: Type, implementations: obj list) =
      services.Add(typ, implementations) |> ignore
    
    member this.Get(typ: Type) = services.[typ]
  
  type Tasks(tasks: string list) =
    member this.TasksList = tasks

  type GetTasksNamesQuery(filter: string) =
    interface IQuery<string list>
    member this.Filter = filter

  type GetTasksNamesQueryHandler(tasks: Tasks) =  
    interface IQueryHandler<GetTasksNamesQuery, string list> with
      member this.Handle(query: GetTasksNamesQuery) =
        async {
          return tasks.TasksList |> List.filter(fun x -> x.ToLower().Contains(query.Filter.ToLower()))
        } |> Async.StartAsTask  

  let mediator = lazy (
    let queryHandler = GetTasksNamesQueryHandler(Tasks(["Test1"; "Test2"; "Nope"]))
    let serviceLocator = ServiceLocator()
    serviceLocator.Register(typeof<IQueryHandler<GetTasksNamesQuery, string list>>, [queryHandler])
    serviceLocator.Register(typeof<IAsyncRequestHandler<GetTasksNamesQuery, string list>>, [queryHandler])
    serviceLocator.Register(typeof<IPipelineBehavior<GetTasksNamesQuery, string list>>, [])
    serviceLocator.Register(typeof<IRequestHandler<GetTasksNamesQuery, string list>>, [])
    Mediator(SingleInstanceFactory(serviceLocator.Get >> List.head), MultiInstanceFactory(serviceLocator.Get >> List.toSeq))
  )

  [<Tests>]
  let tests =
    testList "Queries" [
      testCaseAsync "Given Registered IQueryHandler When Send Method I sBeing Called Then Returns ProperResult" <| async {
        let query = GetTasksNamesQuery("test")
        let! subject = mediator.Value.Send(query) |> Async.AwaitTask
        Expect.equal subject (["Test1"; "Test2"]) """subject should equal ["Test1"; "Test2"]""" 
      }
    ] 