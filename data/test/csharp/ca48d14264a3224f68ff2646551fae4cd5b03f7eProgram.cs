using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Vancl.TMS.Schedule.PreDispatchImpl;
using System.Threading;
using System.Timers;

namespace PreDispatchTest
{
    class Program
    {
        static void Main(string[] args)
        {
            DoPreDispatch();
        }

        protected static void _timer_Elapsed(object sender, ElapsedEventArgs e)
        {
            Thread th = new Thread(DoPreDispatch);
            th.Start();
            Console.WriteLine("Start a new thread");
        }

        static void DoPreDispatch()
        {
            PreDispatchJob pdj = new PreDispatchJob();
            pdj.DoJob(null);
        }
    }
}
