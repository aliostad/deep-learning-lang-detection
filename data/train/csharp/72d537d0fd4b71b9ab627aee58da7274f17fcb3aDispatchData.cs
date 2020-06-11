using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Model;
using DataAccess;
using System.Data;

namespace Bussiness
{
    public class DispatchData
    {
        DBDispatch dbDispatch = new DBDispatch();
        public DataSet GetAllOrdersDetails()
        {

            return dbDispatch.GetAllOrdersDetails();
        }
        public DataSet GetDispatchSearch(Dispatch dispatch)
        {

            return dbDispatch.GetDispatchSearch(dispatch);
        }
        public DataSet GetDispatchByAgentID(Dispatch dispatch)
        {

            return dbDispatch.GetDispatchByAgentID(dispatch);
        }
        public DataSet CashierGetDetails(Dispatch dispatch)
        {

            return dbDispatch.CashierGetDetails(dispatch);
        }

        public DataSet GetDetailsForSettlement(Dispatch dispatch)
        {

            return dbDispatch.GetDetailsForSettlement(dispatch);
        }
        public DataSet GetStockFromDispatch(Dispatch dispatch)
        {

            return dbDispatch.GetStockFromDispatch(dispatch);
        }
        
        public DataSet GenerateDispatchSummary(int id)
        {

            return dbDispatch.GenerateDispatchSummary(id);
        }
        public DataSet GetDispatchLists(Dispatch disp)
        {

            return dbDispatch.GetDispatchLists(disp);
        }
        public DataSet GetDispatchListsUser(Dispatch disp)
        {

            return dbDispatch.GetDispatchListsUser(disp);
        }
        public DataSet getStock(int id)
        {

            return dbDispatch.getStock(id);
        }
        public DataSet getDetailsbyDDid(int id)
        {

            return dbDispatch.getDetailsbyDDid(id);
        }
        public DataSet CashierGetDetailsId(int id)
        {

            return dbDispatch.CashierGetDetailsId(id);
        }
        
        public DataSet GetDispatchByID(int id)
        {

            return dbDispatch.GetDispatchByID(id);
        }
        
        public int AddDispatchInfo(Dispatch dispatch)
        {
            DBDispatch dbdispatch = new DBDispatch();
            int Result = 0;
            try
            {
                Result = dbdispatch.AddDispatchInfo(dispatch);
                return Result;
            }
            catch (Exception)
            {

                throw;
            }


        }
        public int UpdateDispatch(Dispatch dispatch)
        {
            DBDispatch dbdispatch = new DBDispatch();
            int Result = 0;
            try
            {
                Result = dbdispatch.UpdateDispatch(dispatch);
                return Result;
            }
            catch (Exception)
            {

                throw;
            }


        }
        public int updateReturnItems(Dispatch dispatch)
        {
            DBDispatch dbdispatch = new DBDispatch();
            int Result = 0;
            try
            {
                Result = dbdispatch.updateReturnItems(dispatch);
                return Result;
            }
            catch (Exception)
            {

                throw;
            }


        }
        public int CashierUpdate(Dispatch dispatch)
        {
            DBDispatch dbdispatch = new DBDispatch();
            int Result = 0;
            try
            {
                Result = dbdispatch.CashierUpdate(dispatch);
                return Result;
            }
            catch (Exception)
            {

                throw;
            }


        }
        public int updateReturnTrays(Dispatch dispatch)
        {
            DBDispatch dbdispatch = new DBDispatch();
            int Result = 0;
            try
            {
                Result = dbdispatch.updateReturnTrays(dispatch);
                return Result;
            }
            catch (Exception)
            {

                throw;
            }


        }

         public DataSet GetTransportDetails()
        {
            dbDispatch = new DBDispatch();

            return dbDispatch.GetTransportDetails();
        }

        public int AddTransportInfo(Dispatch dispatch)
        {
            dbDispatch = new DBDispatch();
            return dbDispatch.AddTransportInfo(dispatch);
        }
        public bool UpdateTransportInfo(Dispatch dispatch)
        {
            dbDispatch = new DBDispatch();
            return dbDispatch.UpdateTransportInfo(dispatch);
        }
        public DataSet GetTransportDatabyId(int TM_Id)
        {
            dbDispatch = new DBDispatch();
            return dbDispatch.GetTransportDatabyId(TM_Id);
        }
        public int DeleteTransportDetails(Dispatch dispatch)
        {
            dbDispatch = new DBDispatch();
            return dbDispatch.DeleteTransportDetails(dispatch);
        }



        //Marketing Module--

        public DataSet GetAgentforIncentiveSetup(int RouteID)
        {
            dbDispatch = new DBDispatch();
            return dbDispatch.GetAgentforIncentiveSetup(RouteID);
        }

        public int AddAgentIncentive(string agentId, int routeid, int categoryid, int typeid, int commodityid, string incentive, bool isActive)
        {
            DBDispatch dbdispatch = new DBDispatch();
            return dbdispatch.AddAgentIncentive(agentId, routeid, categoryid, typeid, commodityid, incentive, isActive);
        }
        //test
        public DataSet GetProductforIncentiveSetup(int brandid, int typeid, int commodityid)
        {
            dbDispatch = new DBDispatch();
            return dbDispatch.GetProductforIncentiveSetup(brandid, typeid, commodityid);
        }

        public int AddProductIncentive(int productid, string incentive, bool isActive)
        {
            DBDispatch dbdispatch = new DBDispatch();
            return dbdispatch.AddProductIncentive(productid, incentive, isActive);
        }


        public DataSet GetAgentPaymentIncentiveSummary(int AgentID)
        {
            dbDispatch = new DBDispatch();
            return dbDispatch.GetAgentPaymentIncentiveSummary(AgentID);
        }

        public DataSet GetAgentInfoForAgentCloser(int AgentID)
        {
            dbDispatch = new DBDispatch();
            return dbDispatch.GetAgentInfoForAgentCloser(AgentID);
        }

        public int AgencyCloserbyAgentID(Dispatch d)
        {
            dbDispatch = new DBDispatch();
            return dbDispatch.AgencyCloserbyAgentID(d);
        }


        public DataSet PrintAgencyCloserInfo(Dispatch d)
        {
            dbDispatch = new DBDispatch();
            return dbDispatch.PrintAgencyCloserInfo(d);
        }
    }
    }
