namespace Aklefdal.Holidays.HttpApi.HttpHost

open System
open System.Web.Http
open System.Net.Http
open Aklefdal.Holidays.HttpApi.Infrastructure
open System.Threading;
open System.Threading.Tasks;

type HttpRouteDefaults = { Controller : string; Id : obj }

type SetResponseCacheHeadersHandler() =
    inherit DelegatingHandler()

    let getCacheControlHeader =
        let cacheControl = new Headers.CacheControlHeaderValue()
        cacheControl.Public <- true
        cacheControl.MaxAge <- new Nullable<TimeSpan>(TimeSpan.FromDays(30.0))
        cacheControl

    override this.SendAsync(request:HttpRequestMessage, cancellationToken:CancellationToken) = 
        base.SendAsync(request, cancellationToken)
            .ContinueWith(fun (t : Task<HttpResponseMessage>) -> 
                          let resp = t.Result
                          resp.Headers.CacheControl <- getCacheControlHeader
                          resp
                         )

type Global() =
    inherit System.Web.HttpApplication()
    member this.Application_Start (sender : obj) (e : EventArgs) =
        GlobalConfiguration.Configuration.Formatters.XmlFormatter.UseXmlSerializer <- true
        Configure GlobalConfiguration.Configuration
        GlobalConfiguration.Configuration.MessageHandlers.Add(new SetResponseCacheHeadersHandler());
        