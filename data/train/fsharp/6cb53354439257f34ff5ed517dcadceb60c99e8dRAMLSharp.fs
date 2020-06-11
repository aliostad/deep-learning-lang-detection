namespace RAMLSharp

open System
open System.Collections.Generic
open System.IO
open System.Linq
open System.Web.Http
open System.Web.Http.Description
open RAMLSharp.Models
open RAMLSharp.Attributes
open RAMLSharp.Extensions

type RAMLMapper (description : IEnumerable<ApiDescription>) =
    let mutable _apiDescriptions = description
    do
        if _apiDescriptions = null then _apiDescriptions <- new List<ApiDescription>()
    
    /// <summary>
    /// This constructor is the main constructor to pass in your controller and find out about your Web API.
    /// </summary>
    /// <param name="controller">The controller that is hosting your API.</param>
    new (controller : ApiController) = 
        RAMLMapper(controller.Configuration.Services.GetApiExplorer().ApiDescriptions)

    /// <summary>
    /// This method takes a few more pieces not described in your API and adds them to the RAML output.
    /// </summary>
    /// <param name="baseUri">The base URL of your API.</param>
    /// <param name="title">The title or name of your API.</param>
    /// <param name="version">The version of your API.</param>
    /// <param name="defaultMediaTypes">The default media types that your API supports.  Ex: application/json or application/xml</param>
    /// <param name="description">What is the purpose of your API.</param>
    /// <returns></returns>
    member this.WebApiToRamlModel(baseUri : Uri, title : string, version : string, defaultMediaTypes : string, description : string) =
        let ramlModel = new RAMLModel(title ,baseUri, version, defaultMediaTypes, description, new List<RouteModel>())
        let filterSourceFromUri (x:ApiParameterDescription) = x.Source = ApiParameterSource.FromUri
        let filterSourceFromBody (x:ApiParameterDescription) = x.Source = ApiParameterSource.FromBody
        let filterNullParameterDescriptor (x:ApiParameterDescription) = x.ParameterDescriptor <> null
        let filterNullParameterType (x:ApiParameterDescription) = x.ParameterDescriptor.ParameterType <> null
        let filterForUriParameter (api:ApiDescription) (x:ApiParameterDescription) = api.Route.RouteTemplate.Contains(String.Format("{{{0}}}", x.ParameterDescriptor.ParameterName))

        let filterComplexTypes (apis) = apis 
                                        |> Seq.filter (fun (x:ApiParameterDescription) -> x.ParameterDescriptor.ParameterType.IsComplexModel())

        let filterNonComplexTypes (apis) = apis 
                                           |> Seq.filter (fun (x:ApiParameterDescription) -> not(x.ParameterDescriptor.ParameterType.IsComplexModel()))

        let filterForUri (apis) = apis
                                  |> Seq.filter filterSourceFromUri
                                  |> Seq.filter filterNullParameterDescriptor
                                  |> Seq.filter filterNullParameterType
        let filterForBody (apis) = apis
                                   |> Seq.filter filterSourceFromBody
                                   |> Seq.filter filterNullParameterDescriptor
                                   |> Seq.filter filterNullParameterType

        let GetHeaders (api:ApiDescription) = 
            match api.ActionDescriptor with
            | null -> new List<RequestHeaderModel>()
            | _    ->   let headerAttributes = api.ActionDescriptor.GetCustomAttributes<RequestHeadersAttribute>()
                        match headerAttributes with
                        | null -> new List<RequestHeaderModel>()
                        | x    -> x.Select( fun h -> 
                                                new RequestHeaderModel(h.Name, 
                                                                       h.Description, 
                                                                       h.Type, 
                                                                       h.IsRequired, 
                                                                       h.Example, 
                                                                       h.Minimum, 
                                                                       h.Maximum)).ToList()
                    
        let GetQueryParameters(api:ApiDescription) = 

            let mapParameters (props:System.Reflection.PropertyInfo[], isOptional, documentation, example) =
                props.Select(
                    fun q -> new RequestQueryParameterModel(q.Name, documentation, q.PropertyType, isOptional, example)
                )
            
            let results = new List<RequestQueryParameterModel>()

            api.ParameterDescriptions
            |> filterForUri
            |> filterComplexTypes
            |> Seq.filter (fun x -> not (filterForUriParameter api x))
            |> Seq.map( fun x -> (x.ParameterDescriptor.ParameterType.GetProperties(), 
                                  x.ParameterDescriptor.IsOptional, 
                                  x.Documentation, 
                                  match x.ParameterDescriptor.DefaultValue with | null -> "" | _ -> x.ParameterDescriptor.DefaultValue.ToString()) )
            |> Seq.map mapParameters
            |> Seq.iter results.AddRange
            
            api.ParameterDescriptions 
            |> filterForUri
            |> filterNonComplexTypes
            |> Seq.filter( fun x -> not (filterForUriParameter api x) ) 
            |> Seq.map ( fun x -> new RequestQueryParameterModel(x.Name, x.Documentation, x.ParameterDescriptor.ParameterType.GetForRealType(), x.ParameterDescriptor.IsOptional, match x.ParameterDescriptor.DefaultValue with | null -> "" | _ -> x.ParameterDescriptor.DefaultValue.ToString()))
            |> Seq.iter results.Add

            results

        let GetUriParameters(api:ApiDescription) = 

            let mapParameters (props:System.Reflection.PropertyInfo[], isOptional, documentation, example) =
                props.Select(
                    fun q -> new RequestUriParameterModel(q.Name, documentation, q.PropertyType, isOptional, example)
                )
            
            let results = new List<RequestUriParameterModel>()
            api.ParameterDescriptions
            |> filterForUri
            |> filterComplexTypes
            |> Seq.filter (filterForUriParameter api)
            |> Seq.map( fun x -> (x.ParameterDescriptor.ParameterType.GetProperties(), 
                                  x.ParameterDescriptor.IsOptional, 
                                  x.Documentation, 
                                  match x.ParameterDescriptor.DefaultValue with | null -> "" | _ -> x.ParameterDescriptor.DefaultValue.ToString()) )
            |> Seq.map mapParameters
            |> Seq.iter results.AddRange
            
            api.ParameterDescriptions
            |> filterForUri
            |> filterNonComplexTypes
            |> Seq.filter (filterForUriParameter api)
            |> Seq.map ( fun x -> new RequestUriParameterModel(x.Name, x.Documentation, x.ParameterDescriptor.ParameterType.GetForRealType(), x.ParameterDescriptor.IsOptional, match x.ParameterDescriptor.DefaultValue with | null -> "" | _ -> x.ParameterDescriptor.DefaultValue.ToString()))
            |> Seq.iter results.Add

            results
        
        let GetBodyParameters(api:ApiDescription) = 
            let mapParameters (props:System.Reflection.PropertyInfo[], isOptional, documentation, example) =
                props.Select(
                    fun q -> new RequestBodyParameterModel(q.Name, documentation, q.PropertyType, isOptional, example)
                )
            let results = new List<RequestBodyParameterModel>()
            api.ParameterDescriptions
            |> filterForBody
            |> filterComplexTypes
            |> Seq.map( fun x -> (x.ParameterDescriptor.ParameterType.GetProperties(), 
                                    x.ParameterDescriptor.IsOptional, 
                                    x.Documentation, 
                                    match x.ParameterDescriptor.DefaultValue with | null -> "" | _ -> x.ParameterDescriptor.DefaultValue.ToString()) )
            |> Seq.map mapParameters
            |> Seq.iter results.AddRange
            
            api.ParameterDescriptions
            |> filterForBody
            |> filterNonComplexTypes
            |> Seq.map ( fun x -> new RequestBodyParameterModel(x.Name, x.Documentation, x.ParameterDescriptor.ParameterType.GetForRealType(), x.ParameterDescriptor.IsOptional, match x.ParameterDescriptor.DefaultValue with | null -> "" | _ -> x.ParameterDescriptor.DefaultValue.ToString()))
            |> Seq.iter results.Add

            results

        let GetResponseBodies (api:ApiDescription) = 
            match api.ActionDescriptor with
            | null -> new List<ResponseModel>()
            | _ ->  let headerAttributes = api.ActionDescriptor.GetCustomAttributes<ResponseBodyAttribute>()
                    match headerAttributes with
                    | null -> new List<ResponseModel>()
                    | x    -> x.Select( fun h -> 
                                            new ResponseModel(h.StatusCode, 
                                                              h.ContentType, 
                                                              (match (File.Exists(h.Example)) with | true -> File.ReadAllText(h.Example) | false -> h.Example), 
                                                              h.Description, 
                                                              h.Schema)).ToList()               
        let mapApi (api:ApiDescription) = 
            let requestedContentType = match api.HttpMethod.Method.ToLower() with
                                       | "put"
                                       | "post" -> "application/x-www-form-urlencoded"
                                       | _      -> null
            
            new RouteModel(api.Route.RouteTemplate, 
                           api.HttpMethod.Method.ToLower(), 
                           api.Documentation,
                           GetHeaders(api), 
                           GetQueryParameters(api),
                           GetUriParameters(api),
                           GetBodyParameters(api),
                           GetResponseBodies(api),
                           requestedContentType)

        _apiDescriptions
        |> Seq.map mapApi
        |> Seq.iter ramlModel.Routes.Add       

        ramlModel
