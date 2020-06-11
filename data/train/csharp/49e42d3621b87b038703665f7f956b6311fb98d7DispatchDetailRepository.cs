using System.Collections.Generic;
using System.Linq;
using DRMFSS.BLL.Interfaces;
using DRMFSS.BLL.MetaModels;
using System.ComponentModel.DataAnnotations;
using System;
using DRMFSS.Web.Models;


namespace DRMFSS.BLL.Repository
{
    /// <summary>
    /// 
    /// </summary>
    public partial class DispatchDetailRepository :GenericRepository<CTSContext,DispatchDetail>, IDispatchDetailRepository
    {
        public DispatchDetailRepository(CTSContext _db, IUnitOfWork uow)
        {
            db = _db;
            repository = uow;
        }
        /// <summary>
        /// Gets the dispatch detail list.
        /// </summary>
        /// <param name="dispatchId">The dispatch id.</param>
        /// <returns></returns>
        public List<BLL.DispatchDetail> GetDispatchDetail(int partitionID, Guid dispatchId)
        {
            return (from p in db.DispatchDetails
                       where ( p.DispatchID == dispatchId)
                       select p).ToList();
            
        }

        public List<DispatchDetail> GetDispatchDetail(Guid dispatchId)
        {
            return (from p in db.DispatchDetails
                    where (p.DispatchID == dispatchId)
                    select p).ToList();
        }


        public List<DispatchDetailModelDto> ByDispatchIDetached(Guid dispatchId, string PreferedWeightMeasurment)
        {
            List<DispatchDetailModelDto> dispatchDetais = new List<DispatchDetailModelDto>();

            var query = (from rD in db.DispatchDetails
                         where rD.DispatchID == dispatchId
                         select rD);

            foreach (var dispatchDetail in query)
            {
                var DDMD = new DispatchDetailModelDto();

                DDMD.DispatchID = dispatchDetail.DispatchID;
                DDMD.DispatchDetailID = dispatchDetail.DispatchDetailID;
                DDMD.CommodityName = dispatchDetail.Commodity.Name;
                DDMD.UnitName = dispatchDetail.Unit.Name;

                DDMD.RequestedQuantityInUnit = Math.Abs(dispatchDetail.RequestedQunatityInUnit);
                DDMD.DispatchedQuantityInUnit = Math.Abs(dispatchDetail.DispatchedQuantityInUnit);

                if (PreferedWeightMeasurment.ToUpperInvariant()  == "QN")
                {
                    DDMD.RequestedQuantityMT = Math.Abs(dispatchDetail.RequestedQuantityInMT)*10;
                    DDMD.DispatchedQuantityMT = Math.Abs(dispatchDetail.DispatchedQuantityInMT)*10;
                }
                else
                {
                    DDMD.RequestedQuantityMT = Math.Abs(dispatchDetail.RequestedQuantityInMT);
                    DDMD.DispatchedQuantityMT = Math.Abs(dispatchDetail.DispatchedQuantityInMT);
                }
                dispatchDetais.Add(DDMD);
            }
            return dispatchDetais;
        }

        public bool DeleteByID(int id)
        {
            var original = FindById(id);
            if (original == null) return false;
            db.DispatchDetails.Remove(original);

            return true;
        }

        public bool DeleteByID(System.Guid id)
        {
            return false;
        }

        public DispatchDetail FindById(int id)
        {
            return null;
        }

        public DispatchDetail FindById(System.Guid id)
        {
            return db.DispatchDetails.FirstOrDefault(t => t.DispatchDetailID == id);

        }
    }
}
