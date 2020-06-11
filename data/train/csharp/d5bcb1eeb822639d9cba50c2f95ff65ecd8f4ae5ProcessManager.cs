// Crimenuts (c) 2015 Krokodev
// Crimenuts.App.Ajax
// ProcessManager.cs

using System;
using Crimenuts.App.Ajax.Game.Server.Clients;
using Crimenuts.App.Ajax.Game.Server.Models;
using Crimenuts.Core.Game.Enums;
using Crimenuts.Core.Game.Processes;
using Crimenuts.Core.Game.Schemas;
using Krokodev.Common.Identifier;

namespace Crimenuts.App.Ajax.Game.Server.Managers
{
    public class ProcessManager : IProcessManager
    {
        #region Constructor

        public ProcessManager( IGameClient clients )
        {
            _clients = clients;
        }

        #endregion


        #region IProcessManager

        public IProcessManager IManager
        {
            get { return this; }
        }

        ProcessModel IProcessManager.GetModel( string processId )
        {
            var process = GetProcess( processId );
            var model = new ProcessModel( process );
            return model;
        }

        void IProcessManager.AutoAnswer( string processId )
        {
            var process = GetProcess( processId );
            process.ExecuteUserAction( Process.UserAction.ActionType.AutoAsk );
            _clients.ProcessUpdated( new ProcessModel( process ) );
        }

        void IProcessManager.Reset()
        {
            Schema.ResetProcesses();
            _clients.ProcessesReset();
        }

        void IProcessManager.Arrest( string processId, int memberId )
        {
            var process = GetProcess( processId );
            process.ExecuteUserAction( Process.UserAction.ActionType.Arrest, memberId );
            _clients.ProcessUpdated( new ProcessModel( process ) );
        }

        void IProcessManager.Annotate( string processId, int memberId, AnswerCode annotation )
        {
            var process = GetProcess( processId );
            process.Annotate( memberId, annotation );
            _clients.ProcessUpdated( new ProcessModel( process ) );
        }

        public void Continue( string processId )
        {
            var process = GetProcess( processId );
            process.ExecuteUserAction( Process.UserAction.ActionType.Continue );
            _clients.ProcessUpdated( new ProcessModel( process ) );
        }

        public void EarlyArrest( string processId, int memberId )
        {
            var process = GetProcess( processId );
            process.ExecuteUserAction( Process.UserAction.ActionType.EarlyArrest, memberId );
            _clients.ProcessUpdated( new ProcessModel( process ) );
        }

        #endregion


        #region Fields

        private readonly IGameClient _clients;

        #endregion


        #region Utils

        private static Identifiable< Process, int >.Identifier ConvertToProcessIdentifier( string processId )
        {
            return ( Identifiable< Process, int >.Identifier ) Convert.ToInt64( processId );
        }

        private static Process GetProcess( string processId )
        {
            var id = ConvertToProcessIdentifier( processId );
            return Schema.FindProcess( id );
        }

        #endregion
    }
}