// Copyright 2015 Alexey Martseniuk. All rights reserved.
// Use of this source code is governed by a GPL V3 license
// that can be found in the LICENSE file.

namespace PowerShellSE

open System
open System.Diagnostics
open System.Reflection
open System.Media
open System.Text
open System.Collections.ObjectModel
open System.IO
open System.Windows
open System.Windows.Threading
open System.Windows.Media
open System.Windows.Controls
open System.Windows.Controls.Primitives
open System.Windows.Input
open System.Collections.Generic
open System.Linq
open Microsoft.VisualStudio.AssetSystem.CommonAttributes
open Microsoft.VisualStudio.AssetSystem
open Microsoft.VisualStudio.Text
open Microsoft.VisualStudio.Text.Classification
open Microsoft.VisualStudio.Text.Editor
open Microsoft.VisualStudio.Text.Operations
open Microsoft.VisualStudio.UI.Undo
open Microsoft.VisualStudio.Language.Intellisense
open Microsoft.VisualStudio.Text.Adornments
open System.Management.Automation
open System.Management.Automation.Host


module internal KeyProcessors = 
    let ShowSnippets(view : IWpfTextView, ct : ContentType) = 
        use l = Logging.LogScope()
        let items = Snippets.GetItems().Where(fun (si : SnippetInfo) -> si.SnippetType = ct)
        if items.Count() > 0 then
            let menu = new ContextMenu()
            menu.Style <- Application.Current.FindResource("pseContextMenu") :?> Style
            let itemTempl = Application.Current.FindResource("pseMenuItemSubmenuItem") :?> ControlTemplate
            menu.IsTextSearchEnabled <- true
            let ttstyle = Application.Current.FindResource("pseToolTip") :?> Style
            menu.HorizontalOffset <- view.Caret.Left
            menu.VerticalOffset <- view.Caret.Top + view.Caret.Height + 3.
            menu.Placement <- PlacementMode.RelativePoint
            for item in items do
                let mi = new MenuItem()
                mi.Template <- itemTempl
                mi.Header <- item.Header
                mi.Tag <- item
                if not(String.IsNullOrEmpty(item.ToolTip)) then 
                    let tt = new ToolTip()
                    tt.Style <- ttstyle
                    tt.Content <- item.ToolTip
                    mi.ToolTip <- tt
                mi.Click.Add(fun (ea : RoutedEventArgs) -> 
                    use l = Logging.LogScope()
                    let si = ((ea.Source) :?> MenuItem).Tag :?> SnippetInfo
                    try
                        let res = GetPsObjectValue(Provider.Posh.InvokeRaw(si.Body, null))
                        if res <> null then
                            let ins = res.ToString()
                            if not(String.IsNullOrEmpty(ins)) then
                                use ut = EditorHost.GetHistory(view.TextBuffer).CreateTransaction("snippet")
                                if view.Selection.IsEmpty then
                                    view.TextBuffer.Insert(view.Caret.Position.Index, ins) |> ignore
                                else
                                    view.TextBuffer.Replace(view.Selection.SelectionSpan.Span, ins) |> ignore
                                Snippets.AfterCommit(ins, view, si)
                                ut.Complete()
                        view.Caret.EnsureVisible()
                    with ex -> 
                        Host.Current.UI.WriteErrorLine(ex.Message)
                        Logging.LogException(ex, TraceLevel.Error, si.Body))
                menu.Items.Add(mi) |> ignore
            menu.PlacementTarget <- view.VisualElement
            menu.IsOpen <- true
            (box(view.Caret) :?> UIElement).Visibility <- Visibility.Visible

    let GetPs1HelpRequest(view : IWpfTextView, cl : IPs1Classifier) = 
        use l = Logging.LogScope()
        let mutable request = null
        let token = GetTokenAtWithRightBounds(view.Caret.Position.Index, cl)
        if token <> null then
            match token.Type with  
            | PSTokenType.Command -> 
                request <- token.Content
            | PSTokenType.Member -> 
                let owner = GetOwnerToken(token, cl)
                if owner <> null then
                    let path = GetOwnerPath(view.TextBuffer, owner, token)
                    let mutable t = Provider.GetOwnerType(view.TextBuffer, owner, token, path, cl.Tokens)
                    if t <> null then
                        let dt = ref (null : Type)
                        let isStatic = 
                            match owner.Type with
                            | PSTokenType.Type -> path.Length = 1
                            | _ -> false
                        ToolTip.GetNameFor(token.Content, t, isStatic, dt) |> ignore
                        if dt.Value <> null then
                            t <- dt.Value
                        while t <> null && t.IsNotPublic do
                            t <- t.BaseType
                        if t <> null then
                            let mutable flags = BindingFlags.Public ||| BindingFlags.IgnoreCase
                            if isStatic then
                                flags <- flags ||| BindingFlags.Static
                            else
                                flags <- flags ||| BindingFlags.Instance
                            let mem = t.GetMember(token.Content, flags).FirstOrDefault()
                            if mem <> null then
                                let mutable cont = token.Content
                                if cont.StartsWith("add_", StringComparison.OrdinalIgnoreCase) ||
                                   cont.StartsWith("remove_", StringComparison.OrdinalIgnoreCase)
                                then
                                    cont <- cont.Remove(0, cont.IndexOf('_') + 1)
                                request <- String.Format(MsdnMemberHelpUrl, mem.DeclaringType.FullName, cont)
            | PSTokenType.Type -> 
                let t = GetType(token.Content)
                if t <> null then
                    request <- String.Format(MsdnTypeHelpUrl, t.FullName)
            | _ -> ()
        request

    let GetXamlHelpRequest(view : IWpfTextView, cl : IClassifierEx) = 
        use l = Logging.LogScope()
        let mutable request = null
        let propPath = XmlLib.GetPropertyPath(view.TextBuffer.CurrentSnapshot, view.Caret.Position.Index)
        if propPath.Length > 0 then
            let names = propPath.Last().Name.Split([| '.' |])
            let t = TypesDic.Where(fun (e : KeyValuePair<string, Type>) -> e.Value.IsXamlType)
                            .FirstOrDefault(fun kv -> IsEqual(kv.Key.Split([| '.' |]).Last() , names.[0]))
            if t <> Unchecked.defaultof<KeyValuePair<string, Type>> then
                let spans = cl.GetClassificationSpans(new SnapshotSpan(view.TextBuffer.CurrentSnapshot, view.Caret.Position.Index, 1))
                if spans.Count > 0 then
                    let attr = view.TextBuffer.CurrentSnapshot.GetText(spans.First().Span.Span)
                    if not(String.IsNullOrEmpty(attr)) && not(IsEqual(names.[0], attr)) then
                        let pi = t.Value.GetProperties().Where(fun (p : PropertyInfo) -> IsEqual(p.Name, attr)).FirstOrDefault()
                        if pi <> null then
                            request <- String.Format(MsdnMemberHelpUrl, pi.DeclaringType, pi.Name)
                        else if attr.IndexOf('.') > -1 then
                            let an = attr.Split('.')
                            if not(String.IsNullOrEmpty(an.[0])) then
                                let atype = TypesDic.Where(fun (e : KeyValuePair<string, Type>) -> e.Value.IsXamlType)
                                                    .FirstOrDefault(fun kv -> IsEqual(kv.Key.Split([| '.' |]).Last() , an.[0]))
                                if atype <> Unchecked.defaultof<KeyValuePair<string, Type>> then
                                    if String.IsNullOrEmpty(an.[1]) then
                                        request <- String.Format(MsdnTypeHelpUrl, t.Key)
                                    else
                                        let pinf = atype.Value.GetProperties().Where(fun (p : PropertyInfo) -> IsEqual(p.Name, an.[1])).FirstOrDefault()
                                        if pinf <> null then
                                            request <- String.Format(MsdnMemberHelpUrl, pinf.DeclaringType, pinf.Name)
                                        else
                                            request <- String.Format(MsdnMemberHelpUrl, atype.Key, an.[1])
                if String.IsNullOrEmpty(request) then
                    request <- String.Format(MsdnTypeHelpUrl, t.Key)
        request

    let ExecuteHelp(view : IWpfTextView) = 
        use l = Logging.LogScope()
        let mutable request = null
        if view.Selection.IsEmpty then 
            let cl = view.TextBuffer
                         .Properties
                         .GetProperty<IClassifier>(ClassifierPropertyName)
            match cl with
            | :? IPs1Classifier as ps1cl -> 
                request <- GetPs1HelpRequest(view, ps1cl)
            | :? IClassifierEx as cle when cle.Type = ContentType.Xaml ->
                request <- GetXamlHelpRequest(view, cle)
            | _ -> ()
        else 
            request <- view.Selection.SelectionSpan.GetText().Trim()
        if not(String.IsNullOrEmpty(request)) then
            PSE.Windows.Help.IsVisible <- true
            let k1 = new CommandKey(request)
            if Uri.IsWellFormedUriString(request, UriKind.Absolute) then
                Controls.HelpView.Navigate(new Uri(request, UriKind.Absolute))
            else if Provider.Posh.AllHelpIndex.ContainsKey(k1) then
                Controls.HelpView.Navigate(new HelpDocumentModel(Provider.Posh.AllHelpIndex.[k1]))
            else
                Controls.HelpView.Navigate(new NotFoundDocumentModel(request))


    type KeyprocessorBase(textView : IWpfTextView, 
                          completionBroker : ICompletionBroker,
                          signatureBrokerMap : ISignatureHelpBrokerMap,
                          toolTipProviderFactory : IToolTipProviderFactory) as this = 
        inherit KeyProcessor()
        do
            use l = Logging.LogScope()
            let ownerType = textView.VisualElement.GetType()
            [| ApplicationCommands.Help;
                Commands.TabifySelection;
                Commands.UntabifySelection;
                Commands.MakeUppercase;
                Commands.MakeLowercase;
                Commands.GotoLine;
                Commands.InsertSnippet;
                ApplicationCommands.Undo;
                ApplicationCommands.Redo;
            |] |> Seq.iter(fun command -> 
                use l = Logging.LogScope()
                RegisterCommandHandler(ownerType,
                                       command, 
                                       new ExecutedRoutedEventHandler(this.ExecuteHandler),
                                       new CanExecuteRoutedEventHandler(this.QueryEnabledHandler),
                                       null) |> ignore)
            textView.VisualElement
                    .ContextMenu <- Application.Current
                                               .FindResource("pseTextBoxContextMenu") :?> ContextMenu

        abstract TriggerSnippets : IWpfTextView -> unit
        default x.TriggerSnippets(view : IWpfTextView) = ()

        override x.KeyDown(args : KeyEventArgs) = 
            use l = Logging.LogScope()
            match args.Key with
            | k when k = Key.F3 && Keyboard.Modifiers = ModifierKeys.None ->
                if not(String.IsNullOrEmpty(FindReplaceToolbar.Model.FindWhat)) then
                    FindReplaceToolbar.Model.IsVisible <- true
                    Controls.GetCurrentFindReplace().OnFindNext(textView)
            | k when k = Key.F3 && Keyboard.Modifiers = ModifierKeys.Shift ->
                if not(String.IsNullOrEmpty(FindReplaceToolbar.Model.FindWhat)) then
                    FindReplaceToolbar.Model.IsVisible <- true
                    Controls.GetCurrentFindReplace().OnFindPrevious(textView)
            | _ -> 
                base.KeyDown(args)

        member x.ExecuteHandler (target : Object) (ea : ExecutedRoutedEventArgs) =
            use l = Logging.LogScope()
            if (ea.Command :? RoutedUICommand) then
                match (ea.Command :?> RoutedUICommand) with
                | c when c = Commands.InsertSnippet -> 
                    if ea.OriginalSource :? IWpfTextView then
                        this.TriggerSnippets(ea.OriginalSource :?> IWpfTextView)
                | c when c = ApplicationCommands.Help ->
                    if ea.OriginalSource :? IWpfTextView then
                        ExecuteHelp(ea.OriginalSource :?> IWpfTextView)
                | c when 
                    c = Commands.TabifySelection ||
                    c = Commands.UntabifySelection ->
                        ea.Handled <- true
                        ExecuteTabify(textView)
                | c when 
                    c = Commands.MakeUppercase ||
                    c = Commands.MakeLowercase ->
                        ExecuteChangeCase(EditorHost.GetEditorOperations(textView),
                                           EditorHost.GetHistory(textView.TextBuffer))
                | c when c = Commands.GotoLine ->
                    Dialogs.ExecuteGotoLine(textView)
                | c when c = ApplicationCommands.Undo -> 
                    EditorHost.GetHistory(textView.TextBuffer).Undo(1)
                | c when c = ApplicationCommands.Redo -> 
                    EditorHost.GetHistory(textView.TextBuffer).Redo(1)
                | _ -> ()

        member x.QueryEnabledHandler (target : Object) (ea : CanExecuteRoutedEventArgs) =
            use l = Logging.LogScope()
            if (ea.Command :? RoutedUICommand) then
                ea.CanExecute <- 
                    match (ea.Command :?> RoutedUICommand) with
                    | c when c = Commands.InsertSnippet -> 
                        textView.VisualElement.IsKeyboardFocusWithin &&
                        not(textView.TextSnapshot.IsReadOnly(0)) &&
                        not(Provider.Posh.IsRunning)
                    | c when 
                        c = ApplicationCommands.Help ->
                            ea.OriginalSource :? IWpfTextView &&
                            (ea.OriginalSource :?> IWpfTextView).TextBuffer.CurrentSnapshot.Length > 0
                    | c when c = Commands.TabifySelection ||
                        c = Commands.UntabifySelection ||
                        c = Commands.TabifySelection ||
                        c = Commands.UntabifySelection ||
                        c = Commands.MakeUppercase ||
                        c = Commands.MakeLowercase ||
                        c = Commands.GotoLine -> 
                            textView.VisualElement.IsKeyboardFocusWithin &&
                            textView.TextBuffer.CurrentSnapshot.Length > 0
                    | c when c = ApplicationCommands.Undo -> 
                        textView.VisualElement.IsKeyboardFocusWithin && 
                        EditorHost.GetHistory(textView.TextBuffer).CanUndo
                    | c when c = ApplicationCommands.Redo -> 
                        textView.VisualElement.IsKeyboardFocusWithin && 
                        EditorHost.GetHistory(textView.TextBuffer).CanRedo
                    | _ -> false


    type Ps1EditorKeyProcessor(textView : IWpfTextView, 
                               completionBroker : ICompletionBroker,
                               signatureBrokerMap : ISignatureHelpBrokerMap,
                               toolTipProviderFactory : IToolTipProviderFactory) as this = 
        inherit KeyprocessorBase(textView, completionBroker, signatureBrokerMap, toolTipProviderFactory)
        let _braceMarkerProvider = EditorHost.GetBraceMarkerProvider(textView)
        let GetGroupStart(groupEnd : int) = 
            use l = Logging.LogScope()
            let mutable res = -1
            let cl = textView.TextBuffer.Properties.GetProperty<IPs1Classifier>(ClassifierPropertyName)
            let tokens = cl.Tokens
            let ge = GetTokenAt(groupEnd, cl)
            let mutable index = tokens.IndexOf(ge) - 1
            let stack = new Stack<PSToken>()
            while index > - 1 do
                let token = tokens.[index]
                if token.Type = PSTokenType.GroupEnd then
                    stack.Push(token)
                else if token.Type = PSTokenType.GroupStart then
                    if stack.Count = 0 then
                        if IsGroup(token.Content.Last(), ge.Content.First()) then
                            res <- token.Start + token.Length - 1
                        index <- -1
                    else if IsGroup(token.Content.Last(), stack.Peek().Content.First()) then
                        stack.Pop() |> ignore
                    else
                        index <- -1
                index <- index - 1
            res
        let GetGroupEnd(groupStart : int) = 
            use l = Logging.LogScope()
            let mutable res = -1
            let cl = textView.TextBuffer.Properties.GetProperty<IPs1Classifier>(ClassifierPropertyName)
            let tokens = cl.Tokens
            let gs = GetTokenAt(groupStart, cl)
            let mutable index = tokens.IndexOf(gs) + 1
            let stack = new Stack<PSToken>()
            while index < tokens.Count do
                let token = tokens.[index]
                if token.Type = PSTokenType.GroupStart then
                    stack.Push(token)
                else if token.Type = PSTokenType.GroupEnd then
                    if stack.Count = 0 then
                        if IsGroup(gs.Content.Last(), token.Content.First()) then
                            res <- token.Start + token.Length
                        index <- tokens.Count
                    else if IsGroup(stack.Peek().Content.Last(), token.Content.First()) then
                        stack.Pop() |> ignore
                    else
                        index <- tokens.Count
                index <- index + 1
            res
        let GetGroupSpan(index : int) : ITrackingSpan = 
            use l = Logging.LogScope()
            let mutable res = null
            let cl = textView.TextBuffer.Properties.GetProperty<IPs1Classifier>(ClassifierPropertyName)
            let gs = GetTokenAt(index, cl)
            let ge = GetTokenAt(index - 1, cl)
            if index > -1 && 
               index < textView.TextSnapshot.Length &&
               gs <> null && 
               gs.Type = PSTokenType.GroupStart
            then
                let last = GetGroupEnd(index)
                if last > - 1 then
                    let start = gs.Start + gs.Length - 1
                    res <- textView.TextSnapshot.CreateTrackingSpan(start, last - start, SpanTrackingMode.EdgeExclusive)
            else if index > 0 && 
                    index <= textView.TextSnapshot.Length && 
                    ge <> null && 
                    ge.Type = PSTokenType.GroupEnd
            then
                let first = GetGroupStart(index - 1)
                if first > - 1 then
                    res <- textView.TextSnapshot.CreateTrackingSpan(first, index - first, SpanTrackingMode.EdgeExclusive)
            res
        do
            use l = Logging.LogScope()
            let ownerType = textView.VisualElement.GetType()
            [| Commands.RunSelection;
                Commands.ToggleBreakpoint;
                Commands.CommentBlock;
                Commands.UncommentBlock;
                Commands.GotoDefinition;
            |] |> Seq.iter(fun command -> 
                use l = Logging.LogScope()
                RegisterCommandHandler(ownerType,
                                       command, 
                                       new ExecutedRoutedEventHandler(this.ExecuteHandler),
                                       new CanExecuteRoutedEventHandler(this.QueryEnabledHandler),
                                       null) |> ignore)
            textView.VisualElement
                    .ContextMenu <- Application.Current
                                                .FindResource("psePs1ContextMenu") :?> ContextMenu
            textView.Caret.PositionChanged.Add(fun ea -> 
                use l = Logging.LogScope()
                _braceMarkerProvider.Clear()
                _braceMarkerProvider.MarkBraces(GetGroupSpan(ea.NewPosition.Index))
            )
        
        let MatchSignatureHelp(classifier : IPs1Classifier, view : IWpfTextView) = 
            use l = Logging.LogScope()
            let start = max 0 view.Caret.Position.Index
            let token = classifier.GetTokenAt(start)
            let signatureBroker = signatureBrokerMap.GetBrokerForTextView(view)
            if token <> null && (token.Type = PSTokenType.Command || token.Type = PSTokenType.Member) then
                Ps1Completion.CurrentToken <- token
                if signatureBroker.IsSignatureHelpActive then 
                    signatureBroker.DismissAllSessions()
                signatureBroker.TriggerSignatureHelp() |> ignore
            view.TextBuffer.Insert(view.Caret.Position.Index, NativeAPI.ConvertKey(Key.D9)) |> ignore
            Ps1Completion.Types.None

        let MatchCommand(classifier : IPs1Classifier, view : IWpfTextView) = 
            use l = Logging.LogScope()
            let mutable res = Ps1Completion.Types.None
            let token = GetCurrentCommandToken(view.Caret.Position.Index, classifier)
            if token <> null then
                Ps1Completion.CurrentToken <- token
                if view.Caret.Position.Index = (token.Start + token.Length) then
                    Completion.CurrentSelection <- token.Content + "-"
                    res <- Ps1Completion.Types.Command
                else if view.Caret.Position.Index > 1 then 
                    let t = GetTokenAt(view.Caret.Position.Index - 1, classifier)
                    if t = null then
                        res <- Ps1Completion.Types.Parameter
            res

        let MatchVariableMember(token : PSToken, view : IWpfTextView) =
            use l = Logging.LogScope()
            Ps1Completion.CurrentToken <- token
            Ps1Completion.Types.Member

        let MatchTypeMember(token : PSToken, view : IWpfTextView) =
            use l = Logging.LogScope()
            let mutable res = Ps1Completion.Types.None
            if view.Caret.Position.Index < (token.Start + token.Length) then
                let left = view.TextBuffer.CurrentSnapshot
                                          .GetText(token.Start + 1, 
                                                   view.Caret.Position.Index - token.Start - 1)
                if not(String.IsNullOrEmpty(left) || left.EndsWith(".")) then
                    Ps1Completion.CurrentToken <- token
                    Completion.CurrentSelection <- token.Content + "."
                    res <- Ps1Completion.Types.Member
            res

        let MatchMember(classifier : IPs1Classifier, view : IWpfTextView) =
            use l = Logging.LogScope()
            let mutable res = Ps1Completion.Types.None
            let start = max 0 view.Caret.Position.Index
            let token = classifier.GetTokenAt(start)
            if token <> null then
                match token.Type with
                | PSTokenType.Variable ->
                    res <- MatchVariableMember(token, view)
                | PSTokenType.Type -> 
                    res <- MatchTypeMember(token, view)
                | PSTokenType.Member ->
                    Ps1Completion.CurrentToken <- token
                    res <- Ps1Completion.Types.Member
                | _ -> ()
            res

        let MatchStatic(classifier : IPs1Classifier, view : IWpfTextView) =
            use l = Logging.LogScope()
            let mutable res = Ps1Completion.Types.None
            let len = min view.TextBuffer.CurrentSnapshot.Length 2
            let start = max 0 (view.Caret.Position.Index - 2)
            let token = classifier.GetTokenAt(start)
            let sym = view.TextBuffer.CurrentSnapshot.GetText(start, len)
            if sym = "]:" then
                if token <> null && 
                   token.Type = PSTokenType.Type
                then
                    Ps1Completion.CurrentToken <- token
                    res <- Ps1Completion.Types.Static
            else 
                if token <> null && 
                   token.Type = PSTokenType.Variable
                then
                    Ps1Completion.CurrentToken <- token
                    res <- Ps1Completion.Types.Provider
            res

        let CompleteToken(text : string, token : PSToken, view : IWpfTextView) =
            use l = Logging.LogScope()
            if not(String.IsNullOrEmpty(text)) then
                view.Selection.Clear()
                if token.Type = PSTokenType.Type then
                    view.TextBuffer.Replace(new Span(token.Start + 1, token.Length - 2), text) |> ignore
                else if token.Type = PSTokenType.Variable then
                    let parts = token.Content.Split(':')
                    if parts.Length > 1 && not(IsPs1Scope(parts.[0])) then
                        if text.IndexOfAny(InvalidVariableSymbols) > -1 then
                            view.TextBuffer.Replace(new Span(token.Start + 1, token.Length - 1), 
                                                    String.Format("{{{0}:{1}}}", parts.[0], text)) |> ignore
                        else
                            view.TextBuffer.Replace(new Span(token.Start + 1, token.Length - 1), 
                                                    String.Format("{0}:{1}", parts.[0], text)) |> ignore
                    else if token.Content.IndexOfAny(InvalidVariableSymbols) > -1 || text.IndexOfAny(InvalidVariableSymbols) > -1 then
                        if IsPs1Scope(text.TrimStart([|'$'|]).Split(':').[0]) then
                            view.TextBuffer.Replace(new Span(token.Start, token.Length), text) |> ignore
                        else
                            view.TextBuffer.Replace(new Span(token.Start, token.Length), 
                                                    String.Format("${{{0}}}", text.TrimStart([|'$'|]))) |> ignore
                    else
                        view.TextBuffer.Replace(new Span(token.Start, token.Length), text) |> ignore
                else
                    view.TextBuffer.Replace(new Span(token.Start, token.Length), text) |> ignore

        let MatchShowAll(classifier : IPs1Classifier, view : IWpfTextView) = 
            use l = Logging.LogScope()
            let start = max 0 (view.Caret.Position.Index)
            let token = classifier.GetTokenAt(start)
            let mutable ret = Ps1Completion.Types.None
            if token <> null then
                match token.Type with 
                | PSTokenType.CommandParameter ->
                    let t = GetCurrentCommandToken(token.Start, classifier)
                    let pname = token.Content.Substring(1)
                    let res = Ps1Completion.CompleteParameterName(t, pname, view.TextBuffer)
                    if res.Count() = 1 then
                        CompleteToken("-" + res.First().Key, token, view)
                    else if res.Count() > 1 then
                        Completion.CurrentSelection <- pname
                        Completion.Filter.AddRange(res)
                        Ps1Completion.CurrentToken <- t
                        ret <- Ps1Completion.Types.Parameter
                | PSTokenType.Command ->
                    let props = ref (null :> IDictionary<string, IItem>)
                    if not(view.TextBuffer.Properties.TryGetProperty(FunctionsPropertyName, props)) then
                        props.Value <- new Dictionary<string, IItem>()
                    let res = Ps1Completion.CompleteCommandName(token.Content, props.Value)
                    if res.Count() = 1 then
                        CompleteToken(res.First().Key, token, view)
                    else if res.Count() > 1 then
                        Completion.CurrentSelection <- token.Content
                        Completion.Filter.AddRange(res)
                        Ps1Completion.CurrentToken <- token
                        ret <- Ps1Completion.Types.Command
                | PSTokenType.Type ->
                    let res = Ps1Completion.CompleteTypeName(token.Content)
                    if res.Count() = 1 then
                        let len = token.Content.Split('.').Last().Length
                        if len < res.First().Key.Length then
                            CompleteToken(res.First().Key, token, view)
                    else if res.Count() > 1 then
                        Completion.CurrentSelection <- token.Content
                        Completion.Filter.AddRange(res)
                        Ps1Completion.CurrentToken <- token
                        ret <- Ps1Completion.Types.Member
                | PSTokenType.Member ->
                    let opToken = GetTokenAt(token.Start - 1, classifier)
                    if opToken <> null then
                        let typeToken = GetTokenAt(opToken.Start - 1, classifier)
                        if typeToken <> null then
                            let res = Ps1Completion.CompleteMemberName(typeToken, token, view.TextBuffer)
                            if res.Count() = 1 then
                                CompleteToken(res.First().Key, token, view)
                            else if res.Count() > 1 then
                                Completion.CurrentSelection <- token.Content
                                Completion.Filter.AddRange(res)
                                Ps1Completion.CurrentToken <- token
                                ret <- Ps1Completion.Types.Member
                | PSTokenType.Variable ->
                    let props = ref (null :> IDictionary<string, IItem>)
                    if not(view.TextBuffer.Properties.TryGetProperty(VariablesPropertyName, props)) then
                        props.Value <- new Dictionary<string, IItem>()
                    let res = Ps1Completion.CompleteVariableName(token.Content, props.Value)
                    if res <> null then
                        if res.Count() = 1 then
                            CompleteToken(res.First().Key, token, view)
                        else if res.Count() > 1 then
                            Completion.CurrentSelection <- "$" + token.Content
                            Completion.Filter.AddRange(res)
                            Ps1Completion.CurrentToken <- token
                            ret <- Ps1Completion.Types.Member
                | PSTokenType.Operator | PSTokenType.CommandArgument ->
                    ()
                | _ -> 
                    ret <- Ps1Completion.Types.All
            else
                ret <- Ps1Completion.Types.All
            ret

        let ExecuteRunSelection(view : IWpfTextView) =
            use l = Logging.LogScope()
            if not(PSE.OutputWindow.IsVisible || 
                   PSE.Windows.Locals.IsVisible || 
                   PSE.Windows.Help.IsVisible) 
            then
                PSE.OutputWindow.IsVisible <- true
            DoEvents()
            let selection = view.Selection
                                .SelectionSpan
                                .GetText()
            if not(String.IsNullOrEmpty(selection)) then
                Provider.Posh.InvokeAsync(selection, 
                                          offset = view.Selection.SelectionSpan.Start, 
                                          formatWidth = 0,
                                          settings = new PSInvocationSettings(AddToHistory = true))
                view.Selection.Clear()
            else
                let line = view.TextBuffer.CurrentSnapshot.GetLineFromPosition(view.Caret.Position.Index)
                let text = line.GetText()
                if not(String.IsNullOrEmpty(text)) then
                    Provider.Posh.InvokeAsync(text, 
                                              offset = line.Start,
                                              formatWidth = 0,
                                              settings = new PSInvocationSettings(AddToHistory = true))

        let ExecuteToggleBreakpoint(view : IWpfTextView, mark : TextViewMarks) = 
            use l = Logging.LogScope()
            let wi = EditorHost.GetWorkItem(view)
            if wi <> null then
                let lineNumber = view.TextBuffer
                                     .CurrentSnapshot
                                     .GetLineFromPosition(view.Caret
                                                              .Position
                                                              .Index)
                                     .LineNumber
                let old = wi.Marks.FirstOrDefault(fun m ->
                    use l = Logging.LogScope()
                    m.Type = mark && m.LineNumber = lineNumber)
                if old = null then
                    let sn = view.TextBuffer.CurrentSnapshot
                    let line = sn.GetLineFromLineNumber(lineNumber)
                    let start = line.GetPositionOfNextNonWhiteSpaceCharacter(0)
                    let sp = sn.CreateTrackingSpan(line.Start + start, line.Length - start, SpanTrackingMode.EdgeExclusive)
                    Provider.Posh.Debugger.AddBreakpoint(wi, lineNumber + 1)
                    wi.Marks.Add(new TextViewMarkInfo(sp, mark))
                else
                    wi.Marks.Remove(old) |> ignore
                    Provider.Posh.Debugger.RemoveBreakpoint(wi, old.LineNumber + 1)
                wi.UpdateMarks()
                                           
        let ExecuteCommentBlock(view : ITextView) =
            use l = Logging.LogScope()
            use ut = EditorHost.GetHistory(view.TextBuffer).CreateTransaction("comment")
            let lines = 
                if view.Selection.IsEmpty then
                    [| GetLineNumber(view, view.Caret.Position.Index) |]
                else
                    let s = GetLineNumber(view, view.Selection.SelectionSpan.Start)
                    let e = GetLineNumber(view, view.Selection.SelectionSpan.End)
                    [| s..e |]
            for num in lines do
                let line = view.TextBuffer.CurrentSnapshot.GetLineFromLineNumber(num)
                if line.Start <> view.Selection.SelectionSpan.End then
                    view.TextBuffer.Insert(line.Start, "#") |> ignore
            let line = view.TextBuffer.CurrentSnapshot.GetLineFromLineNumber(lines.First())
            let len = 
                if lines.Length = 1 then
                    line.Length
                else
                    let index = lines.Last(fun i -> 
                        use l = Logging.LogScope()
                        let s = view.TextBuffer.CurrentSnapshot.GetLineFromLineNumber(i).Start
                        let e = view.Selection.SelectionSpan.End
                        s <> e)
                    view.TextBuffer.CurrentSnapshot.GetLineFromLineNumber(index).End - line.Start
            if len > 0 then
                view.Selection.Select(new Span(line.Start, len), false)
                view.Caret.MoveTo(view.Selection.SelectionSpan.End) |> ignore
            ut.Complete()
            
        let ExecuteUncommentBlock(view : ITextView) =
            use l = Logging.LogScope()
            use ut = EditorHost.GetHistory(view.TextBuffer).CreateTransaction("uncomment")
            let lines = 
                if view.Selection.IsEmpty then
                    [| GetLineNumber(view, view.Caret.Position.Index) |]
                else
                    let s = GetLineNumber(view, view.Selection.SelectionSpan.Start)
                    let e = GetLineNumber(view, view.Selection.SelectionSpan.End)
                    [| s..e |]
            for num in lines do
                let line = view.TextBuffer.CurrentSnapshot.GetLineFromLineNumber(num)
                let text = line.GetText()
                if not(String.IsNullOrEmpty(text)) && 
                   text.TrimStart([| ' '; '\t' |]).StartsWith("#")
                then
                    view.TextBuffer.Delete(new Span(line.Start + text.IndexOf('#'), 1)) |> ignore
            ut.Complete()

        let GetDefinitionToken(token : PSToken, tokens : IList<PSToken>, all : bool) = 
            use l = Logging.LogScope()
            let mutable res : PSToken = null
            try
                let mutable i = 0
                while i < tokens.Count do
                    if i > 0 &&
                       tokens.[i].Type = PSTokenType.CommandArgument &&
                       tokens.[i - 1].Type = PSTokenType.Keyword &&
                       IsEqual(tokens.[i - 1].Content, "function")
                    then
                        let mutable flag = IsEqual(tokens.[i].Content, "global:" + token.Content)
                        if all then
                            flag <- flag || IsEqual(tokens.[i].Content, token.Content)
                        if flag then
                            res <- tokens.[i]
                            i <- tokens.Count
                    i <- i + 1
            with ex -> Logging.LogException(ex, TraceLevel.Warning, null)
            res

        let GetDefinitionItem(view : IWpfTextView, token : PSToken) = 
            use l = Logging.LogScope()
            let mutable res : IItem = null
            try
                if token <> null && 
                   token.Type = PSTokenType.Command 
                then
                    let value = ref (null :> IItem)
                    let props = ref (null :> IDictionary<string, IItem>)
                    if view.TextBuffer.Properties.TryGetProperty(FunctionsPropertyName, props) && 
                       (props.Value.TryGetValue(token.Content, value) || 
                        props.Value.TryGetValue("global:" + token.Content, value) ||
                        props.Value.TryGetValue("local:" + token.Content, value) ||
                        props.Value.TryGetValue("script:" + token.Content, value))
                    then
                        res <- value.Value
                    if res = null then
                        let coll = Provider.Posh.GetProviderValue("function:" + token.Content)
                        if coll <> null then
                            let psobj = coll.First().BaseObject
                            if psobj <> null && psobj :? FunctionInfo then
                                let func = psobj :?> FunctionInfo
                                let err = ref (new Collection<PSParseError>())
                                let value = lazy(new Func<IList<PSToken>>(fun _ -> PSParser.Tokenize(File.ReadAllText(func.ScriptBlock.File), err) :> IList<PSToken>))
                                res <- new ItemBase(func.ScriptBlock.File, value)
                    if res = null && view.TextBuffer.Properties.TryGetProperty(ReferencesPropertyName, props) then
                        for reference in props.Value.Values do
                            if res = null && GetDefinitionToken(token, (reference.Value :?> Lazy<Func<IList<PSToken>>>).Value.Invoke(), false) <> null then
                                res <- reference
            with ex -> Logging.LogException(ex, TraceLevel.Warning, null)
            res

        let ExecuteGotoDefinition(view : IWpfTextView) = 
            use l = Logging.LogScope()
            let cl = view.TextBuffer.Properties.GetProperty<IPs1Classifier>(ClassifierPropertyName)
            let token = GetTokenAt(view.Caret.Position.Index, cl)
            let item = GetDefinitionItem(view, token)
            if item <> null then
                if File.Exists(item.Name) then
                    let wi = Controls.TabWorkItem.GetWorkItem(item.Name)
                    let target = GetDefinitionToken(token, (item.Value :?> Lazy<Func<IList<PSToken>>>).Value.Invoke(), true)
                    if target <> null then
                        DispatcherInvoke(DispatcherPriority.Background, new Action(fun _ -> 
                            use l = Logging.LogScope()
                            wi.Editor.TextView.Caret.MoveTo(target.Start) |> ignore
                            wi.Editor.TextView.ViewScroller.EnsureSpanVisible(new Span(target.Start, target.Length), 
                                                                              0., 
                                                                              wi.Editor.TextView.ViewportHeight / 2.) |> ignore
                        ), true) |> ignore
                else
                    let target = item.Value :?> PSToken
                    DispatcherInvoke(DispatcherPriority.Background, new Action(fun _ -> 
                        use l = Logging.LogScope()
                        view.Caret.MoveTo(target.Start) |> ignore
                        view.ViewScroller.EnsureSpanVisible(new Span(target.Start, target.Length), 
                                                            0., 
                                                            view.ViewportHeight / 2.) |> ignore
                    ), true) |> ignore

        override x.TriggerSnippets(view : IWpfTextView) = 
            use l = Logging.LogScope()
            ShowSnippets(view, ContentType.PowerShell)

        override x.KeyDown(args : KeyEventArgs) = 
            use l = Logging.LogScope()
            toolTipProviderFactory.GetToolTipProvider(textView).ClearToolTip()
            if args.Key <> Key.LeftShift && 
               args.Key <> Key.RightShift &&
               args.Key <> Key.LeftCtrl &&
               args.Key <> Key.RightCtrl
            then
                _braceMarkerProvider.Clear()
            let cl = textView.TextBuffer.Properties.GetProperty<IPs1Classifier>(ClassifierPropertyName)
            if (cl <> null) then 
                if completionBroker.IsCompletionActive then completionBroker.DismissAllSessions()
                Ps1Completion.CurrentToken <- null
                Ps1Completion.CompletionType <- 
                    match args.Key with
                    | k when k = Key.D9 &&
                             Keyboard.Modifiers = ModifierKeys.Shift &&
                             textView.Selection.IsEmpty  -> 
                        args.Handled <- true
                        MatchSignatureHelp(cl, textView)
                    | Key.OemMinus | Key.Subtract when Keyboard.Modifiers = ModifierKeys.None && 
                                                       textView.Selection.IsEmpty -> 
                        let res = MatchCommand(cl, textView)
                        args.Handled <- res <> Ps1Completion.Types.None
                        res
                    | Key.OemPeriod | Key.Decimal when Keyboard.Modifiers = ModifierKeys.None && 
                                                       textView.Selection.IsEmpty-> 
                        let res = MatchMember(cl, textView)
                        args.Handled <- res <> Ps1Completion.Types.None
                        res
                    | Key.Oem1 when Keyboard.Modifiers = ModifierKeys.Shift && 
                                    textView.Selection.IsEmpty -> 
                        let res = MatchStatic(cl, textView)
                        args.Handled <- res <> Ps1Completion.Types.None
                        res
                    | Key.Space when Keyboard.Modifiers = ModifierKeys.Control -> 
                        args.Handled <- true
                        MatchShowAll(cl, textView)
                    | Key.OemCloseBrackets | Key.D0 when Keyboard.Modifiers = ModifierKeys.Shift ->
                        DispatcherInvoke(DispatcherPriority.Background, 
                                         new Action(fun _ -> textView.Caret.MoveTo(textView.Caret.Position.Index) |> ignore), 
                                         true) |> ignore
                        Ps1Completion.Types.None
                    | _  -> 
                        base.KeyDown(args)
                        Ps1Completion.Types.None
            
                if Ps1Completion.CompletionType <> Ps1Completion.Types.None then 
                    completionBroker.TriggerCompletion().Dismissed.Add(fun _ -> Completion.Reset())
                    if Ps1Completion.CompletionType <> Ps1Completion.Types.All && Completion.Filter.Count = 0 then
                        textView.TextBuffer.Insert(textView.Caret.Position.Index, NativeAPI.ConvertKey(args.Key)) |> ignore

        member x.ExecuteHandler (target : Object) (ea : ExecutedRoutedEventArgs) =
            use l = Logging.LogScope()
            if (ea.Command :? RoutedUICommand) then
                match (ea.Command :?> RoutedUICommand) with
                | c when c = Commands.RunSelection -> 
                    let view = if ea.OriginalSource :? IWpfTextView then ea.OriginalSource :?> IWpfTextView else null
                    if view <> null then
                        ExecuteRunSelection(view)
                | c when c = Commands.ToggleBreakpoint ->
                    ExecuteToggleBreakpoint(textView, TextViewMarks.breakpoint)
                | c when c = Commands.CommentBlock ->
                    ExecuteCommentBlock(textView)
                | c when c = Commands.UncommentBlock ->
                    ExecuteUncommentBlock(textView)
                | c when c = Commands.GotoDefinition ->
                    let view = if ea.OriginalSource :? IWpfTextView then ea.OriginalSource :?> IWpfTextView else null
                    if view <> null then
                        ExecuteGotoDefinition(view)
                | _ -> ()

        member x.QueryEnabledHandler (target : Object) (ea : CanExecuteRoutedEventArgs) =
            use l = Logging.LogScope()
            if (ea.Command :? RoutedUICommand) then
                ea.CanExecute <- 
                    match (ea.Command :?> RoutedUICommand) with
                    | c when c = Commands.RunSelection ->
                        let doc = textView.TextBuffer
                                          .Properties
                                          .GetProperty<ITextBufferDocument>(DocumentPropertyName)
                        let view = if ea.OriginalSource :? IWpfTextView then ea.Source :?> IWpfTextView else null
                        if view = textView then
                            IsPowerShellDoc(doc) &&
                            textView.VisualElement.IsKeyboardFocusWithin &&
                            not(Provider.Posh.IsRunning) && 
                            textView.TextBuffer.CurrentSnapshot.Length > 0
                        else
                            view <> null &&
                            IsPowerShellDoc(doc) &&
                            not(Provider.Posh.IsRunning) && 
                            not(view.Selection.IsEmpty)
                    | c when c = Commands.ToggleBreakpoint ->
                        let doc = textView.TextBuffer
                                          .Properties
                                          .GetProperty<ITextBufferDocument>(DocumentPropertyName)
                        not((Host.Current :> IHostSupportsInteractiveSession).IsRunspacePushed) &&
                        not(IsEqual(Path.GetExtension(doc.FilePath), ".exe")) &&
                        IsPowerShellDoc(doc) &&
                        textView.VisualElement
                                .IsFocused && 
                        textView.TextBuffer
                                .CurrentSnapshot
                                .Length > 0
                    | c when c = Commands.CommentBlock ||
                             c = Commands.UncommentBlock -> 
                        textView.VisualElement
                                .IsFocused && 
                        textView.TextBuffer
                                .CurrentSnapshot
                                .Length > 0
                    | c when c = Commands.GotoDefinition ->
                        let mutable res = false
                        let view = if ea.OriginalSource :? IWpfTextView then ea.OriginalSource :?> IWpfTextView else null
                        if view <> null then
                            let cl = view.TextBuffer.Properties.GetProperty<IClassifier>(ClassifierPropertyName)
                            if cl :? IPs1Classifier then
                                res <- GetDefinitionItem(view, GetTokenAt(view.Caret.Position.Index, cl :?> IPs1Classifier)) <> null
                        res
                    | _ -> false


    type XmlEditorKeyProcessor(textView : IWpfTextView, 
                               completionBroker : ICompletionBroker,
                               signatureBrokerMap : ISignatureHelpBrokerMap,
                               toolTipProviderFactory : IToolTipProviderFactory) as this = 
        inherit KeyprocessorBase(textView, completionBroker, signatureBrokerMap, toolTipProviderFactory)
        do
            let f = new Action(fun _ -> 
                use l = Logging.LogScope()
                let ownerType = textView.VisualElement.GetType()
                [| Commands.CommentBlock;
                   Commands.UncommentBlock
                |] |> Seq.iter(fun command -> 
                    use l = Logging.LogScope()
                    RegisterCommandHandler(ownerType,
                                           command, 
                                           new ExecutedRoutedEventHandler(this.ExecuteHandler),
                                           new CanExecuteRoutedEventHandler(this.QueryEnabledHandler),
                                           null) |> ignore)
            )
            f.Invoke()

        let ExecuteCommentBlock(view : ITextView) =
            use l = Logging.LogScope()
            use ut = EditorHost.GetHistory(view.TextBuffer).CreateTransaction("comment")
            if view.Selection.IsEmpty then
                let line = view.TextBuffer.CurrentSnapshot.GetLineFromPosition(view.Caret.Position.Index)
                let pos = line.GetPositionOfNextNonWhiteSpaceCharacter(0)
                view.Selection.Select(new Span(line.Start + pos, line.Length - pos), false)
            else
                let line = view.TextBuffer.CurrentSnapshot.GetLineFromPosition(view.Selection.SelectionSpan.Start)
                let pos = line.GetPositionOfNextNonWhiteSpaceCharacter(0)
                let el = view.TextBuffer.CurrentSnapshot.GetLineFromPosition(view.Selection.SelectionSpan.End)
                let epos = 
                    if el.Start = view.Selection.SelectionSpan.End then
                        view.TextBuffer.CurrentSnapshot.GetLineFromLineNumber(el.LineNumber - 1).End
                    else
                        view.Selection.SelectionSpan.End
                view.Selection.Select(new Span(line.Start + pos, epos - line.Start - pos), false)
            view.TextBuffer.Insert(view.Selection.SelectionSpan.Start, "<!-- ") |> ignore
            //let last = view.TextBuffer.CurrentSnapshot.GetLineFromPosition(view.Selection.SelectionSpan.End)
            view.TextBuffer.Insert(view.Selection.SelectionSpan.End, " -->") |> ignore
            view.Selection.Select(new Span(view.Selection.SelectionSpan.Start - 5, 
                                           view.Selection.SelectionSpan.Length + 9), false)
            ut.Complete()
            
        let ExecuteUncommentBlock(view : ITextView) =
            use l = Logging.LogScope()
            use ut = EditorHost.GetHistory(view.TextBuffer).CreateTransaction("uncomment")
            if view.Selection.IsEmpty then
                let line = view.TextBuffer.CurrentSnapshot.GetLineFromPosition(view.Caret.Position.Index)
                let pos = line.GetPositionOfNextNonWhiteSpaceCharacter(0)
                view.Selection.Select(new Span(line.Start + pos, line.Length - pos), false)
            let text = view.Selection.SelectionSpan.GetText()
            if not(String.IsNullOrEmpty(text)) then
                let ttext = text.Trim([| ' '; '\t' |])
                if ttext.StartsWith("<!-- ") && ttext.EndsWith(" -->") then
                    view.TextBuffer.Delete(new Span(view.Selection.SelectionSpan.Start + text.IndexOf("<!-- "), 5)) |> ignore
                    view.TextBuffer.Delete(new Span(view.Selection.SelectionSpan.Start - 5 + text.LastIndexOf(" -->"), 4)) |> ignore
            ut.Complete()

        override x.KeyDown(args : KeyEventArgs) = 
            use l = Logging.LogScope()
            toolTipProviderFactory.GetToolTipProvider(textView).ClearToolTip()
            match args.Key with
            | k when k = Key.Space && Keyboard.Modifiers = ModifierKeys.Control ->
                args.Handled <- true
                completionBroker.TriggerCompletion() |> ignore
            | k when k = Key.OemPeriod && Keyboard.Modifiers = ModifierKeys.Shift ->
                if not(textView.Selection.IsEmpty) then
                    textView.TextBuffer.Delete(textView.Selection.SelectionSpan.Span) |> ignore
                let mutable text = textView.TextBuffer.CurrentSnapshot.GetText(0, textView.Caret.Position.Index)
                let start = text.LastIndexOf('<', textView.Caret.Position.Index - 1)
                if start > -1 && 
                   text.IndexOf('>', start) = -1 && 
                   text.IndexOf("/>", start) = -1 
                then
                    let last = text.IndexOf(' ', start, textView.Caret.Position.Index - start - 1)
                    if last > -1 then
                        text <- text.Substring(start + 1, last - start - 1).Trim([| '\r'; '\n'; |])
                    else
                        text <- text.Substring(start + 1, textView.Caret.Position.Index - start - 1).Trim([| '\r'; '\n'; |])
                    if not(String.IsNullOrEmpty(text)) then
                        args.Handled <- true
                        textView.TextBuffer.Insert(textView.Caret.Position.Index, "></" + text + ">") |> ignore
                        textView.Caret.MoveTo(textView.Caret.Position.Index - text.Length - 3) |> ignore
            | k when k = Key.OemPlus && Keyboard.Modifiers = ModifierKeys.None ->
                let propPath = XmlLib.GetPropertyPath(textView.TextBuffer.CurrentSnapshot, 
                                                      textView.Caret.Position.Index)
                if propPath.Length > 0 then
                    args.Handled <- true
                    textView.TextBuffer.Insert(textView.Caret.Position.Index, "=\"\"") |> ignore
                    textView.Caret.MoveTo(textView.Caret.Position.Index - 1) |> ignore
            | _ -> base.KeyDown(args)

        member x.ExecuteHandler (target : Object) (ea : ExecutedRoutedEventArgs) =
            use l = Logging.LogScope()
            let editorOperations = EditorHost.GetEditorOperations(textView)
            if (ea.Command :? RoutedUICommand) then
                match (ea.Command :?> RoutedUICommand) with
                | c when c = Commands.CommentBlock ->
                    ExecuteCommentBlock(textView)
                | c when c = Commands.UncommentBlock ->
                    ExecuteUncommentBlock(textView)
                | _ -> ()

        member x.QueryEnabledHandler (target : Object) (ea : CanExecuteRoutedEventArgs) =
            use l = Logging.LogScope()
            let editorOperations = EditorHost.GetEditorOperations(textView)
            if (ea.Command :? RoutedUICommand) then
                ea.CanExecute <- 
                    match (ea.Command :?> RoutedUICommand) with
                    | c when 
                        c = Commands.CommentBlock ||
                        c = Commands.UncommentBlock -> 
                        textView.VisualElement
                                .IsFocused && 
                        textView.TextBuffer
                                .CurrentSnapshot
                                .Length > 0
                    | _ -> false


    type Ps1XmlEditorKeyProcessor(textView : IWpfTextView, 
                                  completionBroker : ICompletionBroker,
                                  signatureBrokerMap : ISignatureHelpBrokerMap,
                                  toolTipProviderFactory : IToolTipProviderFactory) = 
        inherit XmlEditorKeyProcessor(textView, completionBroker, signatureBrokerMap, toolTipProviderFactory)
        do
            ()


    type XamlEditorKeyProcessor(textView : IWpfTextView, 
                                completionBroker : ICompletionBroker,
                                signatureBrokerMap : ISignatureHelpBrokerMap,
                                toolTipProviderFactory : IToolTipProviderFactory) = 
        inherit XmlEditorKeyProcessor(textView, completionBroker, signatureBrokerMap, toolTipProviderFactory)

        override x.TriggerSnippets(view : IWpfTextView) = 
            use l = Logging.LogScope()
            ShowSnippets(view, ContentType.Xaml)

        override x.KeyDown(args : KeyEventArgs) = 
            use l = Logging.LogScope()
            match args.Key with
            | k when k = Key.Space && Keyboard.Modifiers = ModifierKeys.None ->
                if not(textView.Selection.IsEmpty) then
                    textView.TextBuffer.Delete(textView.Selection.SelectionSpan.Span) |> ignore
                let propPath = XmlLib.GetPropertyPath(textView.TextBuffer.CurrentSnapshot, textView.Caret.Position.Index)
                if propPath.Length > 0 then
                    args.Handled <- true
                    textView.TextBuffer.Insert(textView.Caret.Position.Index, " ") |> ignore
                    completionBroker.TriggerCompletion() |> ignore
                else
                    base.KeyDown(args)
            | k when (k = Key.OemPeriod || k = Key.Decimal) && Keyboard.Modifiers = ModifierKeys.None ->
                if not(textView.Selection.IsEmpty) then
                    textView.TextBuffer.Delete(textView.Selection.SelectionSpan.Span) |> ignore
                let propPath = XmlLib.GetPropertyPath(textView.TextBuffer.CurrentSnapshot, textView.Caret.Position.Index - 1)
                if propPath.Length > 0 then
                    args.Handled <- true
                    textView.TextBuffer.Insert(textView.Caret.Position.Index, ".") |> ignore
                    completionBroker.TriggerCompletion() |> ignore
                else
                    base.KeyDown(args)
            | k when k = Key.OemComma && Keyboard.Modifiers = ModifierKeys.Shift ->
                if not(textView.Selection.IsEmpty) then
                    textView.TextBuffer.Delete(textView.Selection.SelectionSpan.Span) |> ignore
                args.Handled <- true
                textView.TextBuffer.Insert(textView.Caret.Position.Index, "<") |> ignore
                completionBroker.TriggerCompletion() |> ignore
            | _ -> base.KeyDown(args)


