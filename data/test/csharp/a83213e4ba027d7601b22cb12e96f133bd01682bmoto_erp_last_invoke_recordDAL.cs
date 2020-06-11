using Entity;
using System;
using System.Data;
using System.Data.SqlClient;

namespace DAL.Agent
{
    public class moto_erp_last_invoke_recordDAL
    {
        #region MyRegion

        /// <summary>
        /// 得到  moto_erp_last_invoke_record 数据实体
        /// </summary>
        /// <param name="dr">dr</param>
        /// <returns>moto_erp_last_invoke_record 数据实体</returns>
        private moto_erp_last_invoke_recordEntity Populate_moto_erp_last_invoke_recordEntity_FromDr(IDataReader dr)
        {
            moto_erp_last_invoke_recordEntity Obj = new moto_erp_last_invoke_recordEntity();

            Obj.invoke_id = ((dr["invoke_id"]) == DBNull.Value) ? 0 : Convert.ToInt32(dr["invoke_id"]);
            Obj.invoke_type = dr["invoke_type"].ToString();
            Obj.invoke_ip = dr["invoke_ip"].ToString();
            Obj.invoke_year = ((dr["invoke_year"]) == DBNull.Value) ? 0 : Convert.ToInt32(dr["invoke_year"]);
            Obj.invoke_month = ((dr["invoke_month"]) == DBNull.Value) ? 0 : Convert.ToInt32(dr["invoke_month"]);
            Obj.invoke_app_key = dr["invoke_app_key"].ToString();
            Obj.last_invoke_time = ((dr["last_invoke_time"]) == DBNull.Value) ? Convert.ToDateTime(1900 - 1 - 1) : Convert.ToDateTime(dr["last_invoke_time"]);
            Obj.invoke_frequency_count = ((dr["invoke_frequency_count"]) == DBNull.Value) ? 0 : Convert.ToInt32(dr["invoke_frequency_count"]);
            Obj.invoke_total_count = ((dr["invoke_total_count"]) == DBNull.Value) ? 0 : Convert.ToInt32(dr["invoke_total_count"]);
            Obj.brand_id = ((dr["brand_id"]) == DBNull.Value) ? 0 : Convert.ToInt32(dr["brand_id"]);

            return Obj;
        }

        #endregion

        /// <summary>
        /// 获取调用接口时间日志
        /// </summary>
        /// <param name="invoke_type">调用类型(接口方法)</param>
        /// <param name="invoke_year">调用年份</param>
        /// <param name="invoke_month">调用月份</param>
        /// <param name="invoke_app_key">调用的app_key</param>
        /// <returns></returns>
        public moto_erp_last_invoke_recordEntity Get_moto_erp_last_invoke_recordEntity(string invoke_type, int invoke_year, int invoke_month, string invoke_app_key)
        {
            moto_erp_last_invoke_recordEntity _obj = null;
            SqlParameter[] _param ={
                new SqlParameter("@invoke_type",SqlDbType.VarChar),
                new SqlParameter("@invoke_year",SqlDbType.Int),
                new SqlParameter("@invoke_month",SqlDbType.Int),
                new SqlParameter("@invoke_app_key",SqlDbType.VarChar)
            };
            _param[0].Value = invoke_type;
            _param[1].Value = invoke_year;
            _param[2].Value = invoke_month;
            _param[3].Value = invoke_app_key;
            string sqlStr = @"select * from moto_erp_last_invoke_record 
                            where invoke_type=@invoke_type and invoke_year=@invoke_year and invoke_month=@invoke_month and invoke_app_key=@invoke_app_key";
            using (SqlDataReader dr = SqlHelper.ExecuteReader(Conn.SqlConn, CommandType.Text, sqlStr, _param))
            {
                while (dr.Read())
                {
                    _obj = Populate_moto_erp_last_invoke_recordEntity_FromDr(dr);
                }
                dr.Close();
            }
            return _obj;
        }

        /// <summary>
        /// 更新
        /// </summary>
        /// <param name="model"></param>
        /// <param name="isUpdateLastInvokeTime">是否更新最后调用时间</param>
        /// <returns></returns>
        public bool Update_last_invoke_recordEntity(moto_erp_last_invoke_recordEntity model)
        {
            SqlParameter[] _param ={
                new SqlParameter("@invoke_type",SqlDbType.VarChar),
                new SqlParameter("@invoke_year",SqlDbType.Int),
                new SqlParameter("@invoke_month",SqlDbType.Int),
                new SqlParameter("@invoke_app_key",SqlDbType.VarChar),
                new SqlParameter("@invoke_frequency_count",SqlDbType.Int),
                new SqlParameter("@invoke_total_count",SqlDbType.Int)

            };
            _param[0].Value = model.invoke_type;
            _param[1].Value = model.invoke_year;
            _param[2].Value = model.invoke_month;
            _param[3].Value = model.invoke_app_key;
            _param[4].Value = model.invoke_frequency_count;
            _param[5].Value = model.invoke_total_count;

            string sqlStr = @"update moto_erp_last_invoke_record 
                            set invoke_frequency_count=@invoke_frequency_count,invoke_total_count=@invoke_total_count,last_invoke_time=getdate()
                            where invoke_type=@invoke_type and invoke_year=@invoke_year and invoke_month=@invoke_month and invoke_app_key=@invoke_app_key";


            return SqlHelper.ExecuteNonQuery(Conn.SqlConn, CommandType.Text, sqlStr, _param) > 0;
        }
    }
}
