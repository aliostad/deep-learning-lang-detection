using HQServer.Domain.Abstract;
using HQServer.Domain.Entities;
using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Text;

namespace HQServer.Domain.Concrete
{
    public class EFBatchDispatchDetailRepository : IBatchDispatchDetailRepository
    {
        private EFDbContext context = new EFDbContext();
        public IQueryable<BatchDispatchDetail> BatchDispatchDetails
        {
            get { return context.BatchDispatchDetails; }
        }

        public void saveBatchDispatchDetail(BatchDispatchDetail batchDispatchDetail)
        {
            if (context.Entry(batchDispatchDetail).State == EntityState.Detached)
            {
                context.BatchDispatchDetails.Add(batchDispatchDetail);
            }

            // context.Entry(BatchDispatch).State = EntityState.Modified;
            context.SaveChanges();
        }

        public void quickSaveBatchDispatchDetail(BatchDispatchDetail batchDispatchDetail)
        {
            context.BatchDispatchDetails.Add(batchDispatchDetail);
        }

        public void saveContext()
        {
            context.SaveChanges();
        }

        public void deleteBatchDispatchDetail(BatchDispatchDetail batchDispatchDetail)
        {
            context.BatchDispatchDetails.Remove(batchDispatchDetail);
            context.SaveChanges();
        }

        
    }
}
