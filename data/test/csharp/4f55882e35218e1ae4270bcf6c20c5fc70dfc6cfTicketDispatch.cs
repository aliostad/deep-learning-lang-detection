using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TrainTicket.Models;
using TrainTicket.Server.DataFlow;

namespace TrainTicket.Server
{
   public class TicketDispatch
    {
       private TicketDispatch()
       { }

       private static TicketDispatch _TicketDispatch;
       public static TicketDispatch GetIntence()
       {
           if (_TicketDispatch == null)
               _TicketDispatch = new TicketDispatch();
           return _TicketDispatch;
       }

       private IProducer<TicketOrder> _ticketOrderProducer = new PersistTicketOrderProducer();

       public void StartTicketOrder(TicketOrder order)
       {
           _ticketOrderProducer.Producer(order);
       }
    }
}
