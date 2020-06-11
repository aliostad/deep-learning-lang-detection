using System.Collections.Generic;
using InspectionWeb.Services.Misc;
using InspectionWeb.Models;

namespace InspectionWeb.Services.Interface
{
    public interface IItemInspectionDispatchService
    {
        IResult Create(itemInspectionDispatch instance);

        IResult Create(System.DateTime date, IEnumerable<exhibitionItem> items, string setupId);

        IResult Update(itemInspectionDispatch instance);

        IResult Update(itemInspectionDispatch instance, string propertyName, object value);

        IResult Reset(itemInspectionDispatch instance);

        IResult Delete(string dispatchId);

        bool IsExists(System.DateTime date);

        bool IsExists(string dispatchId);

        bool checkItemInsert(System.DateTime date);

        itemInspectionDispatch GetById(string dispatchId);

        IEnumerable<itemInspectionDispatch> GetAll();

        IEnumerable<itemInspectionDispatchDetail> GetAllByDate(System.DateTime date);

        IEnumerable<itemInspectionDispatchDetail> GetAllByItemCondition(string startDate, string endDate, List<string> itemId);

        IEnumerable<itemInspectionDispatchDetail> GetAllByUserCondition(string startDate, string endDate, List<string> userId);

    }
}