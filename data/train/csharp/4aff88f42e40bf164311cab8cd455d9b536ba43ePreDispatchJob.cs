using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Vancl.TMS.Core.Schedule;
using Vancl.TMS.IBLL.Transport.Dispatch;
using Vancl.TMS.Core.ServiceFactory;
using Vancl.TMS.Model.Transport.PreDispatch;

namespace Vancl.TMS.Schedule.PreDispatchImpl
{
    public class PreDispatchJob : QuartzExecute
    {
        IPreDispatchBLL _bll = ServiceFactory.GetService<IPreDispatchBLL>("PreDispatchBLL");
        public override void DoJob(Quartz.JobExecutionContext context)
        {
            _bll.PreDispatch(new PreDispatchJobArgModel() { IntervalDay = Consts.IntervalDay, PerBatchCount = Consts.BATCH_COUNT });
        }
    }
}
