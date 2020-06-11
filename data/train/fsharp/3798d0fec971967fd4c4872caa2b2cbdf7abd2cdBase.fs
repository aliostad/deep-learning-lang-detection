// Copyright 2015 Alexey Martseniuk. All rights reserved.
// Use of this source code is governed by a GPL V3 license
// that can be found in the LICENSE file.

namespace PowerShellSE

open System
open System.ComponentModel
open System.IO
open System.Collections.Generic
open System.Reflection
open System.Threading
open System.Windows
open System.Windows.Data
open System.Windows.Threading
open System.Windows.Input
open System.Security.Principal
open System.Linq
open System.Management.Automation


[<Flags>]
type HelpCategory =
| Alias = 1
| All = 0xfff
| Cmdlet = 2
| DefaultHelp = 0x1000
| ExternalScript = 0x800
| FAQ = 0x20
| Filter = 0x400
| Function = 0x200
| General = 0x10
| Glossary = 0x40
| HelpFile = 0x80
| None = 0
| Provider = 4
| ScriptCommand = 0x100
 
    
[<Flags>]
type FindFlags =
| None = 0
| MatchCase = 1
| FindInReverse = 2
| FindWholeWordsOnly = 4
| MatchDiacritics = 8
| MatchKashida = 16
| MatchAlefHamza = 32
| UseRegularExpressions = 64

type CommandKey(commandName : string, moduleName : string) as this =
    new(commandName : string) =
        new CommandKey(commandName, null)
    member x.Name = commandName
    member x.ModuleName = 
        if String.IsNullOrEmpty(moduleName) then null else moduleName
    override x.Equals(o) = 
        let mutable res = Object.ReferenceEquals(o, this)
        if not(res) && o <> null && (o :? CommandKey) then
            res <- this.ToString().CompareTo(o) = 0
        res
    override x.GetHashCode() = this.ToString().GetHashCode()
    override x.ToString() = 
        if String.IsNullOrEmpty(this.ModuleName) then
            this.Name
        else
            String.Format("{0}#{1}", this.ModuleName, this.Name)
    interface IComparable with
        member x.CompareTo(obj) = 
            String.Compare(this.ToString(), 
                           (obj :?> CommandKey).ToString(), 
                           StringComparison.OrdinalIgnoreCase)

