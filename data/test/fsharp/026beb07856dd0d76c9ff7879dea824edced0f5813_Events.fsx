// *******************************************************************************************************
//   To execute the code in F# Interactive, highlight a section of code and press Alt-Enter or right-click 
//   and select "Execute in Interactive".  You can open the F# Interactive Window from the "View" menu. 
// *******************************************************************************************************

/// Events are a common idiom for .NET programming, especially with WinForms or WPF applications.
///
/// To learn more, see: https://docs.microsoft.com/en-us/dotnet/articles/fsharp/language-reference/members/events
module Events =

    open System

    /// First, create instance of Event object that consists of subscription point (event.Publish) and event trigger (event.Trigger).
    let simpleEvent = new Event<int>() 

    // Next, add handler to the event.
    simpleEvent.Publish.Add(
        fun x -> printfn "this handler was added with Publish.Add: %d" x)

    // Next, trigger the event.
    simpleEvent.Trigger(5)

    // Next, create an instance of Event that follows standard .NET convention: (sender, EventArgs).
    let eventForDelegateType = new Event<EventHandler, EventArgs>()

    // Next, add a handler for this new event.
    eventForDelegateType.Publish.AddHandler(
        EventHandler(fun _ _ -> printfn "this handler was added with Publish.AddHandler"))

    // Next, trigger this event (note that sender argument should be set).
    eventForDelegateType.Trigger(null, EventArgs.Empty)