open KeyProcessors

[<Name("EditorKeyProcessorProvider")>]
[<Order(Before="DefaultKeyProcessor")>]
[<ExtensionProduction(typeof<IKeyProcessorFactoryExtension>)>]
[<Sealed>]
type internal EditorKeyProcessorProvider() =
    inherit KeyProcessorFactory()
    [<ServiceConsumption>]
    static let mutable CompletionBrokerMap : ICompletionBrokerMap = null
    [<ServiceConsumption>]
    static let mutable SignatureHelpBrokerMap : ISignatureHelpBrokerMap = null
    [<ServiceConsumption>]
    let mutable ToolTipProviderFactory : IToolTipProviderFactory = null

    override x.GetAssociatedProcessor(wpfTextViewHost : IWpfTextViewHost) : KeyProcessor =
        use l = Logging.LogScope()
        match wpfTextViewHost.TextView.TextBuffer.ContentType.TypeName with
        | name when IsEqual(name, ContentType.PowerShell.ToString()) ->
            new Ps1EditorKeyProcessor(wpfTextViewHost.TextView, 
                                      CompletionBrokerMap.GetBrokerForTextView(wpfTextViewHost.TextView),
                                      SignatureHelpBrokerMap,
                                      ToolTipProviderFactory) :> KeyProcessor
        | name when IsEqual(name, ContentType.Xml.ToString()) ->
            new XmlEditorKeyProcessor(wpfTextViewHost.TextView, 
                                      CompletionBrokerMap.GetBrokerForTextView(wpfTextViewHost.TextView),
                                      SignatureHelpBrokerMap,
                                      ToolTipProviderFactory) :> KeyProcessor
        | name when IsEqual(name, ContentType.Ps1Xml.ToString()) ->
            new Ps1XmlEditorKeyProcessor(wpfTextViewHost.TextView, 
                                         CompletionBrokerMap.GetBrokerForTextView(wpfTextViewHost.TextView),
                                         SignatureHelpBrokerMap,
                                         ToolTipProviderFactory) :> KeyProcessor
        | name when IsEqual(name, ContentType.Xaml.ToString()) ->
            new XamlEditorKeyProcessor(wpfTextViewHost.TextView, 
                                       CompletionBrokerMap.GetBrokerForTextView(wpfTextViewHost.TextView),
                                       SignatureHelpBrokerMap,
                                       ToolTipProviderFactory) :> KeyProcessor
        | _ -> new KeyprocessorBase(wpfTextViewHost.TextView, 
                                    CompletionBrokerMap.GetBrokerForTextView(wpfTextViewHost.TextView),
                                    SignatureHelpBrokerMap,
                                    ToolTipProviderFactory) :> KeyProcessor
