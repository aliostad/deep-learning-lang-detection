using System.Collections.Generic;
using System.Linq;
using Data;
using Data.Infrastructure;
using Model.Models;
using Model.ViewModels;
using Core.Common;
using System;
using Model;
using System.Threading.Tasks;
using Data.Models;


namespace Service
{
    public interface IDispatchWaybillLineService : IDisposable
    {
        DispatchWaybillLine Create(DispatchWaybillLine s);
        void Delete(int id);
        void Delete(DispatchWaybillLine s);
        void Update(DispatchWaybillLine s);

        void DeleteForDispatchWaybillHeaderId(int DispatchWaybillHeaderid);

        IQueryable<DispatchWaybillLine> GetDispatchWaybillLineList();
        IQueryable<DispatchWaybillLine> GetDispatchWaybillLineForHeaderId(int DispatchWaybillHeaderId);
        DispatchWaybillLine GetDispatchWaybillLineForLineId(int DispatchWaybillLineId);
        DispatchWaybillLineViewModel GetDispatchWaybillLineViewModelForLineId(int DispatchWaybillLineId);
        IQueryable<DispatchWaybillLineViewModel> GetDispatchWaybillLineViewModelForHeaderId(int DispatchWaybillHeaderId);
    }

    public class DispatchWaybillLineService : IDispatchWaybillLineService
    {
        ApplicationDbContext db = new ApplicationDbContext();
        private readonly IUnitOfWorkForService _unitOfWork;

        public DispatchWaybillLineService(IUnitOfWorkForService unitOfWork)
        {
            _unitOfWork = unitOfWork;
        }

        public void Dispose()
        {
        }

        public DispatchWaybillLine Create(DispatchWaybillLine S)
        {
            S.ObjectState = ObjectState.Added;
            _unitOfWork.Repository<DispatchWaybillLine>().Insert(S);
            return S;
        }

        public void Delete(int id)
        {
            _unitOfWork.Repository<DispatchWaybillLine>().Delete(id);
        }

        public void Delete(DispatchWaybillLine s)
        {
            _unitOfWork.Repository<DispatchWaybillLine>().Delete(s);
        }

        public void DeleteForDispatchWaybillHeaderId(int DispatchWaybillHeaderid)
        {
            var DispatchWaybillLine = from L in db.DispatchWaybillLine where L.DispatchWaybillHeaderId == DispatchWaybillHeaderid select new { DispatchWaybillLindId = L.DispatchWaybillLineId };

            foreach (var item in DispatchWaybillLine)
            {
                Delete(item.DispatchWaybillLindId);
            }
        }

        public void Update(DispatchWaybillLine s)
        {
            s.ObjectState = ObjectState.Modified;
            _unitOfWork.Repository<DispatchWaybillLine>().Update(s);
        }

        public IQueryable<DispatchWaybillLine> GetDispatchWaybillLineList()
        {
            return _unitOfWork.Repository<DispatchWaybillLine>().Query().Get();
        }

        public IQueryable<DispatchWaybillLine> GetDispatchWaybillLineForHeaderId(int DispatchWaybillHeaderId)
        {
            return _unitOfWork.Repository<DispatchWaybillLine>().Query().Get().Where(m => m.DispatchWaybillHeaderId == DispatchWaybillHeaderId);
        }

        public DispatchWaybillLine GetDispatchWaybillLineForLineId(int DispatchWaybillLineId)
        {
            return _unitOfWork.Repository<DispatchWaybillLine>().Query().Get().Where(m => m.DispatchWaybillLineId == DispatchWaybillLineId).FirstOrDefault();
        }

        public IQueryable<DispatchWaybillLineViewModel> GetDispatchWaybillLineViewModelForHeaderId(int DispatchWaybillHeaderId)
        {
            IQueryable<DispatchWaybillLineViewModel> DispatchWaybilllineviewmodel = from L in db.DispatchWaybillLine
                                                                                    join P in db.City on L.CityId equals P.CityId into CityTable
                                                                                    from CityTab in CityTable.DefaultIfEmpty()
                                                                                    orderby L.DispatchWaybillLineId
                                                                                    where L.DispatchWaybillHeaderId == DispatchWaybillHeaderId
                                                                                    select new DispatchWaybillLineViewModel
                                                                                    {
                                                                                        DispatchWaybillHeaderId = L.DispatchWaybillHeaderId,
                                                                                        DispatchWaybillLineId = L.DispatchWaybillLineId,
                                                                                        CityId = L.CityId,
                                                                                        CityName = CityTab.CityName,
                                                                                        ReceiveDateTime = L.ReceiveDateTime,
                                                                                        ReceiveRemark = L.ReceiveRemark,
                                                                                        ForwardingDateTime = L.ForwardingDateTime,
                                                                                        ForwardedBy = L.ForwardedBy,
                                                                                        ForwardingRemark = L.ForwardingRemark,
                                                                                        CreatedBy = L.CreatedBy,
                                                                                        CreatedDate = L.CreatedDate,
                                                                                        ModifiedBy = L.ModifiedBy,
                                                                                        ModifiedDate = L.ModifiedDate
                                                                                    };


            return DispatchWaybilllineviewmodel;
        }

        public DispatchWaybillLineViewModel GetDispatchWaybillLineViewModelForLineId(int DispatchWaybillLineId)
        {
            return (from L in db.DispatchWaybillLine
                    join P in db.City on L.CityId equals P.CityId into CityTable
                    from CityTab in CityTable.DefaultIfEmpty()
                    orderby L.DispatchWaybillLineId
                    where L.DispatchWaybillLineId == DispatchWaybillLineId
                    select new DispatchWaybillLineViewModel
                    {
                        DispatchWaybillHeaderId = L.DispatchWaybillHeaderId,
                        DispatchWaybillLineId = L.DispatchWaybillLineId,
                        CityId = L.CityId,
                        CityName = CityTab.CityName,
                        ReceiveDateTime = L.ReceiveDateTime,
                        ReceiveRemark = L.ReceiveRemark,
                        ForwardingDateTime = L.ForwardingDateTime,
                        ForwardedBy = L.ForwardedBy,
                        ForwardingRemark = L.ForwardingRemark,
                        CreatedBy = L.CreatedBy,
                        CreatedDate = L.CreatedDate,
                        ModifiedBy = L.ModifiedBy,
                        ModifiedDate = L.ModifiedDate
                    }).FirstOrDefault();
        }
    }
}
