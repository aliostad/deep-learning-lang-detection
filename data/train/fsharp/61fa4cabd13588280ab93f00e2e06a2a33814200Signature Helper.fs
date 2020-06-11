namespace VFPTprototype
#nowarn "9"
open System
open System.Collections.Generic
open System                                       
open System.Threading
open System.Windows.Threading
open System.Collections.Generic                   
open System.Collections.ObjectModel               
open System.ComponentModel.Composition           
open System.Runtime.InteropServices               
open EnvDTE
open VSLangProj
open Microsoft.VisualStudio
open Microsoft.VisualStudio.Language.Intellisense 
open Microsoft.VisualStudio.Text                  
open Microsoft.VisualStudio.Text.Editor           
open Microsoft.VisualStudio.TextManager.Interop   
open Microsoft.VisualStudio.Utilities             
open Microsoft.VisualStudio.Editor                
open Microsoft.VisualStudio.Text.Operations       
open Microsoft.VisualStudio                       
open Microsoft.VisualStudio.ComponentModelHost
open Microsoft.VisualStudio.Shell                       
open Microsoft.VisualStudio.Shell.Interop                       
open Microsoft.VisualStudio.OLE.Interop          
open FSharpVSPowerTools
open Unchecked
open Microsoft.FSharp.NativeInterop
open System.Text.RegularExpressions



[<AutoOpen>]   
module SignatureHelper =

    let whitespace              = Regex @"\s+"
    let collapse_whitespace str = whitespace.Replace (str," ")
    let inline space_split x    = whitespace.Split x
    let paramEvent              = Event<_,_> ()  
    let textContentEvent        = Event<TextContentChangedEventArgs> ()

   
    type ITextStructureNavigator with

        member inline self.WordBeforeCaret (textView:ITextView) =
            let point = textView.Caret.Position.BufferPosition - 1
            (self.GetExtentOfWord point).Span.GetText ()
      

type FSharpParameter  (   documentation   : string
                    ,   locus           : Span
                    ,   name            : string
                    ,   signature       : ISignature    ) as self =

    member val Documentation      = documentation with get, set
    member val Locus              = locus         with get, set
    member val Name               = name          with get, set
    member val Signature          = signature     with get, set
    member val PrettyPrintedLocus = Span ()       with get, set

    interface IParameter with
        member __.Documentation      = self.Documentation
        member __.Locus              = self.Locus              
        member __.Name               = self.Name               
        member __.PrettyPrintedLocus = self.PrettyPrintedLocus 
        member __.Signature          = self.Signature          

      
type FSharpSignature  ( subjectBuffer : ITextBuffer
                    , content       : string
                    , doc           : string
                    , parameters    : ReadOnlyCollection<IParameter>) as self =

    let mutable currentParameter = defaultof<IParameter>
    let triggerParameterChanged (prevCurrentParameter:IParameter) (newCurrentParameter:IParameter) =
        paramEvent.Trigger ( self, CurrentParameterChangedEventArgs (prevCurrentParameter, newCurrentParameter))
    do  
        subjectBuffer.Changed.Add (fun _ -> ())

    member __.CurrentParameter 
        with get ()       = currentParameter
        and private set v = 
            if currentParameter <> v then
                let prevParameter = currentParameter
                currentParameter <- v
                triggerParameterChanged prevParameter v

    member val ApplicableToSpan = defaultof<ITrackingSpan>  with get, set
    member val Content          = content                   with get, set
    member val Documentation    = doc                       with get, set
    member val Parameters       = parameters                with get, set
    
    member __.ComputeCurrentParameter () = 
        if self.Parameters.Count = 0 then () else
            let sigText = self.ApplicableToSpan.GetText (subjectBuffer.CurrentSnapshot)
            let commaCount =
                let rec loop commaCount currentIdx =
                    if  currentIdx >= sigText.Length then commaCount else
                    let commaIndex  = sigText.IndexOf (',', currentIdx) 
                    if  commaIndex  = -1 then commaCount else loop (commaCount+1) (commaIndex+1)
                loop 0 0
            if commaCount < self.Parameters.Count then
                    self.CurrentParameter <- self.Parameters.[commaCount]
            else    self.CurrentParameter <- self.Parameters.[self.Parameters.Count-1]

    member __.OnSubjectBufferChanged (sender, args) = self.ComputeCurrentParameter ()



    interface ISignature with
        member __.ApplicableToSpan: ITrackingSpan            =  self.ApplicableToSpan
        member __.Content: string                            =  self.Content
        member __.CurrentParameter: IParameter               =  self.CurrentParameter
        member __.Documentation: string                      =  self.Documentation
        member __.Parameters: ReadOnlyCollection<IParameter> =  self.Parameters
        member __.PrettyPrintedContent: string               =  self.Content

        [<CLIEvent>]
        member __.CurrentParameterChanged = paramEvent.Publish


