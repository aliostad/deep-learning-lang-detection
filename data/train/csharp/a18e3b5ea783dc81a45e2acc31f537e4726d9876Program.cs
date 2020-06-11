using AsyncWorker;

namespace Demo
{
    internal class Program
    {
        private static void DemoAction()
        {
            var w = new DemoWidget();
            w.InvokeAction("A");
            w.InvokeAction("B");
            w.WaitAndDump("Action").Wait();
        }

        private static void DemoTask()
        {
            var w = new DemoWidget();
            w.InvokeTask("A");
            w.InvokeTask("B");
            w.WaitAndDump("Task").Wait();
        }

        private static void DemoTaskAtomic()
        {
            var w = new DemoWidget();
            w.InvokeTask("A", InvokeOptions.Atomic);
            w.InvokeTask("B", InvokeOptions.Atomic);
            w.WaitAndDump("Task").Wait();
        }

        private static void DemoTaskAtomic2()
        {
            var w = new DemoWidget();
            w.InvokeTask("A");
            w.InvokeTask("B", InvokeOptions.Atomic);
            w.WaitAndDump("Task").Wait();
        }

        private static void DemoBarrier()
        {
            var w = new DemoWidget();
            w.InvokeTask("A");
            w.InvokeTask("B");
            w.SetBarrier();
            w.InvokeTask("C");
            w.InvokeTask("D");
            w.WaitAndDump("Task").Wait();
        }

        private static void Main(string[] args)
        {
            DemoAction();
            DemoTask();
            DemoTaskAtomic();
            DemoTaskAtomic2();
            DemoBarrier();
        }
    }
}
