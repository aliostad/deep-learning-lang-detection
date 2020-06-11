using Tickets.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Tickets.DataAccess
{
    /**
     * User Repository
     **/
    public interface IUserRepository : IGenericDataRepository<User>
    {
    }
    public class UserRepository : GenericDataRepository<User>, IUserRepository
    {
    }

    /**
     * Event Repository
     **/
    public interface IEventRepository : IGenericDataRepository<Event>
    {
    }
    public class EventRepository : GenericDataRepository<Event>, IEventRepository
    {
    }

    /**
     * Ticket Repository
     **/
    public interface ITicketRepository : IGenericDataRepository<Ticket>
    {
    }
    public class TicketRepository : GenericDataRepository<Ticket>, ITicketRepository
    {
    }

    /**
     * Transaction Repository
     **/
    public interface ITransactionRepository : IGenericDataRepository<Transaction>
    {
    }
    public class TransactionRepository : GenericDataRepository<Transaction>, ITransactionRepository
    {
    }

    /**
     * Session Repository
     **/
    public interface ISessionRepository : IGenericDataRepository<Session>
    {
    }
    public class SessionRepository : GenericDataRepository<Session>, ISessionRepository
    {
    }

    /**
     * Ticket Sale Repository
     **/
    public interface ITicketSaleRepository : IGenericDataRepository<TicketSale>
    {
    }
    public class TicketSaleRepository : GenericDataRepository<TicketSale>, ITicketSaleRepository
    {
    }


}
