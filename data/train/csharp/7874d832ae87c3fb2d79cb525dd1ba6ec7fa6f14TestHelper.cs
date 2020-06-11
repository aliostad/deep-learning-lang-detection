using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using ProcessBasice.Helper;
using ProcessManager.Models;
using ProcessBasice.ChangLiang;

namespace ProcessManager.Helper
{
    public class TestHelper
    {
        public static List<ProcessProcessModel> processCreateProcess(int pid, int bid, List<string> liuchengren)
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

        public static ProcessPredefineModel createPredefine(IList<ProcessPredefineModel> lprocess, int order = 0)
        {
            List<ProcessPredefineModel> listProcess = (List<ProcessPredefineModel>)lprocess;
            listProcess.Sort();
            ProcessPredefineModel predefine = new ProcessPredefineModel();
            predefine.Bid = listProcess[order].Bid;
            predefine.Pid = listProcess[order].Pid;
            predefine.Order = listProcess[order].Order;
            predefine.Handler = listProcess[order].Handler;
            predefine.Nexthandler = listProcess[order].Nexthandler;
            predefine.Lasthandler = listProcess[order].Lasthandler;
            predefine.State = PredefineState.PROCESSING;
            return predefine;
        }
    }
}