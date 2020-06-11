module Express

open Fable.Core
open Fable.Import

module Sugar =

    type SimpleHandler = express.Request -> express.Response -> unit

    let get (route: string) (handler: SimpleHandler) (app: express.Express) =
        app.get(U2.Case1 route, (fun req res _ ->
            handler req res
            |> box
        ))
        |> ignore
        app

    let post (route: string) (handler: SimpleHandler) (app: express.Express) =
        app.post(U2.Case1 route, (fun req res _ ->
            handler req res
            |> box
        ))
        |> ignore
        app

    type UseBuilder =
        | UseBuilder of express.Express with

            static member (^.) (UseBuilder app, (handler) : express.RequestHandler) =
                app.``use``(handler) |> ignore
                app

            static member (^.) (UseBuilder app, (path, handler) : string * express.RequestHandler)=
                app.``use``(path, handler) |> ignore
                app

    let inline ``use`` args (app: express.Express) = ((UseBuilder app) ^. args)


    module Response =

        let send body (res: express.Response) =
            res.send(body) |> ignore