[<AutoOpen>]
module internal Base = 
    module InternalImpl =
        let CreateDelegate =
            let mi = typeof<Delegate>
                        .GetMethod("CreateDelegate", 
                            BindingFlags.Static ||| 
                            BindingFlags.NonPublic, 
                            null, 
                            [| typeof<Type>; typeof<Object>; typeof<RuntimeMethodHandle> |],
                            null)
            let t = typeof<Func<Type, Object, RuntimeMethodHandle, Delegate>>
            (Delegate.CreateDelegate(t, mi) :?> Func<Type, Object, RuntimeMethodHandle, Delegate>)

    open InternalImpl
    //****************************************************************************************************

    let IsElevated = (new WindowsPrincipal(WindowsIdentity.GetCurrent())).IsInRole(WindowsBuiltInRole.Administrator)
    let inline IsEqual(s1 : string, s2 : string) = String.Compare(s1, s2, StringComparison.OrdinalIgnoreCase) = 0
    let inline NullToEmpty(x) = if String.IsNullOrEmpty(x) then String.Empty else x
    let inline IsPs1Scope(sc : string) = IsEqual(sc, "local") || IsEqual(sc, "global") || IsEqual(sc, "script") || IsEqual(sc, "private")

    let GetResourceName(asm : Assembly) = asm.FullName.Split([|','|]).[0] + ".g"
    let GetExecutingAssembly() = Assembly.GetExecutingAssembly()
    let LocalResourceName = GetResourceName(GetExecutingAssembly())

    [<AllowNullLiteral>]
    type SynchronizedObject() =
        let _sync = new Object()
        let mutable _isSync = false
        
        member x.IsSynchronized 
            with get() = lock _sync (fun _ -> _isSync)
            and set(value) = lock _sync (fun _ -> _isSync <- value)
            
        member x.Invoke(del : Func<'A>) =
            if x.IsSynchronized then lock _sync (del.Invoke) else del.Invoke()

    type AttributeKey =
        static member Type = "type"
        static member Parameters = "parameters"

    type AttributeType =
    | None = 0
    | Namespace = 1
    | Class = 2
    | Delegate = 3
    | ValueType = 4
    | Enum = 5
    | Interface = 6
    | Method = 7
    | Property = 8
    | Variable = 9
    | Drive = 10
    | Tag = 11

    type ContentType =
    | PowerShell = 1
    | text = 2
    | Xml = 3
    | Xaml = 4
    | TextOutput = 5
    | Ps1Xml = 6

    [<AllowNullLiteral>]
    type IItem =
        abstract member Attributes : IDictionary<string, obj>
        abstract member Name : string with get
        abstract member Value : obj with get,set

    [<AllowNullLiteral>]
    type IContainer =
        inherit IItem
        abstract member Childs : seq<IItem>

    type ItemBase(name, value) =
        let mutable _value = value
        let _attrs = new Dictionary<string, obj>(StringComparer.OrdinalIgnoreCase)
        new(name) =
            new ItemBase(name, null)

        interface IItem with
            member x.Attributes = _attrs :> IDictionary<string, obj>
            member x.Name 
                with get() = name
            member x.Value 
                with get() = _value
                and set(value) = _value <- value

    type ContainerBase(name) as this =
        inherit ItemBase(name)
        let _childs = new List<IItem>()

        member x.Add(name, value) = 
            _childs.Add(new ItemBase(name, value) :> IItem)
            _childs :> seq<IItem>

        member x.AddRange(items) = 
            _childs.AddRange(items)
            _childs :> seq<IItem>

        member x.Remove(name) = 
            let index = _childs.FindIndex(fun it -> name.Equals(it.Name))
            if index > -1 then _childs.RemoveAt(index)
            _childs :> seq<IItem>

        member x.Clear() = 
            _childs.Clear() 
            _childs :> seq<IItem>

        interface IContainer with
            member x.Childs = _childs :> seq<IItem>

        interface IItem with
            member x.Value = box (this :> IContainer).Childs

    type MethodBase with
        member x.BindDelegate(t : Type, obj) =
            CreateDelegate.Invoke(t, obj, x.MethodHandle)

    type FastPropertyChangedEventHandler() =
        let mutable _handler : PropertyChangedEventHandler = null
        member x.Trigger(sender, args) =
            if _handler <> null then
                _handler.Invoke(sender,args)
        member x.Publish = x :> IDelegateEvent<PropertyChangedEventHandler>
        interface IDelegateEvent<PropertyChangedEventHandler> with
            member x.AddHandler(d) = _handler <- Delegate.Combine(_handler, d) :?> PropertyChangedEventHandler
            member x.RemoveHandler(d) = _handler <- Delegate.Remove(_handler, d)  :?> PropertyChangedEventHandler
            
    type FastEventHandler<'Args when 'Args :> EventArgs>() =
        let mutable _handler : EventHandler<'Args> = null
        member x.Trigger(sender, args) =
            if _handler <> null then
                _handler.Invoke(sender,args)
        member x.Publish = x :> IDelegateEvent<EventHandler<'Args>>
        interface IDelegateEvent<EventHandler<'Args>> with
            member x.AddHandler(d) = _handler <- Delegate.Combine(_handler, d) :?> EventHandler<'Args>
            member x.RemoveHandler(d) = _handler <- Delegate.Remove(_handler, d)  :?> EventHandler<'Args>

    type FastEventHandler() =
        let mutable _handler : EventHandler = null
        member x.Trigger(sender, args) =
            if _handler <> null then
                _handler.Invoke(sender,args)
        member x.Publish = x :> IDelegateEvent<EventHandler>
        interface IDelegateEvent<EventHandler> with
            member x.AddHandler(d) = _handler <- Delegate.Combine(_handler, d) :?> EventHandler
            member x.RemoveHandler(d) = _handler <- Delegate.Remove(_handler, d)  :?> EventHandler

    type Command(execute : Action<Object>, canexcute : Func<obj, bool>) = 
        let _canExecute = new FastEventHandler()
        interface ICommand with
            [<CLIEvent>]
            member x.CanExecuteChanged = _canExecute.Publish
            member x.CanExecute(obj) = canexcute.Invoke(obj)
            member x.Execute(p) = execute.Invoke(p)

    let RegisterCommandHandler(owner : Type, 
                               command : RoutedCommand, 
                               execute : ExecutedRoutedEventHandler, 
                               canExecute :  CanExecuteRoutedEventHandler,
                               [<ParamArray>] inputGestures : InputGesture[]) =
        let binding = new CommandBinding(command, execute, canExecute)
        CommandManager.RegisterClassCommandBinding(owner, binding)
        if inputGestures <> null then
            for g in inputGestures do
                CommandManager.RegisterClassInputBinding(owner, new InputBinding(command, g))
        command

    let PropGet(obj, name) = 
        obj.GetType()
           .GetProperty(name, 
               BindingFlags.Instance |||
               BindingFlags.NonPublic |||
               BindingFlags.GetProperty)
           .GetValue(obj, null)

    let PropGetProp(obj, name) = 
        obj.GetType()
           .GetProperty(name, 
               BindingFlags.Instance |||
               BindingFlags.NonPublic |||
               BindingFlags.GetProperty)

    let GetMethod(t : Type, name) = 
        t.GetMethod(name, 
            BindingFlags.Instance |||
            BindingFlags.NonPublic |||
            BindingFlags.InvokeMethod)  
                  
    let GetParent<'T when 'T :> DependencyObject> (start : DependencyObject) = 
        let mutable p = start
        while p <> null && not (p :? 'T) do
            match p with
            | :? FrameworkElement as fe -> p <- fe.Parent
            | :? FrameworkContentElement as fce -> p <- fce.Parent
            | _ -> p <- null
        p :?> 'T

    let IsPowerShellSourceFile(path : string) = 
        if not(String.IsNullOrEmpty(path)) then
            match Path.GetExtension(path).ToLower() with
            | ".ps1" | ".psm1" -> true
            | _ -> false
        else
            false

    let MatchBraces(left, right) = 
        match left with
        | "{" -> "}".Equals(right)
        | "[" -> "]".Equals(right)
        | "(" -> ")".Equals(right)
        | _ -> false

    let IsUntitled(path) = Path.GetExtension(path).Equals(".tmp", StringComparison.OrdinalIgnoreCase)

    type OutputType = 
    | Output = 0
    | Error = 1
    | Warning = 2
    | Verbose = 3

    let GetProcessType() = 
        match IntPtr.Size with
        | 8 -> "x64"
        | 4 -> "x86"
        | _ -> "Unknown"

    let ObjectToEnumConverter<'T when 'T :> Enum >(value : obj, def : 'T) : 'T =  
        match value with
        | null -> def
        | :? 'T -> value :?> 'T
        | _ -> Enum.Parse(typeof<'T>, value.ToString(), true) :?> 'T

    let GetValueOrDefault(value : Option<'T>) = 
        match value with
        | Some v -> v
        | None -> Unchecked.defaultof<'T>

    type SizeChangedArgs(width : double, height : double) =
        inherit EventArgs()
        member x.Width = width
        member x.Height = height

    [<AllowNullLiteral>]
    type IHostSupportHelpView = 
        abstract member UpdateHelp : bool with get, set 

    [<AllowNullLiteral>]
    type IHostSupportTranscribing = 
        abstract member IsTranscribing : bool with get, set
        abstract member StartTrascripting : string * bool -> unit
        abstract member StopTrascripting : unit -> string
        abstract member Script : string with get

    let InvalidVariableSymbols = [| '.'; '-'; ':'; '\\'; '('; ')'; '%'; '?'; ' '; |]
    let BuiltInExtensions = [| "Microsoft.PowerShell.Diagnostics";
                               "Microsoft.WSMan.Management";
                               "Microsoft.PowerShell.Core";
                               "Microsoft.PowerShell.Utility";
                               "Microsoft.PowerShell.Host";
                               "Microsoft.PowerShell.Management";
                               "Microsoft.PowerShell.Security"; |]

    let XamlNamespaces = [| "System.Diagnostics";
                            "System.Windows";
                            "System.Windows.Automation";
                            "System.Windows.Controls";
                            "System.Windows.Controls.Primitives";
                            "System.Windows.Data";
                            "System.Windows.Documents";
                            "System.Windows.Documents.DocumentStructures";
                            "System.Windows.Ink";
                            "System.Windows.Input";
                            "System.Windows.Markup";
                            "System.Windows.Media";
                            "System.Windows.Media.Animation";
                            "System.Windows.Media.Effects";
                            "System.Windows.Media.Imaging";
                            "System.Windows.Media.Media3D";
                            "System.Windows.Media.TextFormatting";
                            "System.Windows.Navigation";
                            "System.Windows.Shapes"; |]

    type Type with 
        member x.IsXamlType = 
            x.IsPublic &&
            not(x.IsNested) &&
            XamlNamespaces.FirstOrDefault(fun ns -> IsEqual(ns, x.Namespace)) <> null &&
            x.GetConstructor(Type.EmptyTypes) <> null &&
            (x.IsSubclassOf(typeof<DispatcherObject>) || 
             x.IsSubclassOf(typeof<SetterBase>) || 
             x.GetInterface("System.ComponentModel.INotifyPropertyChanged") <> null ||
             x.GetInterface("System.Windows.Data.IValueConverter") <> null ||
             x.GetInterface("System.Windows.Data.IMultiValueConverter") <> null)


    let IsGroup(s : char, e : char) =
        match s with
        | '{' -> e = '}'
        | '(' -> e = ')'
        | '[' -> e = ']'
        | _ -> false

    let GetPsObjectValue(coll : IList<PSObject>) = 
        let mutable res = box(coll)
        if coll <> null && coll.Count = 1 then
            if coll.[0] <> null &&  coll.[0].BaseObject <> null then
                res <- coll.[0].BaseObject
            else
                res <- coll.[0]
        res


[<AllowNullLiteral>]
type SupportPropertyChanged() as this =
    let _propertyChanged = new FastPropertyChangedEventHandler()
    member internal x.OnPropertyChanged(name) = _propertyChanged.Trigger(this, new PropertyChangedEventArgs(name))
    interface INotifyPropertyChanged with
        [<CLIEvent>]
        member x.PropertyChanged = _propertyChanged.Publish

