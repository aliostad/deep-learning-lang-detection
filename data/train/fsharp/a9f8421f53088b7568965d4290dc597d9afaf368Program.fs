open System
open BoardState
open System.Threading
open Microsoft.Xna.Framework.Graphics
open Microsoft.Xna.Framework.Audio

let private gjGameId = 120704
let private gjPrivateKey = "NUNYA"

[<EntryPoint>]
let main argv = 
    GameJoltApi.initConfig gjGameId gjPrivateKey
    if argv.Length=2 then
        GameJoltApi.setUser argv.[0] argv.[1]
        GameJoltApi.authenticateUser() |> ignore
    else
        ()
    let game = new TJoFGDGame.TJoFGDGame<Assets.AssetId, AssetType.AssetType<Texture2D,SpriteFont,SoundEffect>>(1000, 720, Assets.loadAssets, Update.updateGame, Render.drawGame, Microsoft.Xna.Framework.Color.Black)
    game.Run()
    0
