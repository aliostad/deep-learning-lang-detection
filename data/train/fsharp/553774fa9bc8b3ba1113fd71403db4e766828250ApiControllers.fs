namespace FsWeb.Controllers

open WumpusWorld
open System.Web
open System.Web.Mvc
open System.Net.Http
open System.Web.Http
open System.Net
open System.Collections
open System.Collections.Specialized
open System.Collections.Generic
open System.Runtime.Serialization
open System.Data.Services.Common
open System.Security.Principal


[<DataContract>]
[<CLIMutable>]
type State = 
    { [<DataMember(Name = "Action Senses")>] ActionSenses : string
      [<DataMember(Name = "Cell Senses")>] CellSenses : string list
      [<DataMember(Name = "Actor State")>] ActorState : string
      [<DataMember(Name = "Score")>] Score : int }


type ApiIdentity() =
    let mutable name = ""
    member val ApiToken = "" with get,set
    member val UserId = "" with get,set
    interface IIdentity with 
        member this.Name =
            ""
        member this.AuthenticationType =
            ""
        member this.IsAuthenticated =
            true




type TokenValidationAttribute() =
    inherit System.Web.Http.Filters.ActionFilterAttribute()
    override x.OnActionExecuting actionContext =
        let mapOfNameValueCollection (collection : NameValueCollection) =
            (Map.empty, collection.AllKeys)
            ||> Array.fold (fun map key ->
                let value = collection.[key]
                Map.add key value map)
        let headerToken = actionContext.Request.Headers |> Seq.filter(fun h -> if h.Key = "x-wws-token" then true else false ) |> Seq.toArray
        let token = match headerToken with 
                            | h when h.Length = 1 ->  let kvp = h.GetValue(0) :?> KeyValuePair<string,IEnumerable<string>>
                                                      let item = Seq.head kvp.Value
                                                      Some(item)
                            | _ -> let q = mapOfNameValueCollection (HttpUtility.ParseQueryString(actionContext.Request.RequestUri.Query))
                                   q.TryFind("token") 
        match token with 
            | None -> actionContext.Response <- new System.Net.Http.HttpResponseMessage(System.Net.HttpStatusCode.Forbidden) 
            | Some t -> let op = Azure.findApiTokenOp t
                        let result = Azure.apitokensTable.Execute op
                        if result.Result = null then
                            actionContext.Response <- new System.Net.Http.HttpResponseMessage(System.Net.HttpStatusCode.Forbidden) 
                        else
                            let entity = result.Result :?> ApiToken
                            match entity.IsActive with                                            
                                | true -> let apiIdentity = new ApiIdentity()
                                          apiIdentity.ApiToken <-t 
                                          apiIdentity.UserId <- entity.UserId
                                          let gp = new GenericPrincipal(apiIdentity, [|""|])
                                          HttpContext.Current.User <- gp
                                          base.OnActionExecuting(actionContext)
                                          ()
                                | flase -> actionContext.Response <- new System.Net.Http.HttpResponseMessage(System.Net.HttpStatusCode.Forbidden)     
                        ()
        //
        ()
        
