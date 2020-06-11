using System;

namespace CIAOD.PriorityQueues
{
    class Program
    {
        static void Main(string[] args)
        {
            Console.WriteLine("Нажмите любую клавишу для выхода\n\n");

            //ProcessManager<ListPriorityQueue<Process>, Process> pm =
            //    new ProcessManager<ListPriorityQueue<Process>, Process>();

            ProcessManager<HeapPriorityQueue<Process>, Process> pm =
                new ProcessManager<HeapPriorityQueue<Process>, Process>();

            pm.Add(new Process(1));
            pm.Add(new Process(2));
            pm.Add(new Process(3));
            pm.Add(new Process(4));

            pm.Run();

            Console.ReadKey();
            Console.WriteLine(Environment.NewLine);
        }
    }
}
