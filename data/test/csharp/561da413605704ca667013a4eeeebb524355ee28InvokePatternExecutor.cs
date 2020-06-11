using System.Windows.Automation;

namespace WinAutomationService.Support
{
    public class InvokePatternExecutor : IExecutable
    {

        public AutomationElement InvocableItem { get; set; }

        public InvokePatternExecutor(AutomationElement invocableItem)
        {
            InvocableItem = invocableItem;
        }

        public object Execute()
        {
            var ip = InvocableItem.GetCurrentPattern(InvokePattern.Pattern) as InvokePattern;
            ip?.Invoke();
            return null;
        }
    }
}