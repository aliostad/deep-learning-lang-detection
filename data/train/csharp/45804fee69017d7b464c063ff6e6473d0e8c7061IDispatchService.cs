
using System;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;
using System.Text;
using Cats.Models.Hubs;

namespace Cats.Services.Hub
{
    public interface IDispatchService
    {

        bool AddDispatch(Dispatch dispatch);
        bool DeleteDispatch(Dispatch dispatch);
        bool DeleteById(int id);
        bool EditDispatch(Dispatch dispatch);
        Dispatch FindById(int id);
        Dispatch FindById(System.Guid id);
        Dispatch FindByAllocationId(System.Guid id);
        List<Dispatch> GetAllDispatch();
        List<Dispatch> FindBy(Expression<Func<Dispatch, bool>> predicate);
        bool RejectToHubs(Dispatch dispatch);
        /// <summary>
        /// Gets the dispatch by GIN.
        /// </summary>
        /// <param name="ginNo">The gin no.</param>
        /// <returns></returns>
        Dispatch GetDispatchByGIN(string ginNo);
        /// <summary>
        /// Gets the dispatch transaction.
        /// </summary>
        /// <param name="dispatchId">The dispatch id.</param>
        /// <returns></returns>
        Transaction GetDispatchTransaction(Guid dispatchId);
        /// <summary>
        /// Gets the FDP balance.
        /// </summary>
        /// <param name="FDPID">The FDPID.</param>
        /// <param name="SINumber">The SI number.</param>
        /// <returns></returns>
        FDPBalance GetFDPBalance(int FDPID, string SINumber);
        /// <summary>
        /// Gets the available commodities.
        /// </summary>
        /// <param name="SINumber">The SI number.</param>
        /// <returns></returns>
        List<Commodity> GetAvailableCommodities(string SINumber, int hubID);


        List<DispatchModelModelDto> ByHubIdAndAllocationIDetached(int hubId, Guid dispatchAllocationId);
        List<DispatchModelModelDto> ByHubIdAndOtherAllocationIDetached(int hubId, Guid otherDispatchAllocationId);
        DispatchViewModel CreateDispatchFromDispatchAllocation(Guid dispatchAllocationId, decimal quantityInUnit);


        IEnumerable<Dispatch> Get(Expression<Func<Dispatch, bool>> filter = null,
                                            Func<IQueryable<Dispatch>, IOrderedQueryable<Dispatch>>
                                                orderBy = null, string includeProperties = "");

        decimal GetFDPDispatch(int transportOrderId, int fdpId);

    }
}


