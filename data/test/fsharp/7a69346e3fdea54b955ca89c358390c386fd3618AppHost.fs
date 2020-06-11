namespace Bendras.SocialMarket.Web.App

open System
open Microsoft.FSharp.Control
open ServiceStack.Common
open ServiceStack.ServiceInterface
open ServiceStack.ServiceHost
open ServiceStack.WebHost.Endpoints
open Funq
open Bendras.SocialMarket.Web.Services

//[<assembly: System.Runtime.Serialization.ContractNamespace("http://schemas.servicestack.net/types", ClrNamespace = "http://bendras")>]
//[<assembly: AssemblyVersionAttribute("1.0.0.0")>] 

///Define the Web Services AppHost
type AppHost() =
    inherit AppHostHttpListenerBase("Bendras.SocialMarket.Web.App", typeof<HelloService>.Assembly)
    let version = 0
    do
        ignore 0


    /// Configures the application.
    override this.Configure container = 
        this.Plugins.Add(new ServiceStack.Razor.RazorFormat());
        this.Config.DebugMode <- true;
        this.Config.WriteErrorsToResponse <- true;
        this.Container.DefaultReuse <- ReuseScope.Request

        //this.Container.RegisterAutoWired<Bendras.SocialMarket.Domain.ProfileService>() |> ignore

        //this.Config.GlobalHtmlErrorHttpHandler <- { new Support.IServiceStackHttpHandler with member self.ProcessRequest(httpReq, httpRes, operationName) = ignore 0 }
        this.ServiceExceptionHandler <- HandleServiceExceptionDelegate.Combine(this.ServiceExceptionHandler, new HandleServiceExceptionDelegate(this.HandleServiceException)) :?> HandleServiceExceptionDelegate
        this.ExceptionHandler <- HandleUncaughtExceptionDelegate.Combine(this.ExceptionHandler, new HandleUncaughtExceptionDelegate(this.HandleUncaughtException)) :?> HandleUncaughtExceptionDelegate

    member this.HandleUncaughtException httpRequest httpResponse message ex =
        httpResponse.StatusCode <- 500
        httpResponse.StatusDescription <- ex.Message
        if httpResponse.OutputStream.CanWrite then httpResponse.OutputStream.Write(ex.ToString())

    member this.HandleServiceException request ex = 
        DtoUtils.HandleException(this, request, ex)

