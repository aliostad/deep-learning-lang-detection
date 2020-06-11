namespace ViEmu
 
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

    [<Export(typeof<IKeyProcessorProvider>)>]
    [<Name("ViKeyProcessorProvider")>]
    [<ContentType("text")>]
    [<TextViewRole(PredefinedTextViewRoles.Interactive)>]
    type ViKeyProcessorProvider() =
        
        [<Import>]
        let mutable opFactory: IEditorOperationsFactoryService = null
        
        [<Import>]
        let mutable undoHistRegistry: ITextUndoHistoryRegistry = null

        [<Import>]
        let mutable completionBroker: ICompletionBroker = null 

        [<Import>]
        let mutable quickInfoBroker: IQuickInfoBroker = null

        [<Import>]
        let mutable smartTagBroker: ISmartTagBroker = null

        interface IKeyProcessorProvider with
            member this.GetAssociatedProcessor textView =
                let intellisenseMonitor = Monitors.IntellisenseMonitor(textView, completionBroker, 
                                                                        quickInfoBroker, smartTagBroker)
                let ops = opFactory.GetEditorOperations(textView)
                let context = Context(None, textView, ops, undoHistRegistry)
                textView.Properties.GetOrCreateSingletonProperty<ViKeyProcessor>(
                                                            typeof<ViKeyProcessor>,
                                                            fun () -> ViKeyProcessor(context, intellisenseMonitor)) 
                :> KeyProcessor
