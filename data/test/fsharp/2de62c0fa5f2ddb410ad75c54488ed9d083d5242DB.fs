module NCF.AlarmHistory.DB

open System
open FSharp.Data.TypeProviders
open CitectAlarmEvent

//type private dbSchema = SqlDataConnection<" Data Source=(localdb)\MSSQLLocalDB;Initial Catalog=CitectAlarms;Integrated Security=True;Connect Timeout=30;Encrypt=False;TrustServerCertificate=True;ApplicationIntent=ReadWrite;MultiSubnetFailover=False">
type private dbSchema = SqlDataConnection<"Data Source=(LocalDB)\MSSQLLocalDB;AttachDbFilename='C:\\Users\\franco.tiveron\\AppData\\Local\\Microsoft\\Microsoft SQL Server Local DB\\Instances\\MSSQLLocalDB\\CitectAlarms.mdf';Integrated Security=True;Connect Timeout=30">
let private db = dbSchema.GetDataContext()
let private conn = db.Connection
conn.ConnectionString <- "context connection=true"
conn.Open()

let private saveEvent (e:CitectAlarmEvent) =
    let r = 
        new dbSchema.ServiceTypes.NCFEvent(
            Tag = e.tag, 
            Name = e.name, 
            Desc = e.desc,
            Location = "cmoc/npm/" + e.zone + "/" + (string e.area),
            Priority = e.priority,
            TimeOn = e.timeOn.Value, 
            TimeOff = e.timeOff.Value,
            Duration = (float32 (e.timeOff.Value - e.timeOn.Value).TotalSeconds)
            )
    db.NCFEvent.InsertOnSubmit(r)

//Recordable events are OFF with event time >= OffTime and OffTime > OnTime
let manage (e:CitectAlarmEvent) (logger: string->unit) = 
    match e.state, e.time, e.timeOn, e.timeOff with
    | On, _, _, _ -> ()
    | _, _, None, _ -> ()
    | NotOn, t, Some tOn, Some tOff when t >= tOff && tOff > tOn -> 
        if query {for event in db.NCFEvent do
                  select (event.Tag, event.TimeOn, event.TimeOff)
                  contains (e.tag, tOn, tOff)}
        then () else saveEvent e
    | _ -> logger "Invalid Event"

    try db.DataContext.SubmitChanges() with
    | x -> logger x.Message

let quarantine message reason = 
    let nr = new dbSchema.ServiceTypes.NCFQuarantinedMessage(Message = message, Reason = reason)
    db.NCFQuarantinedMessage.InsertOnSubmit(nr)
    db.DataContext.SubmitChanges()

