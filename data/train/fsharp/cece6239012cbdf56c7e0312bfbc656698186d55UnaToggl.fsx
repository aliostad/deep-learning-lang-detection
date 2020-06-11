#r "packages/Newtonsoft.Json.4.0.8/lib/net40/Newtonsoft.Json.dll"
#r "packages/Selenium.WebDriver.3.4.0/lib/net40/WebDriver.dll"
#r "packages/Selenium.Support.3.4.0/lib/net40/WebDriver.Support.dll"
#r "packages/TogglAPI.Net.0.2/lib/net40/Toggl.dll"

open OpenQA.Selenium
open OpenQA.Selenium.Support.UI
open OpenQA.Selenium.PhantomJS
open Toggl
open Toggl.QueryObjects
open Newtonsoft.Json
open System
open System.IO
open System.Collections.Generic
open System.Threading
open System.Text.RegularExpressions

module DaysHelper =
    type Double with
        member this.Days = TimeSpan.FromDays this
        member this.Day = this.Days
    type Single with
        member this.Days = (float this).Days
        member this.Day = this.Days
    type Int32 with
        member this.Days = (float this).Days
        member this.Day = this.Days
    type Int64 with
        member this.Days = (float this).Days
        member this.Day = this.Days

open DaysHelper

let config =
    File.ReadAllText ((Environment.GetEnvironmentVariable "HOME") + "/.unaphy")
    |> JsonConvert.DeserializeObject<Dictionary<string, string>>

// Authentication
let unanetUsername = config.["UNANET_USERNAME"]
let unanetPassword = config.["UNANET_PASSWORD"]
let togglKey = config.["TOGGL_KEY"]

config.Remove "UNANET_USERNAME"
config.Remove "UNANET_PASSWORD"
config.Remove "TOGGL_KEY"

// Selenium config
let unanetLoginUrl = config.["UNANET_LOGIN_URL"]
let unanetTimesheetListUrl = config.["UNANET_TIMESHEET_LIST_URL"]

config.Remove "UNANET_LOGIN_URL"
config.Remove "UNANET_TIMESHEET_LIST_URL"

// Project mapping
type UnanetProject = | UnanetProject of string
type TogglProject = | TogglProject of int64

let unanetToTogglProjectMap : Map<UnanetProject, TogglProject> =
    config
    |> Seq.map (fun (KeyValue (unanetProject, togglProject)) ->
        (UnanetProject unanetProject, TogglProject (int64 togglProject))
    )
    |> Map.ofSeq


let phantomJSDir = "/usr/local/bin"
let commandTimeout = TimeSpan.FromSeconds 8.0
let ajaxWait = TimeSpan.FromSeconds 0.0
let implicitWait = TimeSpan.FromSeconds 1.0
let pageLoadWait = TimeSpan.FromSeconds 8.0

// Models
type DailyTimeEntry = {
    Day : DateTime
    Minutes : int
}

type TimeRangeTimeEntry = {
    StartTime : DateTime
    EndTime : DateTime
}

type UnanetTimesheet = {
    StartDate : DateTime
    EndDate : DateTime
    UnanetProjectTimeEntries : Map<UnanetProject, DailyTimeEntry list>
}

type TogglTimesheet = {
    StartDate : DateTime
    EndDate : DateTime
    TogglProjectTimeEntries : Map<TogglProject, TimeRangeTimeEntry list>
}

type MatchedUpProjectTimesheet = {
    UnanetProject : UnanetProject
    TogglProject : TogglProject
    TogglTimeEntries : TimeRangeTimeEntry list
    UnanetTimeEntries : DailyTimeEntry list
}

type MatchedUpTimesheet = {
    StartDate : DateTime
    EndDate : DateTime
    MatchedUpProjectTimesheets : MatchedUpProjectTimesheet list
}

let driver : IWebDriver = new PhantomJSDriver (phantomJSDir, PhantomJSOptions (), commandTimeout ) :> _
let driverTimeouts = (driver.Manage ()).Timeouts ()
driverTimeouts.AsynchronousJavaScript <- ajaxWait
driverTimeouts.ImplicitWait <- implicitWait
driverTimeouts.PageLoad <- pageLoadWait

