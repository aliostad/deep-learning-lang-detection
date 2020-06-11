// ----------------------------------------------------------------------------
// This file is subject to the terms and conditions defined in
// file 'LICENSE.txt', which is part of this source code package.
// ----------------------------------------------------------------------------
module Yaaf.Shell.Event

/// Executes f just after adding the event-handler
let guard f (e:IEvent<'Del, 'Args>) = 
    let e = Event.map id e
    { new IEvent<'Args> with 
        member x.AddHandler(d) = e.AddHandler(d); f()
        member x.RemoveHandler(d) = e.RemoveHandler(d)
        member x.Subscribe(observer) = 
          let rm = e.Subscribe(observer) in f(); rm }
