using System;

namespace HP41CV.Models
{
    public class InvokeActionModel : ActionModel
    {
        protected Action Action;
        protected Action<object> InvokeAction;

        public InvokeActionModel(string text) : base(text)
        {
        }

        public InvokeActionModel(Action action, string text) : base(text)
        {
            Action = action;
        }

        public void SetInvokeAction(Action<object> invokeAction)
        {
            InvokeAction = invokeAction;
        }

        public override void Execute(bool noUpn)
        {
            if (CanExecute() && (Action != null))
            {
                Action.Invoke();
            }
            InvokeAction?.Invoke(null);
        }
    }
}
