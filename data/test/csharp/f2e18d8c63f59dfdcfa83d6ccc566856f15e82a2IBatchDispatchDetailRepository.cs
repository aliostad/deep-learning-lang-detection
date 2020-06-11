using LocalServer.Domain.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;


namespace LocalServer.Domain.Abstract
{
    public interface IBatchDispatchDetailRepository
    {
        IQueryable<BatchDispatchDetail> BatchDispatchDetails { get; }
        void saveBatchDispatchDetail(BatchDispatchDetail batchDispatchDetail);
        void quickSaveBatchDispatchDetail(BatchDispatchDetail batchDispatchDetail);
        void saveContext();
        void deleteBatchDispatchDetail(BatchDispatchDetail batchDispatchDetail);
    }
}
