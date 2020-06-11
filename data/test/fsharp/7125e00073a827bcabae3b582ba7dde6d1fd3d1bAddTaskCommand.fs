namespace TrackerTools.Commands
open System
open System.IO
open TrackerTools

[<CommandName("AddTask")>]
type AddTaskCommand(tracker:TrackerApi, configuration:TrackerToolsConfiguration,  [<FromCommandLine(Position = 1)>] storyId, [<FromCommandLine(Position = 2)>] description) =

    let DumpToConsole (stream:Stream) =
        use reader = new StreamReader(stream)
        reader.ReadToEnd() |> Console.WriteLine

    let ResponseHandler withResponse = {new IResponseHandler with member this.HandleResponse x = withResponse(x)}

    interface ITrackerToolsCommand with
        member this.Invoke() =
            let request = XmlRequest(TrackerTask(Description = description))
            let response = (ResponseHandler(fun x ->
                use stream = x.GetResponseStream()
                DumpToConsole stream))
            tracker.Base.AddTask configuration.ProjectId storyId request response