try
    let tryFind selector =
        try
            Some (driver.FindElement (By.CssSelector selector))
        with
        | _ ->
            None

    let find selector =
        try
            driver.FindElement (By.CssSelector selector)
        with
        | e ->
            invalidOp (sprintf "Could not find %s:\n%s\n%s" selector (e.ToString ()) driver.PageSource)

    let findIn selector (element : IWebElement) =
        try
            element.FindElement (By.CssSelector selector)
        with
        | e ->
            invalidOp (sprintf "Could not find %s:\n%s\n%s" selector (e.ToString ()) element.Text)

    let findAll selector =
        driver.FindElements (By.CssSelector selector) |> Seq.toList

    let findAllIn selector (element : IWebElement) =
        element.FindElements (By.CssSelector selector) |> Seq.toList

    let navigator = driver.Navigate ()

    let isOnTimesheetListPage () =
        driver.Url = unanetTimesheetListUrl

    let checkForError () =
        match tryFind ".error" with
        | Some error ->
            invalidOp error.Text
        | None ->
            ()

    let loginToUnanet username password =
        do
            navigator.GoToUrl unanetLoginUrl

            let usernameInput = find "#username"
            let passwordInput = find "#password"
            let loginButton = find "#button_ok"

            usernameInput.SendKeys unanetUsername
            passwordInput.SendKeys unanetPassword
            loginButton.Click ()

            checkForError ()

    let onlyActiveVisibleUnanetTimesheetTr () =
        if isOnTimesheetListPage () then
            checkForError ()
        else
            navigator.GoToUrl unanetTimesheetListUrl

        let timesheetListBody = find "#active-timesheet-list tbody"
        let timesheetTrs = timesheetListBody |> findAllIn "tr"

        printfn "Timesheets:"
        for tr in timesheetTrs do
            printfn "%s" tr.Text

        let activeTimesheetTrs = timesheetTrs |> List.filter (fun tr -> tr.Text.Contains "INUSE")

        printfn "Active Timesheets:"
        for tr in activeTimesheetTrs do
            printfn "%s" tr.Text

        assert (activeTimesheetTrs.Length = 1)

        activeTimesheetTrs |> List.item 0

    let goToActiveUnanetTimesheet () =
        let activeTimesheetTr = onlyActiveVisibleUnanetTimesheetTr ()
        let activeTimesheetEditButton = activeTimesheetTr |> findAllIn "a" |> List.item 1

        assert ((activeTimesheetEditButton.GetAttribute "title").Contains "Edit")

        activeTimesheetEditButton.Click ()

        checkForError ()

    let dayRange (startDate : DateTime) (endDate : DateTime) =
        let mutable range = []
        let mutable currentDate = endDate
        while currentDate >= startDate do
            range <- currentDate :: range
            currentDate <- currentDate.AddDays -1.0
        range

    let getUnanetTimesheet () =
        loginToUnanet unanetUsername unanetPassword
        goToActiveUnanetTimesheet ()

        let startDate, endDate =
            let titleSubsectionText = (find "#title-subsection").Text
            let timesheetDateTextMatch = Regex.Match (titleSubsectionText, @"\((\S+) - (\S+)\)")

            assert (timesheetDateTextMatch.Success)
            assert (timesheetDateTextMatch.Groups.Count = 3)

            let startText = timesheetDateTextMatch.Groups.[1].Value
            let endText = timesheetDateTextMatch.Groups.[2].Value

            let startDate = DateTime.Parse startText
            let endDate = DateTime.Parse endText
            startDate, endDate

        let timesheetRange = dayRange startDate endDate

        let projectTimesheets =
            let projectTimesheetRows = findAll "#timesheet tbody tr[title]"

            projectTimesheetRows
            |> List.map (fun projectTimesheetRow ->
                let project = projectTimesheetRow.GetAttribute "title"

                let projectTimeEntryInputs =
                    projectTimesheetRow
                    |> findAllIn ".weekend-hours input,.weekday-hours input"

                let dailyTimeEntries =
                    List.zip timesheetRange projectTimeEntryInputs
                    |> List.map (fun (day, hoursInput) ->
                        try
                            let hoursText = hoursInput.GetAttribute "value"
                            let hours = float hoursText
                            let minutes = int (hours * 60.0)
                            Some { Day = day; Minutes = minutes }
                        with | :? FormatException ->
                            None
                    )
                    |> List.filter Option.isSome
                    |> List.map Option.get

                UnanetProject project, dailyTimeEntries
            )
            |> Map.ofList
        { StartDate = startDate; EndDate = endDate; UnanetProjectTimeEntries = projectTimesheets } : UnanetTimesheet

    let unanetTimesheet = getUnanetTimesheet ()

    let toggl = Toggl togglKey

    let getTogglTimesheet startDate endDate =
        let projectTimesheets =
            let queryParams =
                TimeEntryParams (
                    StartDate = Nullable startDate,
                    EndDate = Nullable (endDate + (1).Day)
                )
            let timeEntries = toggl.TimeEntry.List queryParams |> List.ofSeq
            timeEntries
            |> List.filter (fun timeEntry ->
                timeEntry.ProjectId.HasValue
            )
            |> List.groupBy (fun timeEntry ->
                TogglProject timeEntry.ProjectId.Value
            )
            |> List.map (fun (project, timeEntries) ->
                let timeRangeTimeEntries =
                    timeEntries
                    |> List.map (fun timeEntry ->
                        let startTime = (DateTime.Parse timeEntry.Start).ToLocalTime ()
                        let endTime = (DateTime.Parse timeEntry.Stop).ToLocalTime ()
                        { StartTime = startTime; EndTime = endTime } : TimeRangeTimeEntry
                    )
                project, timeRangeTimeEntries
            )
            |> Map.ofList
        { StartDate = startDate; EndDate = endDate; TogglProjectTimeEntries = projectTimesheets } : TogglTimesheet

    let togglTimesheet = getTogglTimesheet unanetTimesheet.StartDate unanetTimesheet.EndDate

    printfn "Toggl time entries:\n%A" togglTimesheet

    let matchUpTimesheets (unanetTimesheet : UnanetTimesheet) (togglTimesheet : TogglTimesheet) =
        let matchedUpProjectTimesheets =
            unanetTimesheet.UnanetProjectTimeEntries
            |> Seq.map (fun keyValuePair ->
                let unanetProject, unanetTimeEntries = keyValuePair.Key, keyValuePair.Value
                match unanetToTogglProjectMap |> Map.tryFind unanetProject with
                | Some togglProject ->
                    match togglTimesheet.TogglProjectTimeEntries |> Map.tryFind togglProject with
                    | Some togglTimeEntries ->
                        Some {
                            UnanetProject = unanetProject
                            TogglProject = togglProject
                            UnanetTimeEntries = unanetTimeEntries
                            TogglTimeEntries = togglTimeEntries
                        }
                    | None ->
                        let (UnanetProject unanetProjectString) = unanetProject
                        let (TogglProject togglProjectLong) = togglProject
                        printfn "Unanet project %s is mapped to Toggl project %i, but the Toggl project has no time entries" unanetProjectString togglProjectLong
                        None
                | None ->
                    let (UnanetProject unanetProjectString) = unanetProject
                    printfn "Unanet project has no corresponding Toggl project: %s" unanetProjectString
                    None
            )
            |> Seq.filter Option.isSome
            |> Seq.map Option.get
            |> List.ofSeq
        { StartDate = unanetTimesheet.StartDate; EndDate = unanetTimesheet.EndDate; MatchedUpProjectTimesheets = matchedUpProjectTimesheets }

    let matchedUpTimesheet = matchUpTimesheets unanetTimesheet togglTimesheet

    let correctUnanetTimesheet matchedUpTimesheet =
        let correctedUnanetProjectTimeEntries =
            matchedUpTimesheet.MatchedUpProjectTimesheets
            |> List.map (fun matchedUpProjectTimesheet ->
                let unanetProject = matchedUpProjectTimesheet.UnanetProject
                let togglTimeEntries = matchedUpProjectTimesheet.TogglTimeEntries
                let unanetTimeEntries = matchedUpProjectTimesheet.UnanetTimeEntries
                let correctedUnanetTimeEntries =
                    let startDate = matchedUpTimesheet.StartDate
                    let endDate = matchedUpTimesheet.EndDate
                    let unanetTimeEntryByDay =
                        unanetTimeEntries
                        |> List.map (fun unanetTimeEntry ->
                            unanetTimeEntry.Day, unanetTimeEntry
                        )
                        |> Map.ofList
                    let togglTimeEntriesByDay =
                        togglTimeEntries
                        |> List.groupBy (fun togglTimeEntry ->
                            togglTimeEntry.StartTime.Date
                        )
                        |> Map.ofList
                    dayRange startDate endDate
                    |> List.map (fun day ->
                        match togglTimeEntriesByDay |> Map.tryFind day with
                        | Some togglTimeEntriesForDay ->
                            let timeSpan =
                                togglTimeEntriesForDay
                                |> List.fold (fun total togglTimeEntryForDay ->
                                    let startTime = togglTimeEntryForDay.StartTime
                                    let endTime = togglTimeEntryForDay.EndTime
                                    total + (endTime - startTime)
                                ) TimeSpan.Zero
                            Some ({ Day = day; Minutes = int timeSpan.TotalMinutes } : DailyTimeEntry)
                        | None ->
                            unanetTimeEntryByDay |> Map.tryFind day
                    )
                    |> List.filter Option.isSome
                    |> List.map Option.get
                unanetProject, correctedUnanetTimeEntries
            )
            |> Map.ofList
        {
            StartDate = matchedUpTimesheet.StartDate
            EndDate = matchedUpTimesheet.EndDate
            UnanetProjectTimeEntries = correctedUnanetProjectTimeEntries
        }

    let correctedUnanetTimesheet = correctUnanetTimesheet matchedUpTimesheet

    printfn "Current Unanet Timesheet:\n%A" unanetTimesheet
    printfn "Updated Unanet Timesheet:\n%A" correctedUnanetTimesheet

    let submitUnanetTimesheet (unanetTimesheet : UnanetTimesheet) =
        // Go to timesheet page
        goToActiveUnanetTimesheet ()

        // Enter hours
        let timesheetRange = dayRange unanetTimesheet.StartDate unanetTimesheet.EndDate

        let projectTimesheetRows =
            findAll "#timesheet tbody tr[title]"
            |> List.filter (fun tr -> not (String.IsNullOrEmpty (tr.GetAttribute "title")))

        for projectTimesheetRow in projectTimesheetRows do
            let unanetProject = projectTimesheetRow.GetAttribute "title"
            match unanetTimesheet.UnanetProjectTimeEntries |> Map.tryFind (UnanetProject unanetProject) with
            | Some dailyTimeEntries ->
                let daysAndInputs =
                    let inputs = findAllIn ".weekend-hours input,.weekday-hours input" projectTimesheetRow
                    List.zip timesheetRange inputs
                    |> List.map (fun (day, hoursInput) ->
                        day, hoursInput
                    )

                for (day, input) in daysAndInputs do
                    match dailyTimeEntries |> List.tryFind (fun timeEntry -> timeEntry.Day = day) with
                    | Some entry ->
                        let hours = (float entry.Minutes) / 60.0
                        input.Clear ()
                        input.SendKeys (hours.ToString ())
                    | None ->
                        input.Clear ()
            | None ->
                ()

        let saveButton = find "#button_save"
        saveButton.Click ()

        Thread.Sleep pageLoadWait

        // If "Audit Trail" is present on page
        match tryFind ".time-banner" with
        | Some timeBanner ->
            // Select "Entry Issue" from each ".comments select"
            let commentsSelects = findAll ".comments select"
            for commentsSelect in commentsSelects do
                let commentsSelectElement = SelectElement (commentsSelect)
                try
                    commentsSelectElement.SelectByText "Entry Issue"
                with
                | :? WebDriverException ->
                    printfn "Failed to update comment select; ignoring and continuing"
            // Click "#button_save"
            let saveButton = find "#button_save"
            saveButton.Click ()
        | None ->
            ()

    printfn "Submitting corrected Unanet timesheet"

    submitUnanetTimesheet correctedUnanetTimesheet

    printfn "Updated Unanet successfully"

    onlyActiveVisibleUnanetTimesheetTr () |> ignore
with
| ex ->
    printfn "Error:\n%A" ex
    printfn "Page HTML:\n%s" driver.PageSource
