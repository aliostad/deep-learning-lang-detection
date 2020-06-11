using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Text;
using System.Windows.Automation;

namespace UIAutomationWrapper
{
    partial class AutomationWrapper
    {
        public InvokeWrapper Invoke
        {
            get
            {
                Debugger.NotifyOfCrossThreadDependency();
                return new InvokeWrapper(this, GetPattern<InvokePattern>(InvokePattern.Pattern));
            }
        }

        public class InvokeWrapper : PatternWrapper<InvokePattern>
        {
            public InvokeWrapper(AutomationWrapper automationWrapper, InvokePattern pattern)
                : base(automationWrapper, pattern)
            {
            }

            public void Invoke()
            {
                Pattern.Invoke();
            }

            public event AutomationEventHandler Invoked
            {
                add { AutomationWrapper.AddEvent(InvokePattern.InvokedEvent, value); }
                remove { AutomationWrapper.RemoveEvent(value); }
            }
        }
    }
}
