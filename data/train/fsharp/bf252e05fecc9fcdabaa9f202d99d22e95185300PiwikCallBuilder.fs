module PiwikCallBuilder

open PiwikApiParameter
open PiwikMethodDefs
open System

let start (uri:string) =
    if uri.Contains("?module=API") then raise(ParameterDuplicationException("module", "API")) 
    if(uri.EndsWith(@"/")) then
        String.Format(@"{0}?module=API", uri)
    else
        String.Format(@"{0}/?module=API", uri)

let startTracking (uri:string) =
    if uri.Contains("?module=API") then raise(ParameterDuplicationException("module", "API"))
    if uri.Contains("?rec=1") then raise(ParameterDuplicationException("rec", "1")) 
    if(uri.EndsWith(@"/")) then
        String.Format(@"{0}?rec=1&apiv=1&rand={1}", uri, DateTime.Now.ToString("YYYYMMddHHmmssFFF"))
    else
        String.Format(@"{0}/?rec=1&apiv=1&rand={1}", uri, DateTime.Now.ToString("YYYYMMddHHmmssFFF"))
    

let addAuth (token:string) (uri:string) = uri |> addParam (AuthToken token) 

let addLanguage (language:string) (uri:string) = uri |> addParam (Language language)

let addLable (lable:string) (uri:string) = uri |> addParam (Lable lable)

let addSite (sites:SiteId) (uri:string) = uri |> addParam sites

let addPeriod (pType:TimeSlice) (uri:string) = uri |> addParam pType
 
let addFormat (format:FormatType) (uri:string) = uri |> addParam format

let addMethod (methodName:PiwikMethodDefs.MethodType) (uri:string) = uri |> addParam methodName

let addSegment (segment:SegmentType) (uri:string) = uri |> addParam segment

let addFilter (filter:FilterType) (uri:string) = uri |> addParam filter

let addSort (sort:SortType) (uri:string) = uri |> addParam sort

let disableGenericFilters (uri:string) = addParameter ("disable_generic_filters","1") uri

let disableQueuedFilters (uri:string) = addParameter ("disable_queued_filters","1") uri

let addIdSubtable (id:int)(uri:string) = addParameter("idSubtable", id.ToString()) uri 

let addEnhanced (uri:string) = addParameter("enhanced", "true") uri 

 

let execute (apiCall:string) =
    let webCl = new System.Net.WebClient()
    webCl.DownloadString(apiCall)

let asyncExecuteRequest (apiCall:string) = 
    async{
            let webCl = new System.Net.WebClient()
            return! webCl.AsyncDownloadString(Uri(apiCall))
            }

let executeAsync (apiCall:string) s f =
    let task = asyncExecuteRequest apiCall
    Async.StartWithContinuations(task,s,f, fun _ -> ignore())