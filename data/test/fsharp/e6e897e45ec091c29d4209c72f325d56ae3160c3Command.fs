//===============================================================================
// Microsoft patterns & practices
// Parallel Programming Guide
//===============================================================================
// Copyright © Microsoft Corporation.  All rights reserved.
// This code released under the terms of the 
// Microsoft patterns & practices license (http://parallelpatterns.codeplex.com/license).
//===============================================================================

namespace Microsoft.Practices.ParallelGuideSamples.ADash.ViewModel

open System
open System.Diagnostics
open System.Windows.Input

/// A command object recognized by WPF. 
/// Implements the System.Windows.Input.ICommand interface.
type Command(execute, canExecute) =
    let mutable canExecuteChangedHandler : EventHandler = null

    /// Creates a new command that can always execute.
    new(execute) = Command(execute, (fun _ -> true))

    /// Causes the CanExecuteChanged handler to run.
    /// (Should only be invoked by the view model)
    member x.NotifyExecuteChanged() =
        let handler = canExecuteChangedHandler
        if handler <> null then
            handler.Invoke(x, EventArgs.Empty)

    /// ICommand interface members
    interface ICommand with

        /// <summary>
        /// Tests whether the current data context allows this command to be run
        /// </summary>
        /// <param name="parameter">Parameter passed to the object's CanExecute delegate</param>
        /// <returns>True if the command is currently enabled; false if not enabled.</returns>
        [<DebuggerStepThrough>]
        member x.CanExecute (parameter:obj) = canExecute parameter
        
        /// Event that is raised when the "CanExecute" status of this command changes
        [<CLIEvent>]
        member x.CanExecuteChanged =
          { new IDelegateEvent<EventHandler> with
              member x.AddHandler(h) =
                  canExecuteChangedHandler <- Delegate.Combine(canExecuteChangedHandler, h) :?> EventHandler
                  CommandManager.RequerySuggested.AddHandler(h)
              member x.RemoveHandler(h) =
                  canExecuteChangedHandler <- Delegate.Remove(canExecuteChangedHandler, h) :?> EventHandler
                  CommandManager.RequerySuggested.RemoveHandler(h) }

        /// Performs the work of the "execute" delegate.
        member x.Execute (parameter:obj) = execute parameter
