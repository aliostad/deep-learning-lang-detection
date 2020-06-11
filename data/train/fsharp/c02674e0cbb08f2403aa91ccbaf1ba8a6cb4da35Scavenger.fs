namespace Ai

open System
open System.Text

open AiLib.Framework
open AiLib.Net
open AiLib.Net.Request
open AiLib.Net.Response

module Scavenger =
    type Msg =
        | GetMap

    type CellInterface =
        | Plain
        | Mud
        | Rock

    type Cell = 
        {   x: float;
            y: float;
            z: float;
            northInterface: CellInterface;
            southInterface: CellInterface;
            eastInterface: CellInterface;
            westInterface: CellInterface;
        }

    type Terrain = Cell[,]

    type Server(world:Terrain, encoding:Encoding) =
        let getWorldData() =
            world.ToString() |> encoding.GetBytes

        let handler: HttpHandler = fun req resp ->
            async {
                resp.ContentEncoding <- encoding
                match req with
                | Accepts [ PathEndsWith "/world" ] req ->
                    Respond resp [
                        RespContentType "text/plain";
                        RespBytes (getWorldData())
                    ]
                | _ ->
                    Respond resp [
                        RespExn (new Exception("BadRequest"))
                    ]
            }

        member this.Handler = handler