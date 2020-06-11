module Copy

open Google.GData.Client
open Google.Contacts
open Composable.Linq
let copy (certPath, jsonPath, domain, forceYes) src dest = 
    let cert = Helper.loadCertificate certPath
    let serviceId = Helper.loadServiceID jsonPath
    let cred = Helper.getServiceCred serviceId cert ("admin@" + domain)

    let srcEmail = src |> Enumerable.single
    let rs = Helper.getRequestSetting serviceId cert srcEmail
    let contacts = Helper.getContacts rs
    for d in dest do
        let rs2 = Helper.getRequestSetting serviceId cert d
        Helper.deleteContacts rs2 ignore None
    let g = Helper.getMyContactsGroup rs
    let filteredContacts = contacts |> Helper.filterToGroup g
    for d in dest do
        let rs2 = Helper.getRequestSetting serviceId cert d
        let newContacts = Helper.copyContacts filteredContacts
        let g2 = Helper.getMyContactsGroup rs2
        newContacts |> Seq.iter (fun c -> 
                    c.GroupMembership.Add(Google.GData.Contacts.GroupMembership(HRef= g2.Id))|>ignore
                    c.BatchData <- Helper.batchCreate())
        let result = Helper.runBatchContacts rs2 newContacts
        let onError:GDataBatchEntryData->unit = (fun batchData -> printfn "%s: %i (%s)" batchData.Id batchData.Status.Code batchData.Status.Reason)
        for x in result |> Seq.map (fun x-> x.Entries) |> Seq.collect id do
            if(x.BatchData.Status.Code < 200 || x.BatchData.Status.Code >= 300) then
                onError x.BatchData
    0