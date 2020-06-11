using System.Collections.Generic;
using System.Linq;
using Surya.India.Data;
using Surya.India.Data.Infrastructure;
using Surya.India.Model.Models;
using Surya.India.Model.ViewModels;
using Surya.India.Core.Common;
using System;
using Surya.India.Model;
using System.Threading.Tasks;
using Surya.India.Data.Models;


namespace Surya.India.Service
{
    public interface ISaleDispatchLineService : IDisposable
    {
        SaleDispatchLine Create(SaleDispatchLine s);
        void Delete(int id);
        void Delete(SaleDispatchLine s);
        SaleDispatchLine GetSaleDispatchLine(int id);
        IQueryable<SaleDispatchLine> GetSaleDispatchLineList(int SaleDispatchHeaderId);
        SaleDispatchLine Find(int id);
        void Update(SaleDispatchLine s);

        bool CheckForProductExists(int ProductId, int SaleDispatchHEaderId, int SaleDispatchLineId);
        bool CheckForProductExists(int ProductId, int SaleDispatchHEaderId);
    }

    public class SaleDispatchLineService : ISaleDispatchLineService
    {
        ApplicationDbContext db = new ApplicationDbContext();
        private readonly IUnitOfWorkForService _unitOfWork;

        public SaleDispatchLineService(IUnitOfWorkForService unitOfWork)
        {
            _unitOfWork = unitOfWork;
        }

        public SaleDispatchLine Create(SaleDispatchLine S)
        {
            S.ObjectState = ObjectState.Added;
            _unitOfWork.Repository<SaleDispatchLine>().Insert(S);
            return S;
        }

        public void Delete(int id)
        {
            _unitOfWork.Repository<SaleDispatchLine>().Delete(id);
        }

        public void Delete(SaleDispatchLine s)
        {
            _unitOfWork.Repository<SaleDispatchLine>().Delete(s);
        }

        public void Update(SaleDispatchLine s)
        {
            s.ObjectState = ObjectState.Modified;
            _unitOfWork.Repository<SaleDispatchLine>().Update(s);
        }

        public SaleDispatchLine GetSaleDispatchLine(int id)
        {
            return _unitOfWork.Repository<SaleDispatchLine>().Query().Get().Where(m => m.SaleDispatchLineId == id).FirstOrDefault();
        }



        public SaleDispatchLine Find(int id)
        {
            return _unitOfWork.Repository<SaleDispatchLine>().Find(id);
        }

        public IQueryable<SaleDispatchLine> GetSaleDispatchLineList(int SaleDispatchHeaderId)
        {
            return _unitOfWork.Repository<SaleDispatchLine>().Query().Get().Where(m => m.SaleDispatchHeaderId == SaleDispatchHeaderId);
        }

        public bool CheckForProductExists(int ProductId, int SaleDispatchHeaderId, int SaleDispatchLineId)
        {

            SaleDispatchLine temp = (from p in db.SaleDispatchLine
                                  where p.SaleDispatchHeaderId == SaleDispatchHeaderId &&p.SaleDispatchLineId!=SaleDispatchLineId
                                  select p).FirstOrDefault();
            if (temp != null)
                return true;
            else return false;
        }

        public bool CheckForProductExists(int ProductId, int SaleDispatchHeaderId)
        {

            SaleDispatchLine temp = (from p in db.SaleDispatchLine
                                  where p.SaleDispatchHeaderId == SaleDispatchHeaderId
                                  select p).FirstOrDefault();
            if (temp != null)
                return true;
            else return false;
        }

        public void Dispose()
        {
        }
    }
}
