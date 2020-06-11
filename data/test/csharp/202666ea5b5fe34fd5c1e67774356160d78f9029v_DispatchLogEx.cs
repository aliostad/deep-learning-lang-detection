using System;
using System.Data;
using System.Text;
using System.Data.SqlClient;

namespace DB_Talk.DAL
{
    /// <summary>
    ///数据访问类 v_DispatchLog
    /// </summary>	
    public partial class v_DispatchLogEx
    {
        public v_DispatchLogEx()
        { }

        #region  Method

        /// <summary>
        /// 获得数据列表
        /// </summary>
        public DataSet GetList(string strWhere)
        {
            StringBuilder strSql = new StringBuilder();
            //strSql.Append("select  ID, BoxID, ManagerID, dt_DateTime, DispatchNumber, DispatchTypeID, DispatchedNumbers, i_Result, i_State, vc_Memo, UserName, BoxName  ");
            //strSql.Append(" FROM v_DispatchLog ");

            strSql.Append("select *,");
            strSql.Append("(case  when  DispatchTypeID=0 then '' " +
                                 "when  DispatchTypeID=1 then '打电话' " +
                                 "when  DispatchTypeID=2 then '创建会议'" +
                                 "when  DispatchTypeID=3 then '挂断'" +
                                 "when  DispatchTypeID=4 then '强插' " +
                                 "when  DispatchTypeID=5 then '代答' " +
                                 "when  DispatchTypeID=6 then '保持'" +
                                 "when  DispatchTypeID=7 then '应答'" +
                                 "when  DispatchTypeID=8 then '转接' " +
                                 "when  DispatchTypeID=9 then '强拆' " +
                                 "when  DispatchTypeID=10 then '监听'" +
                                 "when  DispatchTypeID=11 then '增加会议成员'" +
                                 "when  DispatchTypeID=12 then '会议禁言' " +
                                 "when  DispatchTypeID=13 then '解除会议禁言' " +
                                 "when  DispatchTypeID=14 then '隔离会议成员'" +
                                 "when  DispatchTypeID=15 then '解除隔离会议成员'" +
                                 "when  DispatchTypeID=16 then '踢出会议成员' " +
                                 "when  DispatchTypeID=17 then '结束会议' " +
                                 "when  DispatchTypeID=18 then '录音'" +
                                 "when  DispatchTypeID=19 then '结束录音'" +
                                 "when  DispatchTypeID=20 then '会议分组操作,开始结束操作' " +
                                 "else '' end) as ActionType");
            strSql.Append(" FROM  v_DispatchLog ");

            if (strWhere.Trim() != "")
            {
                strSql.Append(" where " + strWhere);
            }
            return DB.OleDbHelper.GetDataSet(strSql.ToString());
        }

       

        #endregion
    }
}