[<AutoOpen>]
module Nini.Api

(*open Spec

[<RequireQualifiedAccess>]
module ApiPart =
  type SingleDocGen = (string * Spec.PathItem) -> (string * Spec.PathItem)
  let create (p: RequestProcessor<_>) (docGen: DocGen) : ApiPart<_> = {
    fn = p
    docGen = docGen }

  let simple (p: RequestProcessor<_>) (docGen: SingleDocGen) : ApiPart<_> =
    create p (List.map docGen)

  let filter (fn: HttpRequest -> HttpRequest option) (docGen: SingleDocGen) : ApiPart<unit> =
    let fn (req: HttpRequest) =
      match fn req with
      | None -> None
      | Some req -> Some (req, ())

    simple (RequestProcessor.sync fn) docGen

module ApiParts =
  let segment (path: string) : ApiPart<unit> =
    let pathStart = "/" + path
    let test (str: string) = str.StartsWith pathStart
    let trim (str: string) = str.Substring pathStart.Length

    let reqFn req =
      if test req.path then Some { req with pathBase = req.pathBase + pathStart; path = trim req.path }
      else None

    let docGen (path, spec) = pathStart + path, spec

    ApiPart.filter reqFn docGen

  let pathParam (separator: char) (param: Spec.Parameter -> Spec.Parameter) : ApiPart<string> =
    let param = param { name = null; location = Spec.ParameterLocation.Path; description = None; required = true }
    if param.name = null then failwith "Cannot have empty parameter name"
    if param.location <> Spec.ParameterLocation.Path then failwith "Cannot have path parameter with different type"
    if not param.required then failwith "Path parameters must have required = true"
    let reqFn req =
      let path = req.path
      if req.path.Length < 2 then None
      else
        let sepIndex =
          match path.IndexOf (separator, 1) with
          | -1 -> path.Length
          | i  -> i

        let value = path.Substring (1, sepIndex - 1)
        let req = { req with pathBase = req.pathBase + req.path.Substring (0, sepIndex); path = req.path.Substring sepIndex }
        Some (req, value)

    let docGen (path, spec: PathItem) =
      let path = sprintf "{%s}%s" param.name path
      let addParam = Option.map <| fun op -> { op with parameters = param :: op.parameters }
      let spec = {
        get = addParam spec.get
        put = addParam spec.put
        post = addParam spec.post
        delete = addParam spec.delete
        options = addParam spec.options
        head = addParam spec.head
        patch = addParam spec.patch }
      path, spec

    ApiPart.simple (RequestProcessor.sync reqFn) docGen

  let segmentParam (param: Parameter -> Parameter) : ApiPart<string> =
    pathParam '/' param


let ( >=> ) (l: ApiPart<'a>) (r: ApiPart<'b>) : ApiPart<'b> =
  let fn = RequestProcessor.bind (const' r.fn) l.fn
  let docGen = l.docGen << r.docGen
  ApiPart.create fn docGen
*)
