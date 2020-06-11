using HQServer.Domain.Abstract;
using HQServer.Domain.Entities;
using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Text;

namespace HQServer.Domain.Concrete
{
    public class EFBatchDispatchRepository : IBatchDispatchRepository
    {
        private EFDbContext context = new EFDbContext();
        public IQueryable<BatchDispatch> BatchDispatchs
        {
            get { return context.BatchDispatchs; }
        }

        public void saveBatchDispatch(BatchDispatch batchDispatch)
        {
            if (batchDispatch.batchDispatchID == 0)
            {
                context.BatchDispatchs.Add(batchDispatch);
                context.SaveChanges();
            }
            else 
            {
                context.Entry(batchDispatch).State = EntityState.Modified;
                context.SaveChanges();
            }
        }

        public void deleteBatchDispatch(BatchDispatch batchDispatch)
        {
            context.BatchDispatchs.Remove(batchDispatch);
            context.SaveChanges();
        }

        public void deleteTable()
        {


        }
    }
}
