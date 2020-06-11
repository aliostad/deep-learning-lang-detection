namespace CounterWtf.PCL

open System.Collections.Generic
open System.Net.Http
open System.Threading.Tasks
open Microsoft.WindowsAzure.MobileServices

    type BusyStateIndicator() =
        inherit DelegatingHandler()

        let _busyEvent = new Event<bool>()
        
        // TODO: Make more functional... with a collection?
        let mutable _busyCount = 0

        member x.BusyStateChange = 
            _busyEvent.Publish
        override x.SendAsync (request, cancellationToken) =
            
            _busyCount <- _busyCount + 1
            _busyEvent.Trigger true

            let t = base.SendAsync(request, cancellationToken)
            try
                // Need to figure out how to 'await' and how it works with async
                t.Wait()
            finally
                _busyCount <- _busyCount - 1

                if _busyCount = 0 then
                    _busyEvent.Trigger false

            t

    type IWtfClient = 
        // Could extract MobileServiceUser into a simple abstraction hiding the fact we are using mobile services
        // but too much effort for a demo.
        abstract member User : MobileServiceUser with get
        abstract member BusyIndicator : BusyStateIndicator with get
        abstract member Authenticate : unit -> Task<MobileServiceUser>
        abstract member AddProject : Project -> Task
        abstract member GetProjectSummaries : unit -> Task<IEnumerable<ProjectSummary>>
        abstract member AddWtf : Wtf -> Task
        abstract member GetWtfs : string -> Task<IEnumerable<Wtf>>
    
    module MobileClientFactory =
        [<Literal>]
        let private applicationURL = @"https://counterwtf.azure-mobile.net/";
        [<Literal>]
        let private applicationKey = @"ddjldEDUWmSdHnMurGuEbAOJDtCEOA59";

        let getClient(handler : HttpMessageHandler) =
            new MobileServiceClient(applicationURL, applicationKey, handler)

    [<AbstractClass>]
    type MobileServicesWtfClient() =
        let mutable user = None
        let busyHandler = new BusyStateIndicator()
        let client = MobileClientFactory.getClient(busyHandler)

        abstract member PerformAuthentication : unit -> Task<MobileServiceUser>
        member x.Client = client
        member x.BusyHandler = busyHandler

        interface IWtfClient with
            member x.User = 
                // Done for C# compatability
                match user with
                | None -> null
                | Some u -> u
            member x.BusyIndicator = x.BusyHandler
            member x.Authenticate() = 
                let assignUser (t : Task<MobileServiceUser>) =
                    user <- Some(t.Result)
                    t.Result
                x.PerformAuthentication()
                 .ContinueWith(assignUser)
            member x.AddProject project =
                x.Client.GetTable<Project>()
                      .InsertAsync(project)
            member x.GetProjectSummaries() = 
                x.Client.GetTable<ProjectSummary>()
                      .ToEnumerableAsync()
            member x.AddWtf wtf =
                x.Client.GetTable<Wtf>()
                      .InsertAsync(wtf)
            member x.GetWtfs projectId = 
                x.Client.GetTable<Wtf>()
                      .Where(fun wtf -> wtf.ProjectId = projectId)
                      .ToEnumerableAsync()
