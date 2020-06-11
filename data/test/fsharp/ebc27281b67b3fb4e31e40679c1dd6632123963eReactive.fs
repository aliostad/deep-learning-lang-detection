namespace ReactiveGameEngine.Reactive

open Microsoft.Xna.Framework.Graphics
open System.Reactive.Subjects
open System.Reactive.Linq
open ReactiveGameEngine
open System
open Microsoft.Xna.Framework

type ActorContext =
    { Path : string }

type ReactorConfiguration<'message, 'state> =
    { MessageHandler : ('state*ActorContext) -> 'message -> 'state
      Renderer : SpriteBatch -> GameTime -> 'state -> unit
      Path : string option
      DefaultState : 'state option }

type ReactorHandlerBuilder () =
    member this.Zero () =
        { MessageHandler = (fun (a,_) _ -> a); Renderer = (fun _ _ _ -> ()); Path = None; DefaultState = None; }

    member this.Yield (()) = this.Zero ()

    [<CustomOperation("messageHandler", MaintainsVariableSpace = true)>]
    member this.MessageHandler(ctx:ReactorConfiguration<_,_>, messageHandler) =
        { ctx with MessageHandler = messageHandler }

    [<CustomOperation("renderer", MaintainsVariableSpace = true)>]
    member this.Renderer(ctx:ReactorConfiguration<_,_>, renderer) =
        { ctx with Renderer = renderer }

    [<CustomOperation("path", MaintainsVariableSpace = true)>]
    member this.Name(ctx:ReactorConfiguration<_,_>, path) =
        { ctx with Path = Some(path) }

    [<CustomOperation("defaultState", MaintainsVariableSpace = true)>]
    member this.DefaultState(ctx:ReactorConfiguration<_,_>, defaultState) =
        { ctx with DefaultState = Some(defaultState) }

type IActor =
    abstract PostMessage : obj -> unit
    abstract Render : GameTime * SpriteBatch -> unit
    abstract State : obj with get

type IActor<'message, 'state> =
    abstract PostMessage : 'message -> unit
    abstract Render : GameTime * SpriteBatch -> unit
    abstract State : 'state with get

type InternalReactorRef<'message, 'state> (messageHandler:(('state * ActorContext) -> 'message -> 'state), renderer:SpriteBatch -> GameTime -> 'state -> unit, defaultState : 'state, path:string) as this =
    let context : ActorContext = { Path = path }
    let messagePump = new Subject<'message>()
    let observable = messagePump |> Observable.scan (fun s t -> let s' = messageHandler s t
                                                                s', context) (defaultState, context)
    let mostRecent = observable.MostRecent((defaultState, context))
    let enumerator = mostRecent.GetEnumerator ()

    let state () = enumerator.MoveNext () |> ignore
                   enumerator.Current

    interface IActor with
        member this.Render(gameTime, spriteBatch) =
            (this :> IActor<'message, 'state>).Render(gameTime, spriteBatch)

        member this.PostMessage(message) =
            let msg = unbox<'message> message
            (this :> IActor<'message, 'state>).PostMessage(msg)

        member this.State with get () = state () |> box

    interface IActor<'message, 'state> with
        member this.Render(gameTime, spriteBatch) =
            let s, _ = state ()
            renderer spriteBatch gameTime s

        member this.PostMessage(message) =
            messagePump.OnNext(message)

        member this.State with get () = fst <| state ()
    
type ReactorHost() =
    let mutable trie = Trie.Node(None, Map.empty)
    let syncObj = new Object()

    static let instance = new ReactorHost ()

    member __.Add(key, messageHandler, renderer, defaultState) =
        let irr = InternalReactorRef(messageHandler, renderer, defaultState, key) :> IActor
        lock syncObj (fun _ -> let trie' = Trie.add [Key(key)] irr trie
                               trie <- trie')

    member __.Add(key, actor:IActor) =
        lock syncObj (fun _ -> let trie' = Trie.add [Key(key)] actor trie
                               trie <- trie')

    member __.Remove(key) =
        let key = if key = "*" then Wildcard else Key(key)
        lock syncObj (fun _ -> let trie' = Trie.remove [key] trie
                               trie <- trie')

    member __.Get(key) =
        let k = if key = "*" then Wildcard else Key(key)
        Trie.resolve([k]) trie

    member this.Entities with get () = Trie.values trie

    static member Instance with get () = instance

exception NoDefaultStateProvided
exception NoPathProvided

[<AutoOpen>]
module Assorted =
    let inline post path message =
        let actors = ReactorHost.Instance.Get(path)
        actors |> List.iter (fun t -> t.PostMessage(message))

    let inline (!!) path =
        ReactorHost.Instance.Get(path)

    let inline (<!) path message =
        post path message

    let spawn reactorConfig =
        if reactorConfig.DefaultState.IsNone then raise NoDefaultStateProvided
        if reactorConfig.Path.IsNone then raise NoPathProvided
        let irr = new InternalReactorRef<_,_>(reactorConfig.MessageHandler, reactorConfig.Renderer, reactorConfig.DefaultState.Value, reactorConfig.Path.Value)
        ReactorHost.Instance.Add(reactorConfig.Path.Value, irr)
        ()

    let schedule millis_delay targetPath message =
        async {
            do! Async.Sleep millis_delay
            targetPath <! message
        } |> Async.Start

    let reactor = new ReactorHandlerBuilder ()
