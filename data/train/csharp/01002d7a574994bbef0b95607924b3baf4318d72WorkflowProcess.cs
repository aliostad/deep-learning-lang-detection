namespace Services.Pipeline.StateControl
{
    using System;

    public class WorkflowProcess
    {
        public static void StepByStepWorkflow(params Action[] actions)
        {
            foreach (var action in actions)
            {
                action.Invoke();
            }
        }

        public static void BasicWorkflow(Action load, Action execute, Action finish, Action unload)
        {
            load.Invoke();
            execute.Invoke();
            finish.Invoke();
            unload.Invoke();
        }
    }
}
