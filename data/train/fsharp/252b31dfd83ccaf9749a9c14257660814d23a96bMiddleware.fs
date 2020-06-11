namespace Dale

module Middleware =
  open System.Net
  open System.Net.Http
  open FSharp.Data
  open Dale.Http

  type Middleware = Handler -> Handler

  let methodAllowed (inner :Handler) :Handler =
    (fun req ->
      match req.Method.ToString() with
        | "POST" -> inner req
        | _ -> new HttpResponseMessage(HttpStatusCode.MethodNotAllowed))

  let isValidation (inner :Handler) :Handler =
    (fun req ->
      match req.Headers.Contains "Webhook-ValidationCode" with
        | true -> new HttpResponseMessage(HttpStatusCode.OK)
        | false -> inner req)

  let isWellFormed (inner :Handler) :Handler =
    (fun req ->
      let body = req.Content.ReadAsStringAsync().Result
      let json = JsonValue.Parse body
      let valid =
        json.AsArray()
        |> Array.map (fun i ->
                        not (isNull (i.GetProperty("contentUri").AsString())))
        |> Array.reduce (&&)
      match valid with
        | true -> inner req
        | false -> new HttpResponseMessage(HttpStatusCode.BadRequest))


