

using System;
using System.Collections.Generic;
using System.Linq.Expressions;
using Cats.Data.Hub;
using Cats.Data.Hub.UnitWork;
using Cats.Models.Hubs;


namespace Cats.Services.Hub
{

    public class DispatchDetailService : IDispatchDetailService
    {
        private readonly IUnitOfWork _unitOfWork;


        public DispatchDetailService(IUnitOfWork unitOfWork)
        {
            this._unitOfWork = unitOfWork;
        }
        #region Default Service Implementation
        public bool AddDispatchDetail(DispatchDetail dispatchDetail)
        {
            _unitOfWork.DispatchDetailRepository.Add(dispatchDetail);
            _unitOfWork.Save();
            return true;

        }
        public bool EditDispatchDetail(DispatchDetail dispatchDetail)
        {
            _unitOfWork.DispatchDetailRepository.Edit(dispatchDetail);
            _unitOfWork.Save();
            return true;

        }
        public bool DeleteDispatchDetail(DispatchDetail dispatchDetail)
        {
            if (dispatchDetail == null) return false;
            _unitOfWork.DispatchDetailRepository.Delete(dispatchDetail);
            _unitOfWork.Save();
            return true;
        }
        public bool DeleteById(int id)
        {
            var entity = _unitOfWork.DispatchDetailRepository.FindById(id);
            if (entity == null) return false;
            _unitOfWork.DispatchDetailRepository.Delete(entity);
            _unitOfWork.Save();
            return true;
        }
        public List<DispatchDetail> GetAllDispatchDetail()
        {
            return _unitOfWork.DispatchDetailRepository.GetAll();
        }
        public DispatchDetail FindById(int id)
        {
            return _unitOfWork.DispatchDetailRepository.FindById(id);
        }
        public List<DispatchDetail> FindBy(Expression<Func<DispatchDetail, bool>> predicate)
        {
            return _unitOfWork.DispatchDetailRepository.FindBy(predicate);
        }
        #endregion
        /// <summary>
        /// Gets the dispatch detail list.
        /// </summary>
        /// <param name="dispatchId">The dispatch id.</param>
        /// <returns></returns>
        public List<DispatchDetail> GetDispatchDetail(int PartitionId, Guid dispatchId)
        {
            return _unitOfWork.DispatchDetailRepository.FindBy(t => t.DispatchID == dispatchId);


        }

        public List<DispatchDetail> GetDispatchDetail(Guid dispatchId)
        {
            return _unitOfWork.DispatchDetailRepository.FindBy(t => t.DispatchID == dispatchId);

        }


        public List<DispatchDetailModelDto> ByDispatchIDetached(Guid dispatchId, string PreferedWeightMeasurment)
        {
            List<DispatchDetailModelDto> dispatchDetais = new List<DispatchDetailModelDto>();

            var query = _unitOfWork.DispatchDetailRepository.FindBy(t => t.DispatchID == dispatchId);
            ;

            foreach (var dispatchDetail in query)
            {
                var DDMD = new DispatchDetailModelDto();

                DDMD.DispatchID = dispatchDetail.DispatchID;
                DDMD.DispatchDetailID = dispatchDetail.DispatchDetailID;
                DDMD.CommodityName = dispatchDetail.Commodity.Name;
                DDMD.UnitName = dispatchDetail.Unit.Name;

                DDMD.RequestedQuantityInUnit = Math.Abs(dispatchDetail.RequestedQunatityInUnit);
                DDMD.DispatchedQuantityInUnit = Math.Abs(dispatchDetail.DispatchedQuantityInUnit);
                //TODO:Unit Measure comparison alert
                if (PreferedWeightMeasurment.ToUpperInvariant() == "QTL")
                {
                    DDMD.RequestedQuantityMT = Math.Abs(dispatchDetail.RequestedQuantityInMT) * 10;
                    DDMD.DispatchedQuantityMT = Math.Abs(dispatchDetail.DispatchedQuantityInMT) * 10;
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

        public void Dispose()
        {
            _unitOfWork.Dispose();

        }

    }
}


