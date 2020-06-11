
using System.Windows.Automation;

[assembly: guitarlib.RegisterEvent(typeof(guitarlib.InvokeEventMaker))]

namespace guitarlib {

    public class InvokeEventMaker : EventMaker
    {
        private static InvokeEventMaker instance = new InvokeEventMaker();

        public static InvokeEventMaker Instance
        {
            get
            {
                return instance;
            }
        }

        public override bool isSupportedBy(WidgetI component)
        {
            AutomationElement element = component.Element;
            return (bool) element.GetCurrentPropertyValue(
                AutomationElement.IsInvokePatternAvailableProperty);
        }

        public override Ice.Object makeObject(WidgetI component)
        {
            return new InvokeEvent(component);
        }
    }

    public class InvokeEvent : ActionDisp_
    {
        public static readonly string Name = "Invoke";
        private WidgetI component;

        public InvokeEvent(WidgetI component) {
            this.component = component;
        }

        public override void perform(Ice.Current context__)
        {
            AutomationElement element = component.Element;
            if (isActable(element))
            {
                InvokePattern pattern =
                    element.GetCurrentPattern(InvokePattern.Pattern) as InvokePattern;
                pattern.Invoke();
            }
        }

        public override string getEventType(Ice.Current context__)
        {
            return InvokeEvent.Name;
        }

        private bool isActable(AutomationElement element)
        {
            return element != null && element.Current.IsEnabled;
        }
    }
}