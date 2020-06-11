
using System;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;
using System.Text;
using DRMFSS.BLL.ViewModels.Dispatch;
using DRMFSS.BLL.ViewModels;

namespace DRMFSS.BLL.Services
{
    public interface IOtherDispatchAllocationService
    {

        bool AddOtherDispatchAllocation(OtherDispatchAllocation otherDispatchAllocation);
        bool DeleteOtherDispatchAllocation(OtherDispatchAllocation otherDispatchAllocation);
        bool DeleteById(int id);
        bool EditOtherDispatchAllocation(OtherDispatchAllocation otherDispatchAllocation);
        OtherDispatchAllocation FindById(int id);
        List<OtherDispatchAllocation> GetAllOtherDispatchAllocation();
        List<OtherDispatchAllocation> FindBy(Expression<Func<OtherDispatchAllocation, bool>> predicate);

        void Save(ViewModels.Dispatch.OtherDispatchAllocationViewModel model);


        OtherDispatchAllocationViewModel GetViewModelByID(Guid otherDispatchAllocationId);

        List<OtherDispatchAllocation> GetAllToCurrentOwnerHubs(UserProfile user);

        List<OtherDispatchAllocation> GetAllToOtherOwnerHubs(UserProfile user);

        List<OtherDispatchAllocationDto> GetCommitedLoanAllocationsDetached(UserProfile user, bool? closedToo, int? CommodityType);

        List<OtherDispatchAllocationDto> GetCommitedTransferAllocationsDetached(UserProfile user, bool? closedToo, int? CommodityType);

        void CloseById(Guid otherDispatchAllocationId);
    }
}


