namespace SquashScrape

open canopy
open Google.Apis.Calendar.v3
open System.IO
open System
open Google.Apis.Calendar.v3.Data
open Google.Apis.Gmail.v1
open System.Net.Mail

type BookedActivity =
    {
    Activity : string // e.g Paid Squash [Squash Crt 1, 12:00-22:00]
    Price : string // e.g £2.00
    Time : string // e.g 12/05/2017 18:45 to 19:29
    }

module Program =

    let base64UrlEncode (input : string) =
        let inputBytes = System.Text.Encoding.UTF8.GetBytes input

        // Special "url-safe" base64 encode.
        Convert.ToBase64String(inputBytes)
            .Replace('+', '-')
            .Replace('/', '_')
            .Replace("=", "")

    let makeFreeBusyRequestItem (id : string) =
        let item = FreeBusyRequestItem()
        item.Id <- id
        item

    [<EntryPoint>]
    let main argv = 
        let initializer = GoogleApi.getInitializer()
        use calendar = new CalendarService(initializer)
        use gmail = new GmailService(initializer)

        let sendMail subject body =
            let toAddr = MailAddress Config.notificationAddress

            let msg = AE.Net.Mail.MailMessage()
            msg.Subject <- sprintf "[SquashScrape] %s" subject
            msg.Body <- body
            msg.From <- MailAddress Config.googleAccount
            msg.To.Add toAddr
            msg.ReplyTo.Add msg.From

            use msgStr = new StringWriter()
            msg.Save msgStr

            let message = Data.Message()
            message.Raw <- msgStr.ToString() |> base64UrlEncode
            gmail.Users.Messages.Send(message, "me").Execute() |> ignore
            printfn "Sent email %O --> %O" msg.From toAddr

        let isBusy (date : DateTime) =
    
            let startTime = date.Add Config.busyCheckStartTime
            let endTime = date.Add Config.busyCheckEndTime

            let request = FreeBusyRequest()
            request.TimeMin <- Nullable startTime
            request.TimeMax <- Nullable endTime
            request.Items <-
                Config.calendarIds
                |> Array.map makeFreeBusyRequestItem
                :> Collections.Generic.IList<_>

            let response = calendar.Freebusy.Query(request).Execute()

            response.Calendars.Values
            |> Seq.collect (fun cal -> cal.Busy)
            |> Seq.isEmpty
            |> not
    
        let tryBookDate (date : DateTime) =

            // Convert the date to the same format that the search fields accept
            let simpleDate = date.ToString "ddMMyyyy"

            printfn "Checking availability for %s..." simpleDate

            url Config.gymUrl

            // Check to see if we're already logged in
            match someElement "#ctl00_MainContent_InputLogin" with
            | None -> ()
            | Some _ ->
                "#ctl00_MainContent_InputLogin" << Config.loginUsername
                "#ctl00_MainContent_InputPassword" << Config.loginPassword

                click "Login"

            "#ctl00_MainContent__advanceSearchUserControl_ActivityGroups" << "Squash"
            "#ctl00_MainContent__advanceSearchUserControl_Activities" << "Paid Squash"
            "#ctl00_MainContent__advanceSearchUserControl_startDate" << simpleDate
            "#ctl00_MainContent__advanceSearchUserControl_endDate" << simpleDate
            "#ctl00_MainContent__advanceSearchUserControl_StartTime" << Config.activityBookStartTime
            "#ctl00_MainContent__advanceSearchUserControl_EndTime" << Config.activityBookEndTime

            click "#ctl00_MainContent__advanceSearchUserControl__searchBtn"

            click "Paid Squash"
        
            click "Available"

            match someElement "#ctl00_MainContent_gvBookings" with
            | None ->
                printfn "> No activity available"
                None
            | Some _ ->
                let activity = read "#ctl00_MainContent_gvBookings tr td.cellpad"
                let dateTime = read "#ctl00_MainContent_gvBookings tr td:nth-child(2)"
                let price = read "#ctl00_MainContent_gvBookings tr td.cellpadcurrency"

                printfn "> Activity: %s\n> Date:     %s\n> Price:    %s" activity dateTime price

                click "Book"

                Some {
                    Activity = activity
                    Time = dateTime
                    Price = price
                }
    
        let today = DateTime.Today

        start chrome

        [0..7]
        |> Seq.map (fun addDays -> today.AddDays (float addDays))
        |> Seq.filter (isBusy >> not)
        |> Seq.choose (fun date ->
            try
                tryBookDate date
            with e ->
                sendMail "Unexpected exception" (e.ToString())
                None
            )
        |> Seq.iter (fun booking ->
            let body = sprintf "> Activity: %s\n> Date:     %s\n> Price:    %s\n\nVisit http://gym.uclu.org/Connect/ManageSales.aspx" booking.Activity booking.Time booking.Price
            sendMail "Booking reserved" body
            )

        quit ()
    
        0
