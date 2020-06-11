#light

namespace ApplicationCore

module XamlHelpers =

    open System
    open System.IO
    open System.Reflection
    open System.Windows
    open System.Windows.Controls
    open System.Windows.Input
    open System.Windows.Markup

    let getResourceName name = sprintf "%s.xaml" name

    let getResourceStream name (asm:Assembly) = 
        asm.GetManifestResourceStream <| getResourceName name

    let loadXaml<'a> name asm =
        use stream = getResourceStream name asm
        if null = stream then failwith (sprintf "Couldn't find a resource named %s" name)
        stream |> XamlReader.Load :?> 'a

    let commandHandler (f:obj -> ExecutedRoutedEventArgs -> unit) =
        new ExecutedRoutedEventHandler(f)        

    let commandPredicate (f:obj -> CanExecuteRoutedEventArgs -> bool) =
        new CanExecuteRoutedEventHandler(fun s e -> e.CanExecute <- f s e)
        
    let command (control:Control) cmd handler predicate : unit =
        new CommandBinding(cmd, (commandHandler handler), (commandPredicate predicate))
            |> control.CommandBindings.Add
            |> ignore
            
            