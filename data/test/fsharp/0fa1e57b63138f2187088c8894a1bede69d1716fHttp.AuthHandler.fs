namespace Fgox.Http

open System.Net.Http

type AuthHandler(secrets: Fgox.Config.Secrets, innerHandler) = 
  inherit DelegatingHandler(innerHandler)
  let productHeader =
    let assemblyName = System.Reflection.Assembly.GetExecutingAssembly().GetName()
    Headers.ProductInfoHeaderValue(assemblyName.Name, assemblyName.Version.ToString())

  member this.MySendAsync(req, token) = base.SendAsync(req, token) |> Async.AwaitTask

  override this.SendAsync(req, token) = Async.StartAsTask <| async {
      if req.Content.Headers.ContentType.MediaType <> "application/x-www-form-urlencoded" then
        return failwith "Fgox.Http.MtGoxAuthHandler only knows how to apply authentication to content type 'application/x-www-form-urlencoded'"
      else
        let! body = req.Content.ReadAsStringAsync() |> Async.AwaitTask
        let body = body + "&nonce=" + Fgox.Auth.getTonce().ToString()
        req.Headers.Add("Rest-Key", secrets.apikey)
        req.Headers.Add("Rest-Sign", Fgox.Auth.sign secrets body)
        req.Headers.UserAgent.Add(productHeader)
        req.Content <- new StringContent(body, System.Text.Encoding.UTF8, "application/x-www-form-urlencoded")
        let! response = this.MySendAsync(req, token)
        return response
    }

  static member MakeClient(secrets) = 
    new HttpClient(new AuthHandler(secrets, new HttpClientHandler()))

