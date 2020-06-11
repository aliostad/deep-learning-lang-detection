#r @"WindowsBase.dll"
#r @"PresentationFramework.dll"
#r @"C:\Program Files\Common Files\microsoft shared\Team Foundation Server\14.0\Microsoft.TeamFoundation.Client.dll"
#r @"C:\Program Files\Common Files\microsoft shared\Team Foundation Server\14.0\Microsoft.TeamFoundation.WorkItemTracking.Client.dll"

open System
open Microsoft.TeamFoundation.Client
open Microsoft.TeamFoundation.WorkItemTracking.Client

let cloneTestCase toIterPath linkToWID (store: WorkItemStore) (testCaseId: int) =

        try
            let workItem = store.GetWorkItem(testCaseId)
            let wiCopy = workItem.Copy()

            wiCopy.IterationPath <- toIterPath
            wiCopy.Fields.["ReviewedBy"].Value <- "John Snow"
            wiCopy.Fields.["ReviewStatus"].Value <- "Design"
            wiCopy.State <- "Design"
            wiCopy.Links.Clear()
            let linkTypeEnd = store.WorkItemLinkTypes.LinkTypeEnds.["Parent"]
            wiCopy.Links.Add(RelatedLink(linkTypeEnd, linkToWID)) |> ignore
            wiCopy.Save()
            wiCopy.Fields.["TMC ReviewStatus"].Value <- "Ready to review"
            wiCopy.State <- "Ready"
            wiCopy.Save()
            printfn "Test case %d cloned successfully, new ID is: %d" testCaseId wiCopy.Id
        
        with | error -> 
            printfn "Error cloning test case %d" testCaseId
            printfn "%s" error.Message

let tfsCollection = new Uri("http://tfsserver:8080/tfs/myapp/")
let teamProjColletion = new TfsTeamProjectCollection(tfsCollection)
let wiStore = teamProjColletion.GetService<WorkItemStore>()

let sourceTestCases: int list = [ (*the list of workitem IDs fot the test cases you want to clone *) ] 
let parentWorkItemId: int = 0 (*parent work item id to link all new clones*)
sourceTestCases |> List.map ( fun wid -> cloneTestCase @"<destination Iteration path>" parentWorkItemId  wiStore wid )

