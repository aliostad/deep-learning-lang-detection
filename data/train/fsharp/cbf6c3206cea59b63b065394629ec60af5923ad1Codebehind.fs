module RZ.Wpf.CodeBehind

open System.Windows.Input
open FSharp.Core.Fluent
open RZ.Foundation

(********* Command Handler *********)
type ICommandControlCenter =
  abstract CanExecute: ICommand * obj -> bool
  abstract Execute: ICommand * obj -> unit

type ICommandHandler =
  abstract ControlCenter: ICommandControlCenter

[<CompilationRepresentation(CompilationRepresentationFlags.ModuleSuffix)>]
module ICommandHandler =
    let controlCenter (inf: ICommandHandler) = inf.ControlCenter

type CommandHandler<'a> = (obj -> bool) * (obj -> 'a)
type CommandMap<'a> = (ICommand * CommandHandler<'a>)

let CommandControlCenter handler commandList =
  let commandMap = System.Collections.Generic.Dictionary<ICommand,CommandHandler<'a>>()

  commandList |> Seq.iter commandMap.Add

  { new ICommandControlCenter with
    member __.CanExecute(cmd, param) =
      match commandMap.TryGetValue(cmd) with
      | false, _ -> false
      | true, (q, _) -> q param

    member __.Execute(cmd, param) =
      match commandMap.TryGetValue(cmd) with
      | false, _ -> ()
      | true, (_, c) -> handler <| c param
  }

module CommandMap =
  let to' converter cmd :CommandMap<'a> = cmd, ((constant true), converter)
  let check checker converter cmd :CommandMap<'a> = cmd, (checker, converter)

(********* Code behind initializers *********)
let private reportError (asm: System.Reflection.Assembly) resourceName: unit = 
  let availableResources =
    ResourceManager.getResourceLookup(asm)
    |> Map.toSeq
    |> Seq.map fst

  let sb = System.Text.StringBuilder()
  sb.AppendLine(sprintf "Cannot find resource %s in the calling assembly %A" resourceName asm.FullName)
    .AppendLine("\tAvailable resources:") |> ignore

  availableResources.iter(sprintf "\t\t%s" >> sb.AppendLine >> ignore)

  let txt = sb.ToString()
  System.Diagnostics.Debug.Print txt
  failwith txt

type System.Windows.Media.Visual with
  member rootObj.InitializeCodeBehind (resourceName: string) =
    let asm = rootObj.GetType().Assembly
    asm |> ResourceManager.findWpfResource resourceName
        |> Option.cata 
          (fun() -> reportError asm resourceName)
          (XamlLoader.createFromXamlObj rootObj >> ignore)

module private Internal =
  let inline getCommandHandler(me: System.Windows.FrameworkElement) =
    me.DataContext
      .tryCast<ICommandHandler>()
      .map(ICommandHandler.controlCenter)

type System.Windows.FrameworkElement with
  member me.ForwardCanExecute(e: CanExecuteRoutedEventArgs) =
    Internal
      .getCommandHandler(me)
      .do'(fun handler -> e.CanExecute <- handler.CanExecute(e.Command, e.Parameter); e.Handled <- true)

  member me.ForwardExecuted(e: ExecutedRoutedEventArgs) =
    Internal
      .getCommandHandler(me)
      .do'(fun handler -> handler.Execute(e.Command, e.Parameter); e.Handled <- true)

  member me.InstallCommandForwarder() =
    let canExecuteHandler = CanExecuteRoutedEventHandler(fun _ e -> me.ForwardCanExecute(e))
    let executeHandler = ExecutedRoutedEventHandler(fun _ e -> me.ForwardExecuted(e))
    
    me.Loaded.Add(fun _ ->
      CommandManager.AddCanExecuteHandler(me, canExecuteHandler)
      CommandManager.AddExecutedHandler(me, executeHandler)
    )
    me.Unloaded.Add(fun _ ->
      CommandManager.RemoveCanExecuteHandler(me, canExecuteHandler)
      CommandManager.RemoveExecutedHandler(me, executeHandler)
    )

    