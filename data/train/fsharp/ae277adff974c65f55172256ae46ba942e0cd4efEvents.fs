namespace Elements

module Events =

    open Microsoft.Xna.Framework
    open Microsoft.Xna.Framework.Input
    open Elements.Components
    open Prefabs

    type ClickHandler(id : string) =
        
        let id_ : string = id
        let onClickEvent_ = new Event<_>()

        do 
            Event.add  (fun s -> ()) onClickEvent_.Publish

        member this.OnClick(arg) =
            onClickEvent_.Trigger(arg)

        interface IGameComponent with
            member this.Update (gameTime : GameTime) = ()
            member this.Id = id_
            member this.Type = "EventHandler"
        end

    
    type MouseCollisionHandler(id : string, bounds : Rectangle,
                               success_fn, failure_fn) =
        
        let id_ : string = id

        interface IGameHandler with
            member this.Handle =
                let mouseState = Mouse.GetState()
                let collided = bounds.Contains(mouseState.X, mouseState.Y)
                in match collided with 
                    | true ->  success_fn()
                    | false -> failure_fn()
        end

        interface IGameComponent with
            member this.Update (gameTime : GameTime) = (this :> IGameHandler).Handle
            member this.Id = id_
            member this.Type = "EventHandler"
        end