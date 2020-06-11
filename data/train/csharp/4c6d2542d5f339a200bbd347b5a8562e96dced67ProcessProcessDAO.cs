using System;
using System.Collections.Generic;
using System.Linq;
using ProcessManager.Models;
using ProcessBasice.ChangLiang;
using ProcessManager.ProcessInterface;

namespace ProcessManager.DAO
{
    /// <summary>
    /// 详细表数据层
    /// </summary>
    public class ProcessProcessDAO:IProcessDao<ProcessProcessModel>
    {
        /// <summary>
        /// 使用PID和ORDER查找单个详细流程数据
        /// </summary>
        /// <param name="pid">pid</param>
        /// <param name="order">order</param>
        /// <returns></returns>
        public ProcessProcessModel selectByIdOrder(int pid,int order)
        {
            using (ProcessManagerDbEntities db = new ProcessManagerDbEntities())
            {
                Process process = selectProcessbyIdorder(pid, order,db);
                ProcessProcessModel processmodel = processToProcessModel(process);
                return processmodel;
            }
        }

        /// <summary>
        /// 使用PID查找整个详细流程数据
        /// </summary>
        /// <param name="pid">pid</param>
        /// <returns></returns>
        public List<ProcessProcessModel> selectById(int pid)
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

        /// <summary>
        /// 修改单个详细流程数据
        /// </summary>
        /// <param name="processmodel">改好的详细流程</param>
        /// <returns></returns>
        public int update(ProcessProcessModel processmodel)
        {
            using (ProcessManagerDbEntities db = new ProcessManagerDbEntities())
            {
                Process process = selectProcessbyIdorder(processmodel.Pid, processmodel.Order,db);
                processModelToProcess(processmodel, process);
                int i = db.SaveChanges();
                return i;
            }
        }

        /// <summary>
        /// 修改整个详细流程数据
        /// </summary>
        /// <param name="processlist">改好的整个详细流程</param>
        /// <returns></returns>
        public int updatelist(List<ProcessProcessModel> processlist)
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
        
        /// <summary>
        /// 插入单个流程数据
        /// </summary>
        /// <param name="processmodel">需插入的数据</param>
        public int insert(ProcessProcessModel processmodel)
        {
            using(ProcessManagerDbEntities db=new ProcessManagerDbEntities())
            {
                Process process = processModelToProcess(processmodel);
                db.Process.Add(process);
                int i= db.SaveChanges();
                return i;
            }
        }

        /// <summary>
        /// 插入整个流程数据
        /// </summary>
        /// <param name="processmodellist">需插入的数据</param>
        public int insertList(List<ProcessProcessModel> processmodellist)
        {
            using(ProcessManagerDbEntities db=new ProcessManagerDbEntities())
            {
                processmodellist.ForEach(processmodel =>
                {
                    Process process = processModelToProcess(processmodel);
                    db.Process.Add(process);

                });
                int i= db.SaveChanges();
                return i;
            }
        }


        /// <summary>
        /// process转换为processmodel
        /// </summary>
        /// <param name="process"></param>
        /// <returns></returns>
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
            processmodel.sdate = (DateTime)process.sdate;
            return processmodel;
        }

        /// <summary>
        /// processmodel转换为process
        /// </summary>
        /// <param name="processmodel"></param>
        /// <param name="process"></param>
        /// <returns></returns>
        private Process processModelToProcess(ProcessProcessModel processmodel,Process process=null)
        {
            if(process==null)
            {
                process = new Process();
                process.id = Guid.NewGuid();
            }
            process.pid = processmodel.Pid;
            process.bid = processmodel.Bid;
            process.steps = processmodel.Order;
            process.hanlder = processmodel.Handler;
            process.nexthanlder = processmodel.Nexthandler;
            process.lasthanlder = processmodel.Lasthandler;
            process.state = Enum.GetName(typeof(ProcessState),processmodel.State);
            process.sdate = processmodel.sdate;
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