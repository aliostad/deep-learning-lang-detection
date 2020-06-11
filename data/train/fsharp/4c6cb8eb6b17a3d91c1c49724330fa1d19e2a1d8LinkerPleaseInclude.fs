namespace SampleForms.DroidF

open System
open System.Collections.Specialized
open System.Windows.Input
open Android.App
open Android.Views
open Android.Widget

// This class is never actually executed, but when Xamarin linking is enabled it does how to ensure types and properties
// are preserved in the deployed app
type LinkerPleaseInclude() = 

    member this.Include(button: Button) = 
        button.Click.AddHandler <| EventHandler(fun s e -> button.Text <- button.Text + "")
    
    member this.Include(checkBox: CheckBox) = 
        EventHandler<CompoundButton.CheckedChangeEventArgs>(fun sender args -> checkBox.Checked <- not checkBox.Checked) 
        |> checkBox.CheckedChange.AddHandler
    
    member this.Include(``switch``: Switch) = 
        EventHandler<CompoundButton.CheckedChangeEventArgs>(fun sender args -> ``switch``.Checked <- not ``switch``.Checked)
        |> ``switch``.CheckedChange.AddHandler
    
    member this.Include(view: View) = 
        EventHandler(fun s e  -> view.ContentDescription <- view.ContentDescription + "")
        |> view.Click.AddHandler
    
    member this.Include(text: TextView): unit = 
        EventHandler<Android.Text.TextChangedEventArgs>(fun s a -> text.Text <- "" + text.Text)
        |> text.TextChanged.AddHandler
        text.Hint <- "" + text.Hint

    member this.Include(text: CheckedTextView): unit =
        EventHandler<Android.Text.TextChangedEventArgs>(fun s a -> text.Text <- "" + text.Text)
        |> text.TextChanged.AddHandler
        text.Hint <- "" + text.Hint
    
    member this.Include(cb: CompoundButton) = 
        EventHandler<CompoundButton.CheckedChangeEventArgs>(fun s a -> cb.Checked <- not cb.Checked)
        |> cb.CheckedChange.AddHandler
    
    member this.Include(sb: SeekBar) =
        EventHandler<SeekBar.ProgressChangedEventArgs>(fun s a -> sb.Progress <- sb.Progress + 1)
        |> sb.ProgressChanged.AddHandler
    
    member this.Include(act: Activity) = 
        act.Title <- act.Title + ""

    member this.Include(changed: INotifyCollectionChanged) = 
        NotifyCollectionChangedEventHandler(fun s a -> () //let test = string.Format("01234", e.Action, e.NewItems, e.NewStartingIndex, e.OldItems, e.OldStartingIndex
                                                                        ) 
        |> changed.CollectionChanged.AddHandler

    member this.Include(command: ICommand) = 
        EventHandler(fun s a -> if (command.CanExecute(null)) then command.Execute(null) )
        |> command.CanExecuteChanged.AddHandler
    
    member this.Include(injector: MvvmCross.Platform.IoC.MvxPropertyInjector byref) = 
        injector <- new MvvmCross.Platform.IoC.MvxPropertyInjector()
   
    member this.Include(changed: System.ComponentModel.INotifyPropertyChanged) =
        ComponentModel.PropertyChangedEventHandler(fun s e -> let test = e.PropertyName
                                                              ())
        |> changed.PropertyChanged.AddHandler
        
        
    


