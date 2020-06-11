#r """..\..\packages\FSharpx.Collections\lib\net40\FSharpx.Collections.dll"""
#load "Base\Equals.fs"
      "Base\Option.fs"
      "Base\Map.fs"
      "Base\Seq.fs"
      "Base\Base.fs"
      "Domain\Rule.fs"
      "Domain\Tabletop.fs"
      "Domain\Asker.fs"
      "Domain\Game.fs"
      "Impl\GameState.fs"
      "Impl\ImplTest.fs"
      "Impl\RulesImpl.fs"
      "Impl\GameLoop.fs"
      "UI\Display.fs"
      "UI\ConsoleUi.fs"
      "UI\Logging.fs"
    
let startGame() =
    let api = GameImpl.GameLoop.api 
    let loggedApi = Logging.Logger.injectLogging api
    ConsoleUi.ConsoleWarhammer.startGame loggedApi 
startGame()