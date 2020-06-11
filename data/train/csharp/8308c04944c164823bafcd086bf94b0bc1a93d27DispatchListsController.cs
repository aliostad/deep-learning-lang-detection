﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using NetSteps.Data.Entities.Business;
using NetSteps.Data.Entities.Exceptions;
using System.Text;
using NetSteps.Data.Entities.EntityModels;
using System.Transactions;
using NetSteps.Common.Globalization;
using NetSteps.Common.Extensions;
using NetSteps.Encore.Core.IoC;
//using NetSteps.Web.Mvc.Attributes;
//using NetSteps.Web.Mvc.Helpers;
using NetSteps.Web.Extensions;
using nsCore.Areas.Products.Models;
using NetSteps.Data.Entities.Business.HelperObjects.SearchParameters;
//using NetSteps.Data.Entities;

namespace nsCore.Areas.Products.Controllers
{
    public class DispatchListsController : BaseProductsController
    {
        //
        // GET: /Products/DispatchLists/

        public ActionResult Index()
        {
            return View();
        }

        [OutputCache(CacheProfile = "PagedGridData")]
        public virtual ActionResult Get(bool? status, int page, int pageSize, string orderBy, string orderByDirection)
        {
            try
            {
                if (orderByDirection == "Descending")
                {
                    orderByDirection = "desc";
                }
                else
                {
                    orderByDirection = "asc";
                }

                var dispatchLists = DispatchLists.GetFullDispatchListsTable(new PaginationParameters()
                {
                    PageSize = pageSize,
                    PageIndex = page,
                    OrderBy = orderBy,
                    Order = orderByDirection
                });

                if (!dispatchLists.Any())
                {
                    return Json(new { result = true, totalPages = 0, page = String.Format("<tr><td colspan=\"6\">{0}</td></tr>", Translation.GetTerm("ThereAreNodispatchLists", "There are no dispatcs")) });
                }

                var builder = new StringBuilder();

                foreach (var dispatchList in dispatchLists)
                {
                    var Status = 1;//?DispatchListID=1
                    string editUrl = string.Format("~/Products/{0}/Edit?DispatchListID={1}", "DispatchLists", dispatchList.DispatchListID);
                    builder.Append("<tr>")
                        .AppendCheckBoxCell(value: dispatchList.DispatchListID.ToString())
                        .AppendLinkCell(editUrl, dispatchList.Name)
                        .AppendCell(dispatchList.Mercado.ToString())
                        .Append("</tr>");
                }

                return Json(new { result = true, totalPages = dispatchLists.TotalPages, page = dispatchLists.TotalCount == 0 ? "<tr><td colspan=\"7\">There are no Dispatch</td></tr>" : builder.ToString() });

            }
            catch (Exception ex)
            {
                var exception = EntityExceptionHelper.GetAndLogNetStepsException(ex, NetSteps.Data.Entities.Constants.NetStepsExceptionType.NetStepsApplicationException);
                return Json(new { result = false, message = exception.PublicMessage });
            }
        }


        public virtual ActionResult Create(int? DispatchListID)
        {
            var dispatch = DispatchListID.HasValue ? DispatchLists.GetDispatchListsByDispatchListID(DispatchListID.Value) : new DispatchListsTable { Editable = 1 };
            return View(dispatch);
        }

        public virtual ActionResult Edit(int? DispatchListID)
        {
            try
            {
                var dispatch = DispatchLists.GetDispatchListsByDispatchListID(Convert.ToInt32(DispatchListID));
                dispatch.Accounts = DispatchLists.GetDispatchListItemsById(Convert.ToInt32(DispatchListID));
                DispatchListsModel model = new DispatchListsModel(dispatch);
                return View(model); 
            }
            catch (Exception ex)
            {
                var exception = EntityExceptionHelper.GetAndLogNetStepsException(ex, NetSteps.Data.Entities.Constants.NetStepsExceptionType.NetStepsApplicationException);
                throw exception;
            }
        }

        public virtual ActionResult DeleteDispatchLists(List<int> items)
        {

            try
            {
                string resultado = string.Empty;

                using (TransactionScope trs = new TransactionScope(TransactionScopeOption.Required))
                {
                    foreach (var item in items)
                    {
                        DispatchListsTable entidad = new DispatchListsTable();
                        entidad.DispatchListID = item;
                        resultado = DispatchLists.DeleteDispatch(entidad);
                        if (resultado.Trim().Length > 0)
                        {
                            trs.Dispose();
                            return Json(new { result = false, message = resultado });
                        }
                    }
                    trs.Complete();
                }
                return Json(new { result = true, message = "" });
            }
            catch (Exception ex)
            {
                var exception = EntityExceptionHelper.GetAndLogNetStepsException(ex, NetSteps.Data.Entities.Constants.NetStepsExceptionType.NetStepsApplicationException);
                return JsonError(exception.PublicMessage);
            }
        }



        public virtual ActionResult Update(DispatchListsTable dispatchLists)
        {

            int resultado = 0;
            try
            {

                int dispatchID = DispatchLists.UPDDispatchLists(dispatchLists.Name, dispatchLists.DispatchListID);
                int RowCount = DispatchLists.DelDispatchLists(dispatchID);

                foreach (var account in dispatchLists.Accounts)
                {
                    DispatchsItemsParameters objE = new DispatchsItemsParameters();
                    objE.AccountNumber = Convert.ToString(account.AccountID);
                    objE.DispatchListID = dispatchID;

                    resultado = DispatchItemsList.InsertDispatchListItems(objE); 
                }
        
            }
            catch (Exception ex)
            {
                var exception = EntityExceptionHelper.GetAndLogNetStepsException(ex, NetSteps.Data.Entities.Constants.NetStepsExceptionType.NetStepsApplicationException);
                throw exception;
            }
            return Json(new { result = (resultado == 0 ? false : true) });
        }
    
        public virtual ActionResult Save(DispatchListsTable dispatchLists)
        {

            int resultado = 0;
            try
            {
                if (dispatchLists.DispatchListID > 0)
                    resultado = DispatchLists.UpdateDispatch(dispatchLists);
                else
                    using (TransactionScope tran = new TransactionScope(TransactionScopeOption.Required))
                    {
                        int dispatchListID = DispatchLists.InsertDispatch(dispatchLists);
                        if (dispatchListID < 1)
                        {
                            tran.Dispose();
                            return Json(new { result = false, message = "No se grabó correctamente en la tabla Dispatch List" });
                        }
                        foreach (var account in dispatchLists.Accounts)
                        {
                            DispatchsItemsParameters objE = new DispatchsItemsParameters();
                            objE.AccountNumber = Convert.ToString(account.AccountID);
                            objE.DispatchListID = dispatchListID;
                             
                            if (DispatchItemsList.InsertDispatchListItems(objE) < 1)
                            {
                                tran.Dispose();
                                return Json(new { result = false, message = "No se grabó correctamente en la tabla Dispatch List" });
                            }
                        }
                        resultado = 1;
                        tran.Complete();
                    }
            }
            catch (Exception ex)
            {
                var exception = EntityExceptionHelper.GetAndLogNetStepsException(ex, NetSteps.Data.Entities.Constants.NetStepsExceptionType.NetStepsApplicationException);
                throw exception;
            }
            return Json(new { result = (resultado == 0 ? false : true) });
        }
    }
}