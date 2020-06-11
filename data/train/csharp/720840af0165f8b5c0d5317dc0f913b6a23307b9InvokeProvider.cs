using System;
using System.Collections.Generic;
using System.Windows.Automation;
using System.Windows.Automation.Provider;
using System.Windows.Forms;
using UIA.Extensions.AutomationProviders.Interfaces;

namespace UIA.Extensions.AutomationProviders
{
    public class InvokeProvider : ControlProvider, IInvokeProvider
    {
        private readonly Action _invokable;

        public InvokeProvider(InvokeControl invokable) : base(invokable.Control, InvokePattern.Pattern)
        {
            _invokable = invokable.Invoke;
        }

        public InvokeProvider(Control control, Action invokable) : base(control, InvokePattern.Pattern)
        {
            _invokable = invokable;
        }

        public void Invoke()
        {
            _invokable();
        }
    }
}