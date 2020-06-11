using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;

namespace InvokeCount
{
    class Program
    {
        public static ManagerInvoke managerInvoke;
        static void Main(string[] args)
        {
            managerInvoke = new ManagerInvoke(new TimeSpan(0, 0, 1), new TimeSpan(0, 0, 20));
            managerInvoke.CountInvoke += ManagerInvokeCountInvoke;
            managerInvoke.Statistic += ManagerInvokeStatistic;
            managerInvoke.Start();
            var task = new Timer(Dub);
            task.Change(5, 4);
            for (var i = 0; i < 10000; i++)
            {
                task = new Timer(Dub);
                task.Change(i, 4);
            }

            var task2 = new Timer(Dub);
            task2.Change(15, 5);
            var task3 = new Timer(Dub);
            task3.Change(7, 8);
            Console.ReadKey();
            managerInvoke.Stop();
            Console.ReadKey();
            managerInvoke.Start();
            Console.ReadKey();
            task.Dispose();
        }

        private static void ManagerInvokeStatistic(object sender, StatisticStructure e)
        {
            Console.WriteLine($"Max invoke = {e.MaxCountInvoke}, Min invoke = {e.MinCountInvoke}, Middle invoke = {e.MiddleCountInvoke}");
        }

        private static void Dub(object state)
        {
            managerInvoke.Invoke();
        }
        private static void ManagerInvokeCountInvoke(object sender, int e)
        {
            Console.WriteLine($"Count invoke = {e}");
        }
    }
}
