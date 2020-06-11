using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using App.Entity;
using App.Entity.ViewModel;

namespace App.Contract.Repository
{
    public interface IDispatchRepository
    {
        List<DtDispatch> GetAll();

        List<DtDispatch> GetAll(string query);

        List<VMDispatchExt> GetAllEx();

        List<VMDispatchExt> GetAllEx(string query);

        DtDispatch Get(Guid id);

        DtDispatch Add(DtDispatch obj);

        DtDispatch Edit(DtDispatch obj,Guid id);

        bool Delete(Guid id);
    }
}