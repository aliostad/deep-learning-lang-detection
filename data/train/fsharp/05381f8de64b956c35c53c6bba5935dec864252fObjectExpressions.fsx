

// Object Expressions, see -> http://msdn.microsoft.com/en-us/library/dd233237%28VS.100%29.aspx

let obj1 = { new System.Object() with member x.ToString() = "F#" }
printfn "%A" obj1 


// interface
type IIdentifiable<'T> =
    abstract GetName : unit -> string
    abstract Id : 'T 
        with get 

// anonymous
let implementer() = { new IIdentifiable<int> with
                        member this.Id = 70150
                        member this.GetName() = this.GetType().Name + ":" + this.Id.ToString()
                        }


let i = implementer()
i.Id




// example: anonymous IDisposable
module TimerExtensions =
    type System.Timers.Timer with
        static member StartWithDisposable interval handler = 
        
            let timer = new System.Timers.Timer (interval)

            do timer.Elapsed.Add handler
            timer.Start()

            // return anonymous IDisposable implementation
            { new System.IDisposable with
                member self.Dispose() =
                    do timer.Stop()
                    do printfn "Timer stopped" }
        

// lets try the timer
open TimerExtensions

let useTimer = 
    let handler = ( fun _ -> printfn "time elapsed" )
    use timer = System.Timers.Timer.StartWithDisposable 100.0 handler
    System.Threading.Thread.Sleep 1000
