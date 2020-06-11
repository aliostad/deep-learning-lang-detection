namespace FSharpWeb1.Areas.HelpPage.Controllers

open System
open System.Web.Http
open System.Web.Mvc
open FSharpWeb1.Areas.HelpPage.ModelDescriptions
open FSharpWeb1.Areas.HelpPage.Models

/// <summary>
/// The controller that will handle requests for the help page.
/// </summary>
type HelpController(config:HttpConfiguration) =
    inherit Controller()
    
    let ErrorViewName = "Error";

    member val Configuration = config with get

    new() = 
        new HelpController(GlobalConfiguration.Configuration)

    //member this.Index() =    
        //ViewBag.DocumentationProvider = Configuration.Services.GetDocumentationProvider()
        //this.View(Configuration.Services.GetApiExplorer().ApiDescriptions)
    
    //public ActionResult Api(string apiId)
    //{
    //    if (!String.IsNullOrEmpty(apiId))
    //    {
    //        HelpPageApiModel apiModel = Configuration.GetHelpPageApiModel(apiId);
    //        if (apiModel != null)
    //        {
    //            return View(apiModel);
    //        }
    //    }
    //
    //    return View(ErrorViewName);
    //}

    //public ActionResult ResourceModel(string modelName)
    //    if (!String.IsNullOrEmpty(modelName))
    //    {
    //        ModelDescriptionGenerator modelDescriptionGenerator = Configuration.GetModelDescriptionGenerator();
    //        ModelDescription modelDescription;
    //        if (modelDescriptionGenerator.GeneratedModels.TryGetValue(modelName, out modelDescription))
    //        {
    //            return View(modelDescription);
    //        }
    //    }
    //
    //    return View(ErrorViewName);
