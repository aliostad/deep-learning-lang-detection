(*
To use:

1) Make sure that SETUP.CMD has been run first before running this script
2) Get a "client_secret.json" file to access the calendar -- store file in current directory
   https://console.developers.google.com/flows/enableapi?apiid=calendar
3) Alter bottom of script to use "dumpEvents" or "saveEventsToJson" 

*)

// make sure that SETUP.CMD has been run
// need to copy all DLLs to the same location otherwise Google can't find Newtonsoft.Json
#r "bin/Google.Apis.Calendar.v3.dll"
#r "bin/Google.Apis.Auth.dll"
#r "bin/Google.Apis.Auth.PlatformServices.dll"
#r "bin/Google.Apis.dll"
#r "bin/Google.Apis.PlatformServices.dll"
#r "bin/Google.Apis.Core.dll"
#r "bin/Newtonsoft.Json.dll"

open System
open System.Collections.Generic
open System.IO
open System.Text
open System.Threading

open Google.Apis.Calendar.v3
open Google.Apis.Calendar.v3.Data

open Google.Apis.Auth.OAuth2
open Google.Apis.Services
open Google.Apis.Util.Store

// If modifying these scopes, delete your previously saved credentials
// at ~/.credentials/fsharpworks-calendar.json
let applicationName = "FSharpWorks Calendar Downloader"
let secretsFile = "client_secret.json"

let openService() : CalendarService =
    use stream = new FileStream(secretsFile, FileMode.Open, FileAccess.Read)
    let secrets = GoogleClientSecrets.Load(stream).Secrets
    let scopes : string[] = [| CalendarService.Scope.CalendarReadonly |]
    let credPath = System.Environment.GetFolderPath(System.Environment.SpecialFolder.Personal)
    let credPath = Path.Combine(credPath, ".credentials/fsharpworks-calendar.json")
    let fileDataStore = FileDataStore(credPath, true)
    let credentialAsync = 
        printfn "Credential file saved to: %s" credPath
        GoogleWebAuthorizationBroker.AuthorizeAsync(
            secrets,
            scopes,
            "user",
            CancellationToken.None,
            fileDataStore) |> Async.AwaitTask

    // Create Google Calendar API service.
    let service = async {
        let! credential = credentialAsync
        let initializer = BaseClientService.Initializer(HttpClientInitializer = credential, ApplicationName = applicationName)
        return new CalendarService(initializer)
    }
    service |> Async.RunSynchronously

let getCalendarEvents (service:CalendarService) calendarId : Event list=
    // Define parameters of request.
    let request = service.Events.List(calendarId)
    request.TimeMin <- Nullable DateTime.Now
    request.ShowDeleted <- Nullable false
    request.SingleEvents <- Nullable true
    request.MaxResults <- Nullable 10
    request.OrderBy <- Nullable EventsResource.ListRequest.OrderByEnum.StartTime

    // List events.
    request.Execute() 
    |> Option.ofObj 
    |> function 
        | Some events -> events.Items |> List.ofSeq
        | None -> []


/// An event suitable for showing on the FsharpWorks site calendar
type FsharpWorksEvent = {
    Summary : string
    Description : string
    Location : string
    EventPeriod: string // OneTime|OneDay|MultiDay
    StartDate : string
    StartTime : string
    EndDate : string
    }


/// Determine whether an event is on one day or multiple days
let (|OneTime|OneDay|MultiDay|) (calendarEvent:Event) =
    let dateStr (dt:DateTime) = dt.ToString("yyyy-MM-dd")
    if String.IsNullOrEmpty(calendarEvent.Start.Date) then
        let date,time = 
            match calendarEvent.Start.DateTime |> Option.ofNullable with
            | None -> "","" 
            | Some dt -> dateStr dt,dt.ToString("hh:mm")
        OneTime (date,time)
    else                     
        let startDate = DateTime.Parse(calendarEvent.Start.Date) |> dateStr
        let endDate = DateTime.Parse(calendarEvent.End.Date).AddDays(-1.) |> dateStr
        if startDate = endDate then
            OneDay startDate
        else
            MultiDay (startDate,endDate)                

/// Convert Google Calendar event to FsWorksEvent option
let toFsharpWorksEvent (calendarEvent:Event) :FsharpWorksEvent   =
    let (<||>) s1 s2 = if String.IsNullOrEmpty s1 then s2 else s1
    let event = {
        Summary = calendarEvent.Summary <||> ""
        Description = calendarEvent.Description <||> ""
        Location = calendarEvent.Location  <||> ""
        EventPeriod = ""
        StartDate = ""
        StartTime = ""
        EndDate = ""
    }
    match calendarEvent with
    | OneTime (startDt,startTime) ->
        {event with EventPeriod="OneTime"; StartDate=startDt; StartTime=startTime}
    | OneDay startDt ->
        {event with EventPeriod="OneDay"; StartDate = startDt}
    | MultiDay (startDt,endDt) ->
        {event with EventPeriod="MultiDay"; StartDate = startDt; EndDate = endDt}

let getFsharpWorksEvents calendarId =  
    use service = openService()
    calendarId
    |> getCalendarEvents service 
    |> List.map toFsharpWorksEvent

let saveEventsToJson(calendarId,filename) =
    let events = getFsharpWorksEvents calendarId |> List.toArray
    let json = Newtonsoft.Json.JsonConvert.SerializeObject(events) 
    System.IO.File.WriteAllText(filename,json)

let dumpEvents(calendarId) =
    let events = getFsharpWorksEvents calendarId 
    match events with
    | [] ->
        printfn "No Upcoming events"
    | events -> 
        printfn "Upcoming events:"
        for eventItem in events do
            printfn "%A" eventItem

// FIND YOUR GOOGLE CALENDAR ID
// see https://support.appmachine.com/hc/en-us/articles/203645966-Find-your-Google-Calendar-ID-for-the-Events-block
let fsworksCalendarId = "c3qj2paogqe15ce2d78isspjbg@group.calendar.google.com"
let primaryCalendarId = "primary"

dumpEvents(primaryCalendarId)
saveEventsToJson(primaryCalendarId,"PrimaryEvents.json")

dumpEvents(fsworksCalendarId)
saveEventsToJson(fsworksCalendarId,"FsharpWorksEvents.json")