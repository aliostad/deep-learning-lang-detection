using System;
using System.Collections.Generic;
using System.Linq;
using ProcessManager.Models;
using ProcessBasice.ChangLiang;

namespace Test
{
    public class ProcessProcessDAO
    {
        public ProcessProcessModel selectProcessModelByidorder(int pid,int order)
        {
            using (ProcessManagerDbEntities db = new ProcessManagerDbEntities())
            {
                Process process = selectProcessbyIdorder(pid, order,db);
                ProcessProcessModel processmodel = processToProcessModel(process);
                return processmodel;
            }
        }

        public List<ProcessProcessModel> selectProcessModelByid(int pid)
        {
            using (ProcessManagerDbEntities db = new ProcessManagerDbEntities()) {
                var selectstring = from p in db.Process where p.pid == pid select p;
                List<Process> processs = selectstring.ToList();
                List<ProcessProcessModel> processmodels = new List<ProcessProcessModel>();
                processs.ForEach(process =>
                {
                    ProcessProcessModel processmodel = processToProcessModel(process);
                    processmodels.Add(processmodel);
                });
                return processmodels;
            }
        }

        public int updateProcess(ProcessProcessModel processmodel)
        {
            using (ProcessManagerDbEntities db = new ProcessManagerDbEntities())
            {
                Process process = selectProcessbyIdorder(processmodel.Pid, processmodel.Order,db);
                processModelToProcess(processmodel, process);
                int i = db.SaveChanges();
                return i;
            }
        }

        public int updateProcesslist(List<ProcessProcessModel> processlist)
        {
            using (ProcessManagerDbEntities db = new ProcessManagerDbEntities())
            {
                
                processlist.ForEach(processmodel =>
                {
                    Process process = selectProcessbyIdorder(processmodel.Pid, processmodel.Order, db);
                    processModelToProcess(processmodel, process);
                });
                int i= db.SaveChanges();
                return i;
            }
        }

        public void insertProcessModel(ProcessProcessModel processmodel)
        {
            using(ProcessManagerDbEntities db=new ProcessManagerDbEntities())
            {
                Process process = processModelToProcess(processmodel);
                db.Process.Add(process);
                db.SaveChanges();
            }
        }

        public void insertProcessModelList(List<ProcessProcessModel> processmodellist)
        {
            using(ProcessManagerDbEntities db=new ProcessManagerDbEntities())
            {
                processmodellist.ForEach(processmodel =>
                {
                    Process process = processModelToProcess(processmodel);
                    db.Process.Add(process);

                });
                db.SaveChanges();
            }
        }


        private ProcessProcessModel processToProcessModel(Process process)
        {
            ProcessProcessModel processmodel = new ProcessProcessModel();
            processmodel.Pid = (int)process.pid;
            processmodel.Bid = (int)process.bid;
            processmodel.Order = (int)process.steps;
            processmodel.Handler = process.hanlder;
            processmodel.Nexthandler = process.nexthanlder;
            processmodel.Lasthandler = process.lasthanlder;
            processmodel.State = (ProcessState)Enum.Parse(typeof(ProcessState), process.state);
            return processmodel;
        }

        private Process processModelToProcess(ProcessProcessModel processmodel,Process process=null)
        {
            if(process==null)
            {
                process = new Process();
            }
            process.pid = processmodel.Pid;
            process.bid = processmodel.Bid;
            process.steps = processmodel.Order;
            process.hanlder = processmodel.Handler;
            process.nexthanlder = processmodel.Nexthandler;
            process.lasthanlder = processmodel.Lasthandler;
            process.state = Enum.GetName(typeof(ProcessState),processmodel.State);
            return process;
        }

        private Process selectProcessbyIdorder(int pid,int order,ProcessManagerDbEntities db)
        {
                var selectstring = from p in db.Process
                                   where p.pid == pid && p.steps == order
                                   select p;
                Process process = selectstring.First();
                return process;
        }
    }
}