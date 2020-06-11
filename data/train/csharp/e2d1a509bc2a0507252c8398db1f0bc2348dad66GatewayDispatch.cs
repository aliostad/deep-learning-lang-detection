using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using ESB.Training.Inbound;
using ESB.Training.Model;

namespace ESB.Training.Outbound.Gateway
{
    public class GatewayDispatch
    {
        private Dictionary<DispatchType, IDispachCommand> commands;

        public GatewayDispatch()
        {
            commands = new Dictionary<DispatchType, IDispachCommand>();
            commands.Add(DispatchType.REST, new HttpDispatchCommand());
        }

        public async Task Dispatch(ESBContext context, 
                             ResponseHandle responseHandle,
                             DispatchType dispatchType)
        {
            if (commands.TryGetValue(dispatchType, out IDispachCommand command))
            {
                await command.Dispatch(context, responseHandle);
            }
        }
    }
}
