using System;
using GameCore.Core.Extentions;
using UnityEngine.Events;

namespace GameCore.Core.Services.UI.ViewModel
{
    public class BindingCommand
    {
        private Action _command;
        public BindingCommand(Action command)
        {
            _command = command;
        }

        public void Bind(Action onInvokeCommand)
        {
            onInvokeCommand += _command;
        }

        public void Bind(UnityEvent onInvokeCommand)
        {
            onInvokeCommand.AddListener(InvokeCommand);
        }

        public void UnBind(Action onInvokeCommand)
        {
            onInvokeCommand -= _command;
        }

        public void UnBind(UnityEvent onInvokeCommand)
        {
            onInvokeCommand.RemoveListener(InvokeCommand);
        }

        public void ClearBindings()
        {
            _command.ClearAllHandlers();
        }

        private void InvokeCommand()
        {
            _command();
        }
    }

    public class BindingCommand<TType>
    {
        private Action<TType> _command;
        public BindingCommand(Action<TType> command)
        {
            _command = command;
        }

        public void Bind(Action<TType> onInvokeCommand)
        {
            onInvokeCommand += _command;
        }

        public void Bind(UnityEvent<TType> onInvokeCommand)
        {
            onInvokeCommand.AddListener(InvokeCommand);
        }

        public void UnBind(Action<TType> onInvokeCommand)
        {
            onInvokeCommand -= _command;
        }

        public void UnBind(UnityEvent<TType> onInvokeCommand)
        {
            onInvokeCommand.RemoveListener(InvokeCommand);
        }

        public void ClearBindings()
        {
            _command.ClearAllHandlers();
        }

        private void InvokeCommand(TType value)
        {
            _command(value);
        }
    }
}
