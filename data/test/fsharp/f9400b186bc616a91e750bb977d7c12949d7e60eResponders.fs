[<AutoOpen>]
module Trevor.Responders

open System.Text
open System.Net
open Trevor.Helpers

/// A listen responder that responds with the raw bytes of encoded text from a handler
module TextResponder =
    /// The signature of an asynchronous handler for TextResponder.respond
    type Handler = HttpListenerRequest -> HttpListenerResponse -> Async<string>

    /// The TextResponder custom state
    type T = {Handler: Handler}

    /// Returns a new responder with response handler
    let createResponder (handler:Handler) = {Handler=handler}

    /// Returns an asynchronous operation from responding to a request with a custom handler
    let respond (req:HttpListenerRequest) (res:HttpListenerResponse) {Handler=handler} =
        async { use output = res.OutputStream
                let! result = handler req res
                let data = Encoding.UTF8.GetBytes(result)
                do! awaitTask <| output.WriteAsync(data, 0, data.Length) }

    // TODO: if we add logging the listener function it self might require different setups and in that case
    //       it would make more sense to have a nice way of passing the responder to a created listener
    /// Starts a new listener using this responder with a handler
    let startListener (handler:Handler):Listener.T<_> =
        let listener = handler
                       |> createResponder
                       |> Listener.create
        listener |> Listener.listen respond
        listener
        