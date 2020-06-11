using CourseProvider.Events;
using CourseProvider.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CourseProvider.Providers
{
    public class DispatchStudentProvider : Provider
    {
        public const int RC_GET_ALL = 0x1;

        public EventHandler<DispatchStudentEventArgs> DispatchStudentEvent;

        public void GetAll(string sessionId)
        {
            ProviderCarrier carrier = new ProviderCarrier() { Route = "/dispatch/student" };
            carrier.AddAuth(sessionId);

            Bridge.Connect(RC_GET_ALL, carrier);
        }

        public override void ProviderLoaded(object sender, ProviderLoadedEventArgs e)
        {
            base.ProviderLoaded(sender, e);

            List<DispatchInfo> dispatchStudentList = null;

            if (e.IsSuccess)
            {
                switch (e.RequestCode)
                {
                    case RC_GET_ALL:
                        dispatchStudentList = Parser.Serialize<List<DispatchInfo>>();
                        break;
                    default:
                        break;
                }
            }

            if (DispatchStudentEvent != null)
            {
                DispatchStudentEventArgs eventArgs = new DispatchStudentEventArgs(dispatchStudentList);
                eventArgs.LoadEventArgs(e);

                DispatchStudentEvent(this, eventArgs);
            }
        }
    }
}
