using App.Entity;
using App.Entity.ViewModel;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace App.Contract.ManagerService
{
    public interface IDispatchManager
    {
        List<DtDispatch> GetAllDispatch();

        List<DtDispatch> GetAllDispatch(string query);

        List<VMDispatchExt> GetAllEx();

        List<VMDispatchExt> GetAllEx(string query);

        DtDispatch GetDispatch(Guid id);

        DtDispatch AddDispatch(DtDispatch obj);

        DtDispatch EditDispatch(DtDispatch obj);

        bool DeleteDispatch(Guid id);
    }
}
