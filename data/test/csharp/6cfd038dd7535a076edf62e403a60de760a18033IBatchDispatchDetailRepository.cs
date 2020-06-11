using HQServer.Domain.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;


namespace HQServer.Domain.Abstract
{
    public interface IBatchDispatchDetailRepository
    {
        IQueryable<BatchDispatchDetail> BatchDispatchDetails { get; }
        void saveBatchDispatchDetail(BatchDispatchDetail batchDispatchDetail);
        void deleteBatchDispatchDetail(BatchDispatchDetail batchDispatchDetail);

        void quickSaveBatchDispatchDetail(BatchDispatchDetail detail);
        void saveContext();
    }
}
