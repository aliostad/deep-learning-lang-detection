namespace FSharpWeb1.Areas.HelpPage

open System.Web.Http
open System.Web.Mvc

type RouteValues =
  { controller : string
    action : string
    apiId : UrlParameter }

//public class HelpPageAreaRegistration : AreaRegistration
type HelpPageAreaRegistration() =
  inherit AreaRegistration()

  override this.AreaName
    with get() = "HelpPage"

  override this.RegisterArea(context:AreaRegistrationContext) =
    context.MapRoute(
        "HelpPage_Default",
        "Help/{action}/{apiId}",
        { RouteValues.controller = "Help"; action = "Index"; apiId = UrlParameter.Optional }) |> ignore

    // Can't call this yet until the code has been ported
    //HelpPageConfig.Register(GlobalConfiguration.Configuration)
    ()
