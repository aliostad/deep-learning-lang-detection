using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using NetSteps.Data.Entities.EntityModels;
using System.Data;
using System.Data.SqlClient;
using NetSteps.Common.Base;
using NetSteps.Data.Entities.Business.HelperObjects.SearchParameters;

namespace NetSteps.Data.Entities.Business
{
    public partial class DispatchLists
    {
        public static PaginatedList<DispatchListsSearchData> GetFullDispatchListsTable(PaginationParameters param) // wv:20160616 Lista todos los Dispatch Generados
        {
            object RowsCount;
            var resultDispatch = DataAccess.ExecWithStoreProcedureListParam<DispatchListsSearchData>("Core", "uspFullDispatchLists", out RowsCount,
                new SqlParameter("PageSize", SqlDbType.Int) { Value = param.PageSize },
                new SqlParameter("PageNumber", SqlDbType.Int) { Value = param.PageIndex },
                new SqlParameter("Colum", SqlDbType.VarChar) { Value = param.OrderBy },
                new SqlParameter("Order", SqlDbType.VarChar) { Value = param.Order },
                new SqlParameter("RowsCount", SqlDbType.Int) { Value = 0, Direction = ParameterDirection.Output }).ToList();

            IQueryable<DispatchListsSearchData> matchingItems = resultDispatch.AsQueryable<DispatchListsSearchData>();

            var resultTotalCount = (int)RowsCount;// matchingItems.Count();
            //ya no pues el SP pagina
            //matchingItems = matchingItems.ApplyPagination(searchParameter);

            return matchingItems.ToPaginatedList<DispatchListsSearchData>(param, resultTotalCount);
        }
                                         
        public static DispatchListsTable GetDispatchListsByDispatchListID(int DispatchListID)
        {
            DispatchListsTable dispatch = DataAccess.ExecWithStoreProcedureListParam<DispatchListsTable>("Core", "uspGetDispatchListsByDispatchListID",
                new SqlParameter("DispatchListID", SqlDbType.Int) { Value = DispatchListID }).ToList()[0];

            
            return dispatch;
        }

        public static List<DispatchsItemsListTable> GetDispatchListItemsById(int DispatchListID)
        {
            var items = DataAccess.ExecWithStoreProcedureListParam<DispatchsItemsListTable>("Core", "uspGetDispatchListItemsById",
                new SqlParameter("DispatchListID", SqlDbType.Int) { Value = DispatchListID }).ToList();
            
            return items;
        }

        public static int InsertDispatch(DispatchListsTable entidad)
        { 
            var result = DataAccess.ExecWithStoreProcedureScalarType<int>("Core", "uspInsertDispatchLists",
                new SqlParameter("Editable", SqlDbType.Int) { Value = 1 },
                new SqlParameter("Name", SqlDbType.VarChar, 200) { Value = entidad.Name },
                new SqlParameter("MarketID", SqlDbType.Int) { Value = 56 }
                );
            return result;
        }

        public static int UPDDispatchLists(string Name, int DispatchListID)
        {
            var result = DataAccess.ExecWithStoreProcedureScalarType<int>("Core", "uspUPDDispatchLists",
                new SqlParameter("Name", SqlDbType.VarChar, 200) { Value = Name },
                new SqlParameter("DispatchListID", SqlDbType.Int) { Value = DispatchListID }
                );
            return result;
        }

        public static int DelDispatchLists(int DispatchListID)
        {
            var result = DataAccess.ExecWithStoreProcedureScalarType<int>("Core", "uspDelDispatchLists", 
                new SqlParameter("DispatchListID", SqlDbType.Int) { Value = DispatchListID }
                );
            return result;
        }
         

        public static int UpdateDispatch(DispatchListsTable entidad)
        {
            var result = DataAccess.ExecWithStoreProcedureScalarType<int>("Core", "uspUpdateDispatchLists", 
                new SqlParameter("Editable", SqlDbType.Int) { Value = entidad.Editable },
                new SqlParameter("Name", SqlDbType.VarChar, 200) { Value = entidad.Name },
                new SqlParameter("MarketID", SqlDbType.Int) { Value = entidad.MarketID }
                );
            return result;
        }

        public static string DeleteDispatch(DispatchListsTable entidad)
        {
            string resultado = string.Empty;
            using (SqlConnection connection = new SqlConnection(DataAccess.GetConnectionString("Core")))
            {
                connection.Open();
                using (SqlCommand command = connection.CreateCommand())
                {
                    command.CommandText = "dbo.uspDeleteDispatchLists";
                    command.CommandType = CommandType.StoredProcedure;
                    SqlParameter DispatchID = command.Parameters.AddWithValue("@DispatchListID", entidad.DispatchListID);
                    SqlParameter Error = command.Parameters.AddWithValue("@Error", "");
                    Error.Direction = ParameterDirection.Output;

                    SqlDataReader dr = command.ExecuteReader();
                    resultado = Error.Value.ToString();
                }
            }
            return resultado;
        }
    }
}
