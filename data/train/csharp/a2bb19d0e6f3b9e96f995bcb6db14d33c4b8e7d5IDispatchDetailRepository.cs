using System.Collections.Generic;
using System.Linq;
using DRMFSS.BLL.Interfaces;
using DRMFSS.BLL.MetaModels;
using System.ComponentModel.DataAnnotations;
using System;


namespace DRMFSS.BLL.Interfaces
{

    /// <summary>
    /// 
    /// </summary>
    public interface IDispatchDetailRepository : IGenericRepository<DispatchDetail>,IRepository<DispatchDetail>
    {
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
