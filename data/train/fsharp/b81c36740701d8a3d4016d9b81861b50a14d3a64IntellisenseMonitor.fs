namespace ViEmu.Monitors

    open System
    open System.Windows.Input
    open System.ComponentModel.Composition
    open Microsoft.VisualStudio.Text
    open Microsoft.VisualStudio.Text.Editor
    open Microsoft.VisualStudio.Text.Operations
    open Microsoft.VisualStudio.Editor
    open Microsoft.VisualStudio.OLE.Interop
    open Microsoft.VisualStudio.TextManager.Interop
    open Microsoft.VisualStudio.Utilities
    open Microsoft.VisualStudio.Language.Intellisense

    type IntellisenseMonitor(textView: ITextView, completionBroker: ICompletionBroker, quickInfo: IQuickInfoBroker, smartTag: ISmartTagBroker) =
        
        member this.IsIntellisenseActive () =
            completionBroker.IsCompletionActive(textView) ||
            quickInfo.IsQuickInfoActive(textView) ||
            smartTag.IsSmartTagActive(textView)

        member this.DeactivateIntellisense () =
            completionBroker.DismissAllSessions(textView)
            quickInfo.GetSessions(textView)
            |> Seq.iter (fun session -> session.Collapse())
            smartTag.GetSessions(textView)
            |> Seq.iter (fun session -> session.Collapse())