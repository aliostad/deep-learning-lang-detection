
// toplevel interfaces (for F# and C#)

namespace FastCGI

open System

open SimpleConnection
open MultiplexingConnection
open ServerLoop


[<AutoOpen>]
module FSharpInterface =
   /// A server using non-multiplexing connections (one thread per connection).
   /// Takes a non-blocking handler function to execute for every request.
   /// This is the preferred function to use from F# programs.
   let serverLoop options handler = generalServerLoop SimpleConnection.Loop options handler

   /// A server using multiplexing connections (at least two threads per connection).
   /// Not recommended unless you actually use a web server that supports multiplexing.
   let multiplexingServerLoop options handler = generalServerLoop MultiplexingConnection.Loop options handler

   let convertBlockingHandler handler = fun request response -> async { return handler request response }

   /// Starts a server, accepting a blocking handler function; does not return.
   /// Useful if you don't want to/can't write async handlers.
   let startServer options handler = serverLoop options (convertBlockingHandler handler) |> Async.RunSynchronously

   /// Starts a server with a blocking handler and multiplexing connections; does not return.
   let startMultiplexingServer options handler = multiplexingServerLoop options (convertBlockingHandler handler) |> Async.RunSynchronously


//
//  C# interface
//

type RequestDelegate = delegate of Request * Response -> unit

type Server =
   /// <summary>Starts a non-multiplexing fastcgi server, executing 'handler' for every request.
   /// <para>Does not return.</para>
   /// <para>Accepts connections concurrently and uses 1 thread per connection, unless configured otherwise.</para>
   /// <para>See Options type for configuration.</para>
   /// </summary>
   static member Start(handler:RequestDelegate, config:Options) =
      FSharpInterface.serverLoop config
         (fun request response ->
            async {
               return handler.Invoke(request, response)
            }
         )
      |> Async.RunSynchronously

   /// <summary>Starts a multiplexing fastcgi server, executing 'handler' in a new worker thread for every request.
   /// <para>Does not return.</para>
   /// <para>Accepts connections concurrently and uses at least 2 threads per connection, unless configured otherwise.</para>
   /// <para>See Options type for configuration.</para>
   /// <para>Although no known web server implements fcgi multiplexing, using this method instead of 'Start' does improve performance
   /// in some scenarios.</para>
   /// </summary>
   static member StartMultiplexing(handler:RequestDelegate, config:Options) =
      FSharpInterface.multiplexingServerLoop config
         (fun request response ->
            async {
               return handler.Invoke(request, response)
            }
         )
      |> Async.RunSynchronously


// Make Option a bit more usable from C#
[<System.Runtime.CompilerServices.Extension>]
module OptionExt =
   [<System.Runtime.CompilerServices.Extension>]
   let GetValue (x:Option<'T>) = if x.IsSome then x.Value else raise (new InvalidOperationException())

   [<System.Runtime.CompilerServices.Extension>]
   let HasValue (x:Option<'T>) = x.IsSome

   [<System.Runtime.CompilerServices.Extension>]
   let GetValueOrDefault (x:Option<'T>) = if x.IsSome then x.Value else Unchecked.defaultof<'T>
