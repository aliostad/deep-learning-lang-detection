using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using ProcessManager.Models;
using ProcessBasice.ChangLiang;

namespace Test
{
    class ProcessCreatHelper
    {
        public static List<ProcessProcessModel> createProcess(int pid, int bid, List<string> liuchengren)
        {

            List<ProcessProcessModel> lprocess = new List<ProcessProcessModel>();
            int order = 0;
            foreach (string renyuan in liuchengren)
            {
                ProcessProcessModel process = new ProcessProcessModel();
                process.Pid = pid;
                process.Bid = bid;
                process.Order = order;
                if (process.Order == 0)
                {
                    process.Handler = "发起人";
                    process.Nexthandler = renyuan;
                    process.Lasthandler = ProcessState.BEGIN.ToString();
                    process.State = ProcessState.FINISH;
                }
                else if (liuchengren.IndexOf(renyuan) == liuchengren.Count - 1)
                {
                    process.Handler = renyuan;
                    process.Nexthandler = PredefineState.FINISH.ToString();
                    process.Lasthandler = liuchengren[liuchengren.IndexOf(renyuan) - 1];
                    process.State = ProcessState.DEFINE;
                }
                else
                {
                    process.Handler = renyuan;
                    process.Nexthandler = liuchengren[liuchengren.IndexOf(renyuan) + 1];
                    process.Lasthandler = liuchengren[liuchengren.IndexOf(renyuan) - 1];
                    process.State = ProcessState.DEFINE;
                }
                lprocess.Add(process);
                order += 100;

            }
            return lprocess;
        }
    }
}
