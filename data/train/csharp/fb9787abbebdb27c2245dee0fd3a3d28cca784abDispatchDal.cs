using SYFY.IT.Model;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SYFY.IT.DAL
{
    public class DispatchDal
    {
        /// <summary>
        /// 判断所传入参数是否为空
        /// </summary>
        /// <param name="obj"></param>
        /// <returns></returns>
        public static object SqlNull(object obj)
        {
            if (obj == null)
                return DBNull.Value;

            return obj;
        }

        /// <summary>
        /// 添加，连带添加产品
        /// </summary>
        /// <param name="dispatchEntity">派工单主表</param>
        /// <param name="lstMorningShif">早班派工产品</param>
        /// <param name="lstMiddleShift">中班派工产品</param>
        /// <param name="lstNightShift">晚班派工产品</param>
        /// <returns></returns>
        int result = 0;
        public int AddAndProduct(Dispatch dispatchEntity, List<DispatchProduct> lstMorningShif, List<DispatchProduct> lstMiddleShift, List<DispatchProduct> lstNightShift)
        {
            using (SqlConnection conn = new SqlConnection(DBHelper.connectionStrings))
            {
                SqlCommand cmd = new SqlCommand();
                conn.Open();
                SqlTransaction trans = conn.BeginTransaction();
                try
                {
                    //首先通过工作时间和工序ID去派工单表查是否已添加记录
                    StringBuilder strSqlSelect = new StringBuilder();
                    strSqlSelect.Append("select * from Dispatch where WorkTime = ");
                    strSqlSelect.Append("@WorkTime");
                    strSqlSelect.Append(" and ProcessId = ");
                    strSqlSelect.Append("@ProcessId");
                    SqlParameter[] parSelect = {
					                            new SqlParameter("@WorkTime", SqlDbType.NVarChar,50),
					                            new SqlParameter("@ProcessId", SqlDbType.NVarChar,50)};
                    parSelect[0].Value = SqlNull(dispatchEntity.WorkTime);
                    parSelect[1].Value = SqlNull(dispatchEntity.ProcessId);
                    using (SqlDataReader dr = DBHelper.ExecuteQuery(strSqlSelect.ToString(), CommandType.Text, parSelect))
                    {
                        if (dr.Read())
                        {
                            dispatchEntity.DispatchId = dr["DispatchId"].ToString();
                        }
                    }
                    if (dispatchEntity.DispatchId == null)//如果派工单ID等于NULL证明没有添加过，执行添加
                    {
                        dispatchEntity.DispatchId = System.Guid.NewGuid().ToString();//添加生成GUID
                        StringBuilder strSqlAdd = new StringBuilder();
                        strSqlAdd.Append("insert into Dispatch(");
                        strSqlAdd.Append("DispatchId,ProcessId,WorkTime,Early,Noon,Night,PersonId,AddTime,Dispatch_Status)");
                        strSqlAdd.Append(" values (");
                        strSqlAdd.Append("@DispatchId,@ProcessId,@WorkTime,@Early,@Noon,@Night,@PersonId,@AddTime,@Dispatch_Status)");
                        SqlParameter[] parameters = {
					                            new SqlParameter("@DispatchId", SqlDbType.NVarChar,50),
					                            new SqlParameter("@ProcessId", SqlDbType.NVarChar,50),
					                            new SqlParameter("@WorkTime", SqlDbType.NVarChar,50),
					                            new SqlParameter("@Early", SqlDbType.NVarChar,50),
					                            new SqlParameter("@Noon", SqlDbType.NVarChar,50),
					                            new SqlParameter("@Night", SqlDbType.NVarChar,50),
					                            new SqlParameter("@PersonId", SqlDbType.NVarChar,50),
					                            new SqlParameter("@AddTime", SqlDbType.NVarChar,50),
					                            new SqlParameter("@Dispatch_Status", SqlDbType.NVarChar,50)};
                        parameters[0].Value = SqlNull(dispatchEntity.DispatchId);
                        parameters[1].Value = SqlNull(dispatchEntity.ProcessId);
                        parameters[2].Value = SqlNull(dispatchEntity.WorkTime);
                        parameters[3].Value = SqlNull(dispatchEntity.Early);
                        parameters[4].Value = SqlNull(dispatchEntity.Noon);
                        parameters[5].Value = SqlNull(dispatchEntity.Night);
                        parameters[6].Value = SqlNull(dispatchEntity.PersonId);
                        parameters[7].Value = SqlNull(dispatchEntity.AddTime);
                        parameters[8].Value = SqlNull(dispatchEntity.Dispatch_Status);
                        result = result + DBHelper.NonQueryExecuteTrans(strSqlAdd.ToString(), conn, cmd, trans, parameters);
                        if (lstMorningShif.Count > 0)//添加早班
                        {
                            foreach (DispatchProduct item in lstMorningShif)
                            {
                                AddProductModel(conn, cmd, trans, item,  dispatchEntity.DispatchId);
                            }
                        }
                        if (lstMiddleShift.Count > 0)//添加中班
                        {
                            foreach (DispatchProduct item in lstMiddleShift)
                            {
                                AddProductModel(conn, cmd, trans, item, dispatchEntity.DispatchId);
                            }
                        }
                        if (lstNightShift.Count > 0)//添加晚班
                        {
                            foreach (DispatchProduct item in lstNightShift)
                            {
                                AddProductModel(conn, cmd, trans, item, dispatchEntity.DispatchId);
                            }
                        }
                    }
                    else//已添加过产品
                    {
                        //首先删除子表（产品表）相关联所有记录
                        StringBuilder strSqlDeleteP = new StringBuilder();
                        strSqlDeleteP.Append("delete from DispatchProduct where DispatchId= ");
                        strSqlDeleteP.Append("@DispatchId");
                        SqlParameter[] pardelete = {
					                            new SqlParameter("@DispatchId", SqlDbType.NVarChar,50)};
                        pardelete[0].Value = SqlNull(dispatchEntity.DispatchId);
                        result = result + DBHelper.NonQueryExecuteTrans(strSqlDeleteP.ToString(), conn, cmd, trans, pardelete);
                        //更新主表
                        StringBuilder strSqlAdd = new StringBuilder();
                        strSqlAdd.Append("update Dispatch set ");
                        strSqlAdd.Append("ProcessId=@ProcessId,");
                        strSqlAdd.Append("WorkTime=@WorkTime,");
                        strSqlAdd.Append("Early=@Early,");
                        strSqlAdd.Append("Noon=@Noon,");
                        strSqlAdd.Append("Night=@Night,");
                        strSqlAdd.Append("PersonId=@PersonId,");
                        strSqlAdd.Append("AddTime=@AddTime,");
                        strSqlAdd.Append("Dispatch_Status=@Dispatch_Status");
                        strSqlAdd.Append(" where DispatchId=@DispatchId");
                        SqlParameter[] paraAdd = {
					                    new SqlParameter("@ProcessId", SqlDbType.NVarChar,50),
					                    new SqlParameter("@WorkTime", SqlDbType.NVarChar,50),
					                    new SqlParameter("@Early", SqlDbType.NVarChar,50),
					                    new SqlParameter("@Noon", SqlDbType.NVarChar,50),
					                    new SqlParameter("@Night", SqlDbType.NVarChar,50),
					                    new SqlParameter("@PersonId", SqlDbType.NVarChar,50),
					                    new SqlParameter("@AddTime", SqlDbType.NVarChar,50),
					                    new SqlParameter("@Dispatch_Status", SqlDbType.NVarChar,50),
					                    new SqlParameter("@DispatchId", SqlDbType.NVarChar,50)};
                        paraAdd[0].Value = SqlNull(dispatchEntity.ProcessId);
                        paraAdd[1].Value = SqlNull(dispatchEntity.WorkTime);
                        paraAdd[2].Value = SqlNull(dispatchEntity.Early);
                        paraAdd[3].Value = SqlNull(dispatchEntity.Noon);
                        paraAdd[4].Value = SqlNull(dispatchEntity.Night);
                        paraAdd[5].Value = SqlNull(dispatchEntity.PersonId);
                        paraAdd[6].Value = SqlNull(dispatchEntity.AddTime);
                        paraAdd[7].Value = SqlNull(dispatchEntity.Dispatch_Status);
                        paraAdd[8].Value = SqlNull(dispatchEntity.DispatchId);
                        result = result + DBHelper.NonQueryExecuteTrans(strSqlAdd.ToString(), conn, cmd, trans, paraAdd);
                        //重新添加子表记录
                        if (lstMorningShif.Count > 0)//添加早班
                        {
                            foreach (DispatchProduct item in lstMorningShif)
                            {
                                AddProductModel(conn, cmd, trans, item, dispatchEntity.DispatchId );
                            }
                        }
                        if (lstMiddleShift.Count > 0)//添加中班
                        {
                            foreach (DispatchProduct item in lstMiddleShift)
                            {
                                AddProductModel(conn, cmd, trans, item, dispatchEntity.DispatchId);
                            }
                        }
                        if (lstNightShift.Count > 0)//添加晚班
                        {
                            foreach (DispatchProduct item in lstNightShift)
                            {
                                AddProductModel(conn, cmd, trans, item, dispatchEntity.DispatchId);
                            }
                        }
                    }
                    trans.Commit();
                }
                catch (Exception ex)
                {
                    result = 0;
                    trans.Rollback();
                    throw ex;
                }
            }
            return result;
        }

        private void AddProductModel(SqlConnection conn, SqlCommand cmd, SqlTransaction trans, DispatchProduct item, string DispatchId)
        {
            StringBuilder strSqlDispatchProduct = new StringBuilder();
            strSqlDispatchProduct.Append("insert into DispatchProduct(");
            strSqlDispatchProduct.Append("DispatchProductId,DispatchId,ShiftId,OrderQuantity,CompleteQuantity,ProductId,GroupId)");
            strSqlDispatchProduct.Append(" values (");
            strSqlDispatchProduct.Append("@DispatchProductId,@DispatchId,@ShiftId,@OrderQuantity,@CompleteQuantity,@ProductId,@GroupId)");
            SqlParameter[] parametersDispatchProduct = {
					                                            new SqlParameter("@DispatchProductId", SqlDbType.NVarChar,50),
					                                            new SqlParameter("@DispatchId", SqlDbType.NVarChar,50),
					                                            new SqlParameter("@ShiftId", SqlDbType.NVarChar,50),
					                                            new SqlParameter("@OrderQuantity", SqlDbType.NVarChar,50),
					                                            new SqlParameter("@CompleteQuantity", SqlDbType.NVarChar,50),
					                                            new SqlParameter("@ProductId", SqlDbType.NVarChar,50),
					                                            new SqlParameter("@GroupId", SqlDbType.NVarChar,50)};
            parametersDispatchProduct[0].Value = SqlNull(item.DispatchProductId);
            parametersDispatchProduct[1].Value = SqlNull(DispatchId);
            parametersDispatchProduct[2].Value = SqlNull(item.ShiftId);
            parametersDispatchProduct[3].Value = SqlNull(item.OrderQuantity);
            parametersDispatchProduct[4].Value = SqlNull(item.CompleteQuantity);
            parametersDispatchProduct[5].Value = SqlNull(item.ProductId);
            parametersDispatchProduct[6].Value = SqlNull(item.GroupId);
            result = result + DBHelper.NonQueryExecuteTrans(strSqlDispatchProduct.ToString(), conn, cmd, trans, parametersDispatchProduct);
        }
    }
}