type MoveController() = 
    inherit ApiController()
    
    let moveActorAndSaveNewGameState boardId gameId id action cost = 
        async { 
            
            //let! retrievedResult = Azure.executeOn_gameStateTable (Azure.findGameStateOp boardId gameId id) 
            let! retrievedResult = Azure.awaitOp_GameStateTable (Azure.findGameStateOp boardId gameId id)
            let gameState = Helper.getGameState retrievedResult           
            
            return! match gameState with 
                            | Some(gameState) ->  async{     
                                                            let state,maze = gameState
                                                            let currentPos = Helper.getPosition state
                                                            let currentCellObj = Helper.getCellObject maze currentPos
                                                            let gameScore = Helper.getGameScore retrievedResult
                                                            if gameScore = 0 then
                                                                return!  async{ 
                                                                                return Some({ActionSenses = "Game Over"; CellSenses = []; ActorState = state.ToString(); Score = gameScore})
                                                                              }
                                                            else 
                                                                return! match currentCellObj with 
                                                                            | Pit | Wumpus -> async{ 
                                                                                            return Some({ActionSenses = "Dead"; CellSenses = []; ActorState = state.ToString(); Score = gameScore})
                                                                                        }
                                                                            | _ -> async{ 
                                                                                            let actionSense, newGameState, newMaze = Engine.move maze state action
                                                                                            let xPos, yPos,dir = Helper.getPositionWithDirection newGameState  
                                                                                            let cellSenses = Helper.getCellSense newMaze (xPos, yPos)                                                                                                             
                                                                                            let mapData = Helper.ser newMaze    
                                                                                            let newScore = max (gameScore - cost) 0
                                                                                            let gameStateOp = Azure.insertOrUpdateGameStateOp boardId gameId id xPos yPos dir newScore mapData  
                                                                                            
                                                                                            let! insertResutl = Azure.awaitOp_GameStateTable gameStateOp
                                                                                            let gameLogOp = Azure.insertGameLogOp boardId gameId id (action.ToString()) (newGameState.ToString())
                                                                                            let! interLogResult = Azure.awaitOp_GameLogTable gameLogOp
                                                                                            return  Some({ActionSenses = actionSense.ToString(); CellSenses = List.map (fun f -> f.ToString()) cellSenses; ActorState = newGameState.ToString(); Score = newScore})                                                                                                                                                               
                                                                                         }                                                            
                                                            }
                            | _ -> async{return None}                                                                   
        }
    [<TokenValidation>]
    [<HttpGet>]
    [<Route("api/board/{boardid}/game/{gameid}/forward")>]
    member x.Forward(boardid : string, gameid: string) =
        let apiIdentity = HttpContext.Current.User.Identity :?> ApiIdentity
        let id = (apiIdentity.UserId,apiIdentity.ApiToken)
        async { let! newState = moveActorAndSaveNewGameState boardid gameid id Forward 25
                return match newState with 
                                | Some state -> x.Request.CreateResponse<State>(HttpStatusCode.OK, state)
                                | None -> x.Request.CreateResponse(HttpStatusCode.BadRequest)

                } |> Async.StartAsTask
    
    [<TokenValidation>]
    [<HttpGet>]
    [<Route("api/board/{boardid}/game/{gameid}/left")>]
    member x.Left(boardid : string, gameid: string) = 
         let apiIdentity = HttpContext.Current.User.Identity :?> ApiIdentity
         let id = (apiIdentity.UserId,apiIdentity.ApiToken)
         async { let! newState = moveActorAndSaveNewGameState boardid gameid id Left 20
                 return match newState with 
                                | Some state -> x.Request.CreateResponse<State>(HttpStatusCode.OK, state)
                                | None -> x.Request.CreateResponse(HttpStatusCode.BadRequest)
                } |> Async.StartAsTask
    
    [<TokenValidation>]
    [<HttpGet>]
    [<Route("api/board/{boardid}/game/{gameid}/right")>]
    member x.Right(boardid : string, gameid: string) = 
        let apiIdentity = HttpContext.Current.User.Identity :?> ApiIdentity
        let id = (apiIdentity.UserId,apiIdentity.ApiToken)
        async { let!newState = moveActorAndSaveNewGameState boardid gameid id Right 20
                return match newState with 
                                | Some state -> x.Request.CreateResponse<State>(HttpStatusCode.OK, state)
                                | None -> x.Request.CreateResponse(HttpStatusCode.BadRequest)
                } |> Async.StartAsTask
    [<TokenValidation>]
    [<HttpGet>]
    [<Route("api/board/{boardid}/game/{gameid}/shoot")>]
    member x.Shoot(boardid : string, gameid: string) = 
         let apiIdentity = HttpContext.Current.User.Identity :?> ApiIdentity
         let id = (apiIdentity.UserId,apiIdentity.ApiToken)
         async { let!newState = moveActorAndSaveNewGameState boardid gameid id Shoot 100
                 return match newState with 
                                | Some state -> x.Request.CreateResponse<State>(HttpStatusCode.OK, state)
                                | None -> x.Request.CreateResponse(HttpStatusCode.BadRequest)
                } |> Async.StartAsTask
    [<TokenValidation>]
    [<HttpGet>]
    [<Route("api/board/{boardid}/game/{gameid}/grab")>]
    member x.Grab(boardid : string, gameid: string) = 
         let apiIdentity = HttpContext.Current.User.Identity :?> ApiIdentity
         let id = (apiIdentity.UserId,apiIdentity.ApiToken)
         async { let!newState = moveActorAndSaveNewGameState boardid gameid id Grab 200
                 return match newState with 
                                | Some state -> x.Request.CreateResponse<State>(HttpStatusCode.OK, state)
                                | None -> x.Request.CreateResponse(HttpStatusCode.BadRequest)
                } |> Async.StartAsTask