type FSharpSignatureHelpSource (textbuffer:ITextBuffer) as self =
    let mutable isDisposed = false

    let createSignature (textBuffer:ITextBuffer) (methodSig:string) (methodDoc:string) (span:ITrackingSpan) =
        let signat =  FSharpSignature (textBuffer, methodSig, methodDoc, null)
        textBuffer.Changed.Add (fun x -> signat.OnSubjectBufferChanged (self, x) )
        let param_strings = space_split methodSig
        let paramls, _ = 
             ((ResizeArray<IParameter>(),0), param_strings) 
             ||> Array.fold (fun (acc,searchStart) prm -> 
                let locusStart = methodSig.IndexOf (prm,searchStart)
                if locusStart >= 0 then
                    let locus = Span (locusStart, prm.Length)
                    acc.Add (FSharpParameter ("param doc", locus, prm, signat))
                    acc, searchStart + prm.Length
                else acc, searchStart)
        signat.Parameters <- ReadOnlyCollection paramls
        signat.ApplicableToSpan <- span
        signat.ComputeCurrentParameter ()
        signat


    member __.AugmentSignatureHelpSession   (   session     : ISignatureHelpSession
                                            ,   signatures  : ISignature IList      ) =
        let snapshot    = textbuffer.CurrentSnapshot
        let position    = session.GetTriggerPoint(textbuffer).GetPosition snapshot

        let applicSpan  = 
            textbuffer.CurrentSnapshot.CreateTrackingSpan 
                (   Span (position, 0)
                ,   SpanTrackingMode.EdgeInclusive
                ,   TrackingFidelityMode.Forward    )

        let inline sigAdd text doctext = 
            createSignature textbuffer text doctext applicSpan |> signatures.Add

        sigAdd "add(int firstInt, int secondInt)"               "Documentation for adding integers." 
        sigAdd "add(double firstDouble, double secondDouble)"   "Documentation for adding doubles." 


    member __.GetBestMatch (session:ISignatureHelpSession) =
        if session.Signatures.Count <= 0 then None else
            let applicableToSpan = session.Signatures.[0].ApplicableToSpan
            let text = applicableToSpan.GetText (applicableToSpan.TextBuffer.CurrentSnapshot)
            if  text = "add" then Some (session.Signatures.[0]) else None


    interface ISignatureHelpSource with

        member __.AugmentSignatureHelpSession (session, signatures) = 
            self.AugmentSignatureHelpSession (session, signatures)

        member __.GetBestMatch (session) = 
            match self.GetBestMatch session with
            | None -> null
            | Some s -> s

        member __.Dispose () =
            if not isDisposed then GC.SuppressFinalize self

//==========================================================================


[< Export (typeof<ISignatureHelpSourceProvider>) >]
[< Name "Signature Help Source" >]
[< Order (Before="default") >]
[< ContentType "text" >]
type FSharpSignatureHelpSourceProvider () as self =

    member __.TryCreateSignatureHelpSource (textBuffer:ITextBuffer) =
        new FSharpSignatureHelpSource (textBuffer) :> ISignatureHelpSource

    interface ISignatureHelpSourceProvider with
        member __.TryCreateSignatureHelpSource textBuffer = 
            self.TryCreateSignatureHelpSource textBuffer

//==========================================================================


type FSharpSignatureHelpCommandHandler
        (   textViewAdapter : IVsTextView
        ,   textView        : ITextView
        ,   navigator       : ITextStructureNavigator
        ,   broker          : ISignatureHelpBroker      
        ) as self =

    let subscriptions = ResizeArray ()

    let mutable nextCommandHandler = defaultof<IOleCommandTarget>
    do  textViewAdapter.AddCommandFilter (self, &nextCommandHandler) |> ignore

    
    let textbuffer = textView.TextBuffer
    let rnd = System.Random ()
    let mutable lastInsert = 0

    let mutable typedChar = Char.MinValue

    
    let mutable session = null : ISignatureHelpSession
    interface IOleCommandTarget with

        member __.Exec (pguidCmdGroup:byref<Guid>, nCmdID:uint32, nCmdexecopt:uint32, pvaIn:nativeint, pvaOut:nativeint) = 
            if  pguidCmdGroup = VSConstants.VSStd2K 
             && nCmdID = uint32 VSConstants.VSStd2KCmdID.TYPECHAR then
                typedChar <- nativeintToChar pvaIn
                let msg = "Typed character was " + string typedChar + " @ " + System.DateTime.Now.ToLongTimeString()
                ignore <| textbuffer.Replace (Span (0, msg.Length), msg) 
                
                if typedChar = '(' then
                    
                    let word    = navigator.WordBeforeCaret textView
                    if  word    = "add" then
                        session <- broker.TriggerSignatureHelp textView
                elif typedChar = ')' && isNotNull session then
                    session.Dismiss ()
                    
            nextCommandHandler.Exec (&pguidCmdGroup, nCmdID, nCmdexecopt , pvaIn, pvaOut)

        member __.QueryStatus (pguidCmdGroup, cCmds, prgCmds, pCmdText) =
            nextCommandHandler.QueryStatus (&pguidCmdGroup, cCmds, prgCmds, pCmdText)

//==========================================================================

[< Export (typeof<IVsTextViewCreationListener>) >]
[< Name "Signature Help controller" >]
[< TextViewRole (PredefinedTextViewRoles.Editable) >]
[< ContentType "text" >]
type FSharpSignatureHelpCommandProvider [<ImportingConstructor>]
    (   adapterService      : IVsEditorAdaptersFactoryService
    ,   navigatorService    : ITextStructureNavigatorSelectorService
    ,   signatureHelpBroker : ISignatureHelpBroker 
    )  =
    
 
    interface IVsTextViewCreationListener with
        
        member __.VsTextViewCreated textViewAdapter =
            let textView = adapterService.GetWpfTextView textViewAdapter
            if isNull textView  then () else
            
            textView.Properties.GetOrCreateSingletonProperty
                ( fun () -> FSharpSignatureHelpCommandHandler 
                                (   textViewAdapter
                                ,   textView
                                ,   navigatorService.GetTextStructureNavigator textView.TextBuffer
                                ,   signatureHelpBroker 
                                ) 
                                :> IOleCommandTarget |> ignore)

(* Stop signature completion at
    -- operator not in parens?
    -- ( ) or [ ]  or [| |] where open brace precedes the function being completed for
    -- 2 newlines?
    |>  <| >> << |||> ||> <|| <||| 

Signature help command traces back to nearest function, checks if that function has all of its args


Dismiss on leaving scope

*)


         
