
using System;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;
using System.Text;

namespace DRMFSS.BLL.Services
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

        List<BLL.DispatchDetail> GetDispatchDetail(int partitionId, Guid dispatchId);

        /// <summary>
        /// Gets the dispatch detail.
        /// </summary>
        /// <param name="dispatchId">The dispatch id.</param>
        /// <returns></returns>
        List<BLL.DispatchDetail> GetDispatchDetail(Guid dispatchId);

        List<Web.Models.DispatchDetailModelDto> ByDispatchIDetached(Guid dispatchId, string PreferedWeightMeasurment);

    }
}


