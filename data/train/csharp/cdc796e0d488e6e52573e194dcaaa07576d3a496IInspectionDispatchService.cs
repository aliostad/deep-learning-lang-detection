using System.Collections.Generic;
using InspectionWeb.Services.Misc;
using InspectionWeb.Models;

namespace InspectionWeb.Services.Interface
{
    public interface IInspectionDispatchService
    {
        IResult Create(roomInspectionDispatch instance);

        IResult Update(roomInspectionDispatch instance);

        IResult Update(roomInspectionDispatch instance, string propertyName, object value);

        IResult Delete(string dispatchId);

        bool IsExist(System.DateTime date);

        roomInspectionDispatch GetById(string dispatchId);

        IEnumerable<roomInspectionDispatch> GetAll();

        IEnumerable<roomInspectionDispatch> GetAllByDate(System.DateTime date);
    }
}