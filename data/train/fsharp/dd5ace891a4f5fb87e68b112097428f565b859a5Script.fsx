#load "Notifications.Domain.fs"
open Notifications.Domain

// Define your library scripting code here
let pnr = "800412" |> PersonalNumber 
let testar =
    let ta = TokenAdded <| { CommitId = System.Guid.NewGuid(); EventId = System.Guid.NewGuid(); PersonTokenNotification.PersonalNumber = pnr ;Token = "ABC"; NotificationTypeId = SooneDue }
    [ta]

let cmd = 
    AddToken <| { PersonAddRemoveTokenRecord.CommandId = System.Guid.NewGuid(); PersonalNumber = pnr ;Token = "ABC"; NotificationTypeId = SooneDue }

let t2 = 
    peopleCommandHandler.apply testar

let test () = 
    match peopleCommandHandler.executeOn cmd testar with 
        | Success e -> List.concat [testar;e] 
        | Failed _ -> testar

test ()