type GameController() = 
    inherit ApiController()
    let r = new System.Random()

    [<TokenValidation>]
    [<HttpGet>]
    [<Route("api/board/new/{size=10}/{pits=5}")>]
    member x.NewBoard(size:int, pits:int) =
        async {                  
                    
                    let nextId = r.Next(1, System.Int32.MaxValue).ToString()
                    let newMaze = Engine.createMaze size size
                    let newBoardId = nextId
                    let boardData = Helper.ser (newMaze pits)
                    let g = new Board()           
                    //let! insertOrReplaceResult = Azure.executeOn_boardTable (Azure.insertOrUpdateBoard newBoardId boardData size pits)
                    let! insertOrReplaceResult = Azure.awaitOp_BoardTable (Azure.insertOrUpdateBoard newBoardId boardData size pits)
                    return match insertOrReplaceResult with
                                    | null -> x.Request.CreateResponse(HttpStatusCode.BadRequest)
                                    | _ ->  x.Request.CreateResponse<string>(HttpStatusCode.OK, nextId)
                    
                   
        } |> Async.StartAsTask

    [<TokenValidation>]
    [<HttpGet>]
    [<Route("api/board/{boardid}/game/new")>]
    member x.NewGame(boardId:string) = 
        let apiIdentity = HttpContext.Current.User.Identity :?> ApiIdentity
        let id = (apiIdentity.UserId,apiIdentity.ApiToken)
        async { 
                
                let nextId = r.Next(1, System.Int32.MaxValue).ToString()
                let! retrieveGameBoardResult = Azure.awaitOp_BoardTable (Azure.findBoardOp boardId)            
                let board = Helper.getMazeFromTable retrieveGameBoardResult  
                return! match board with 
                                | Some b -> async {
                                                let mapData = Helper.ser b
                                                let initScore = b.Length * 100
                                                let! insertResutl = Azure.awaitOp_GameStateTable (Azure.insertOrUpdateGameStateOp boardId nextId id 0 0 "S" initScore mapData)   
                                                let gameLogOp = Azure.insertGameLogOp boardId nextId id "Init" ""
                                                let! interLogResult = Azure.awaitOp_GameLogTable gameLogOp
                                                return x.Request.CreateResponse<string>(HttpStatusCode.OK, nextId)
                                            }
                                | None ->  async {return x.Request.CreateResponse(HttpStatusCode.BadRequest)}
                 
           }
        |> Async.StartAsTask
    
    [<TokenValidation>]
    [<HttpGet>]
    [<Route("api/board/{boardid}/game/{gameid}/status")>]
    member x.Status(boardid : string, gameid: string) = 
        let apiIdentity = HttpContext.Current.User.Identity :?> ApiIdentity
        let id = (apiIdentity.UserId,apiIdentity.ApiToken)
        async { 
                
                let! retrievedResult = Azure.awaitOp_GameStateTable (Azure.findGameStateOp boardid gameid id)           
                let stateAndMaze = Helper.getGameState retrievedResult 
                let gameScore = Helper.getGameScore retrievedResult
                return match stateAndMaze with 
                                | Some(gameState)-> let state,maze = gameState
                                                    let xPos, yPos,dir = Helper.getPositionWithDirection state   
                                                             
                                                    let currentCellObj = Helper.getCellObject maze (xPos,yPos)
                                                    let returnState = match currentCellObj with 
                                                                    | Pit | Wumpus -> {ActionSenses = "Dead"; CellSenses = []; ActorState = state.ToString(); Score = gameScore}
                                                                    | _ -> let cellSenses = Helper.getCellSense (maze) (xPos, yPos)  
                                                                           {ActionSenses = ""; CellSenses = List.map (fun f -> f.ToString()) cellSenses; ActorState = state.ToString(); Score = gameScore}
                                                    x.Request.CreateResponse<State>(HttpStatusCode.OK, returnState)
                                |  _ -> x.Request.CreateResponse(HttpStatusCode.BadRequest)
        }
         |> Async.StartAsTask

     [<TokenValidation>]
     [<HttpGet>]
     [<Route("api/board/{boardid}/game/{gameid}/view")>]
     member x.GameBoard(boardid : string, gameid: string) = 
        let apiIdentity = HttpContext.Current.User.Identity :?> ApiIdentity
        let id = (apiIdentity.UserId,apiIdentity.ApiToken)
        async { 
            
            let! retrievedResult = Azure.awaitOp_GameStateTable (Azure.findGameStateOp boardid gameid id)           
            let stateAndMaze = Helper.getGameState retrievedResult 
            return match stateAndMaze with
                            | Some gameState -> 
                                           let state,maze = gameState
                                           let lenght = maze |> Array2D.length1  
                                           let view  = seq {  for i in 0..lenght - 1 do
                                                                yield seq { 
                                                                    for u in 0..lenght - 1 do
                                                                        let c, s = maze.[i, u]
                                                                        yield c.ToString() } }
                                                      

                                           x.Request.CreateResponse<seq<seq<string>>>(HttpStatusCode.OK, view)
                            | None -> x.Request.CreateResponse(HttpStatusCode.BadRequest)
                      

            
        } |> Async.StartAsTask

    [<TokenValidation>]
    [<HttpGet>]
    [<Route("api/board/{boardid}/view")>]
    member x.Board(boardid : string) = 
        async { 

            let! retrieveGameBoardResult = Azure.awaitOp_BoardTable (Azure.findBoardOp boardid)            
            let board = Helper.getMazeFromTable retrieveGameBoardResult      
            return match board with
                            | Some maze -> let lenght = maze |> Array2D.length1  
                                           let view  = seq {  for i in 0..lenght - 1 do
                                                                yield seq { 
                                                                    for u in 0..lenght - 1 do
                                                                        let c, s = maze.[i, u]
                                                                        yield c.ToString() } }
                                                      

                                           x.Request.CreateResponse<seq<seq<string>>>(HttpStatusCode.OK, view)
                            | None -> x.Request.CreateResponse(HttpStatusCode.BadRequest)
                      

            
        } |> Async.StartAsTask
