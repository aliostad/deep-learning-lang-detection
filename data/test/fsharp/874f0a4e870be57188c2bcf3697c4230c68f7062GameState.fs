module GameState

open Microsoft.Xna.Framework.Input

type Health = int

type SpriteType =
| Player of Health
| Enemy of Health
| PlayerBullet 
| EnemyBullet

type GameState = 
    { sprites : Sprite list
      eventHandler : GameEventHandler }
and GameEventHandler = (GameEvent -> GameState -> GameState)
and Sprite = {
    spriteType : SpriteType
    x : int
    y : int
    width : int
    height : int
    texture : string
    eventHandler :  SpriteEventHandler }
and EventResult = (GameState -> GameState)
and SpriteEventHandler = (Sprite -> (GameEvent list) -> GameState -> EventResult)
and GameEvent =
    | Tick of float
    | KeyboardInput of (KeyboardState * KeyboardState)
    | Collision of Sprite