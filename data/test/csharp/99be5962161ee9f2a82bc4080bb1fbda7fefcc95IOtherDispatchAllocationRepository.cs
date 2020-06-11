using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using DRMFSS.BLL.ViewModels;
using DRMFSS.BLL.ViewModels.Dispatch;

namespace DRMFSS.BLL.Interfaces
{
    public interface IOtherDispatchAllocationRepository : IGenericRepository<OtherDispatchAllocation>,IRepository<OtherDispatchAllocation>
    {
        
        void Save(ViewModels.Dispatch.OtherDispatchAllocationViewModel model);
      
       
        OtherDispatchAllocationViewModel GetViewModelByID(Guid otherDispatchAllocationId);

        List<OtherDispatchAllocation> GetAllToCurrentOwnerHubs(UserProfile user);

        List<OtherDispatchAllocation> GetAllToOtherOwnerHubs(UserProfile user);

        List<OtherDispatchAllocationDto> GetCommitedLoanAllocationsDetached(UserProfile user, bool? closedToo, int? CommodityType);

        List<OtherDispatchAllocationDto> GetCommitedTransferAllocationsDetached(UserProfile user, bool? closedToo, int? CommodityType);

        void CloseById(Guid otherDispatchAllocationId);
    }
}
