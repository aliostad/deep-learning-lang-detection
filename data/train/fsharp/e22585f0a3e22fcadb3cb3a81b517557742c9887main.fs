open Microsoft.AspNetCore.Hosting
open Microsoft.AspNetCore.Builder

[<EntryPoint>]
let main argv =
    WebHostBuilder()
        .UseKestrel()
        .Configure(fun app ->
            app.Run(fun ctx ->
                let req = ctx.Request
                let res = ctx.Response
                // echo headers
                for header in req.Headers do
                    res.Headers.Add(header)
                // echo body
                req.Body.CopyToAsync(res.Body)
            )
        )
        .Build()
        .Run()
    0