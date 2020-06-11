namespace BookMate.NLPServices

module Program = 
    open Suave
    open Rest
    open System
    open System.Reactive
    open Processing
    open Domain
    open ApiConfiguration
    
    type Agent<'T> = Microsoft.FSharp.Control.MailboxProcessor<'T>
    
    let addTextToProcessing observer nextItem = 
        use subject = new Subjects.Subject<ProcessTagEntry>()
        use o = subject.Subscribe observer
        subject.OnNext nextItem
        nextItem
    
    let getProcessedTextFromStore = Processing.getProcessedTextFromStore >> Async.RunSynchronously
    
    [<EntryPoint>]
    let main argv = 
        let pathToStanfordModel = @"..\..\data\nlpcore\models\pos-tagger\english-left3words\english-left3words-distsim.tagger"
        let tagger = StanfordNlp.loadStanfordTagger (pathToStanfordModel)
        let tagText = StanfordNlp.tagText tagger
        
        let tagAgent = 
            new Agent<ProcessTagEntry>(fun inbox -> 
            let rec loop() = async { let! cmd = inbox.Receive()
                                     let! entry = handleTagEnry cmd tagText
                                     let! _ = addToStore entry
                                     return! loop() }
            loop())
        do tagAgent.Start()
        let addTextToProcessing' = Observer.Create(Action<ProcessTagEntry> tagAgent.Post) |> addTextToProcessing
        
        let taggerApi = 
            { Create = (ProcessTagEntryWithDefaults >> addTextToProcessing')
              GetByGuid = getProcessedTextFromStore
              Exists = getProcessedTextFromStore >> Option.isSome }
        
        let taggerApiEndpoint = "api/tagger/stanford"
        let taggerProcessQueueWebPart = rest taggerApiEndpoint taggerApi
        startWebServer defaultConfig (choose [ taggerProcessQueueWebPart ])
        0
