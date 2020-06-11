
using System;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;
using System.Text;
using Cats.Models.Hubs;

namespace Cats.Services.Hub
{
    public interface IDispatchDetailService
    {

        bool AddDispatchDetail(DispatchDetail dispatchDetail);
        bool DeleteDispatchDetail(DispatchDetail dispatchDetail);
        bool DeleteById(int id);
        bool EditDispatchDetail(DispatchDetail dispatchDetail);
        DispatchDetail FindById(int id);
        List<DispatchDetail> GetAllDispatchDetail();
        List<DispatchDetail> FindBy(Expression<Func<DispatchDetail, bool>> predicate);

        List<DispatchDetail> GetDispatchDetail(int PartitionId, Guid dispatchId);

        /// <summary>
        /// Gets the dispatch detail.
        /// </summary>
        /// <param name="dispatchId">The dispatch id.</param>
        /// <returns></returns>
        List<DispatchDetail> GetDispatchDetail(Guid dispatchId);

        List<DispatchDetailModelDto> ByDispatchIDetached(Guid dispatchId, string PreferedWeightMeasurment);

    }
}


