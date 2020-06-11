namespace Songbugs.Lib
open Microsoft.FSharp.Control
open Microsoft.Xna.Framework
open Microsoft.Xna.Framework.Input
open Songbugs.Lib.Event
open Songbugs.Lib.Input

type StateBasedGame() =
  inherit Game()
  
  let mutable screens : GameScreen [] = [||]
  let mutable currentScreenID = 0
  let screenChange = new Event<int>()
  
  member this.ScreenChange = screenChange.Publish
  
  abstract CurrentScreenID : int with get, set
  override this.CurrentScreenID
    with get () = currentScreenID
    and set v =
      currentScreenID <- v
      screenChange.Trigger v
  
  member this.Screens
    with get () = screens
    and set v = screens <- v
  
  member this.CurrentScreen
    with get () = this.Screens.[this.CurrentScreenID]
  
  override this.Initialize () =
    this.CurrentScreenID <- 0
    base.Initialize ()
  
and [<AbstractClass>] [<AllowNullLiteral>] GameScreen(game : StateBasedGame, screen) =
  inherit GameObject()
  
  let keyPress = new Event<Keys>()
  let keyDown = new Event<Keys>()
  let keyRelease = new Event<Keys>()
  let mousePress = new Event<MouseButtons>()
  let mouseDown = new Event<MouseButtons>()
  let mouseRelease = new Event<MouseButtons>()
  
  member this.KeyPress = keyPress.Publish
  member this.KeyDown = keyDown.Publish
  member this.KeyRelease = keyRelease.Publish
  member this.MousePress = mousePress.Publish
  member this.MouseDown = mouseDown.Publish
  member this.MouseRelease = mouseRelease.Publish
  
  override this.Initialize () =
    let createHandler trigger = new Handler<_>(fun sender args -> trigger args)
    let kpHandler, kdHandler, krHandler, mpHandler, mdHandler, mrHandler =
      createHandler keyPress.Trigger, createHandler keyDown.Trigger, createHandler keyRelease.Trigger,
      createHandler mousePress.Trigger, createHandler mouseDown.Trigger, createHandler mouseRelease.Trigger
    game.ScreenChange.Add (fun s ->
      if s = screen then
        EventManager.KeyPress.AddHandler kpHandler
        EventManager.KeyDown.AddHandler kdHandler
        EventManager.KeyRelease.AddHandler krHandler
        EventManager.MousePress.AddHandler mpHandler
        EventManager.MouseDown.AddHandler mdHandler
        EventManager.MouseRelease.AddHandler mrHandler
      else
        EventManager.KeyPress.RemoveHandler kpHandler
        EventManager.KeyDown.RemoveHandler kdHandler
        EventManager.KeyRelease.RemoveHandler krHandler
        EventManager.MousePress.RemoveHandler mpHandler
        EventManager.MouseDown.RemoveHandler mdHandler
        EventManager.MouseRelease.RemoveHandler mrHandler)
    ()
