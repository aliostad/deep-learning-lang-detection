namespace FsIntegrator

open System
    
type Error = struct end
    with
        /// Handles exceptions of given types, and diverts the message to another (sub) route. Never returns to the route causing the exception.
        static member Divert(handleTypes : Type list) = ErrorHandlerRoute.Create [] Divert handleTypes

        /// Handles exceptions of given types, and equips the error with specified logic. Any regular route is terminated.
        static member Equip(handleTypes : Type list) = ErrorHandlerRoute.Create [] Equip handleTypes

        /// Set the current Error Handler in a Route
        static member Handler(handlers : ErrorHandlerRoute list) = ErrorHandlers(handlers)
