namespace NotificationAPI

module NotificationsController =

    open System.Collections.Generic
    open System.Web.Http
    open NotificationAPI.Mongo
    open NotificationAPI.NotificationSearch
    open NotificationLibrary
    

    type NotificationsController() =
        inherit ApiController()
        // get db context -> could inject if we wanted...
        let db = (NotificationDB() :> INotificationDB)


        // GET list -> maybe default to current day or yesterday, or those that are pending?
        [<Route("api/notifications")>]
        member this.Get() = 
            db.GetNotificationList()   
            
        // POST search
        [<HttpPost>]
        [<Route("api/notifications/search")>] 
        member this.Search(rs) = 
            NotificationSearch(rs.source_str, rs.status_str, rs.date_start_str, rs.date_end_str)
            |> db.SearchNotifications
            
        // GET by id
        [<Route("api/notifications/{id}")>]
        member this.GetById(id) = 
            db.GetNotification(id)

        // PUT
        [<HttpPut>]
        [<Route("api/notifications/{id}")>]
        member this.Put(notification) =
            db.PutNotification(notification)

        // MARK REVIWED (GET)
        [<HttpGet>]
        [<Route("api/notifications/{id}/MarkReviewed")>]
        member this.MarkReviwed(id) = 
            db.MarkReviewed(id)

        // POST
        [<HttpPost>]
        [<Route("api/notifications")>]
        member this.Post(notification) = 
            db.PostNotification(notification)

        // POST batch -> only hit mongo once
        [<HttpPost>]
        [<Route("api/notifications/batch")>]
        member this.BatchPost(notifications) = 
            db.BatchPostNotifications(notifications)

        // POST search


        
       
        