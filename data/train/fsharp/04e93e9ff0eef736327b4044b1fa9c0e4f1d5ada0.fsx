open System.Windows.Input

let createCommand action canExecute=
            let event1 = Event<_, _>()
            {
                new ICommand with
                    member this.CanExecute(obj) = canExecute(obj)
                    member this.Execute(obj) = action(obj)
                    member this.add_CanExecuteChanged(handler) = event1.Publish.AddHandler(handler)
                    member this.remove_CanExecuteChanged(handler) = event1.Publish.AddHandler(handler)
            }

let myCommand = createCommand
                        (fun _ -> ())
                        (fun _ -> true)