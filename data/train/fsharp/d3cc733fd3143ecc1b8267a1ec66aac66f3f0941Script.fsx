#r @"C:\Root\Project\NCF\NCF.AlarmHistory\bin\Debug\NCF.AlarmHistory.dll"
open NCF.AlarmHistory
//let msg = "OPD~FM1_WTP_LL~Flow Meter 1~-442 EEF~OFF~0~5~16/08/2017~01:57:00 PM~16/08/2017~01:56:09 PM~16/08/2017~01:57:00 PM~16/08/2017~01:56:58 PM"
//match CitectAlarmEvent.msg2record msg with
//| Ok e -> DB.manage e (fun s -> ())
//| Error s -> ()

let msg = "WINDER~Winder_Alarm_015    ~Winder \ Alarm 15                                 ~Head Rope Elongation Approaching Limit            ~ON        ~0  ~0  ~25/08/2017~08:34:04   ~0         ~0          ~0         ~0          ~0         ~0          "
CitectAlarmEvent.msg2record msg

//#r "System.Messaging"
//open System.Messaging

//let q = new MessageQueue(@".\private$\NCFCitectAlarmHistory")
//let msg = "OPD~FM1_WTP_LL~Flow Meter 1~Low Low Level~OFF~0~5~16/08/2017~01:57:00 PM~16/08/2017~01:56:09 PM~16/08/2017~01:57:00 PM~16/08/2017~01:56:58 PM"
//q.Send(msg)

//let stp = "STOP"
//q.Send(stp)
