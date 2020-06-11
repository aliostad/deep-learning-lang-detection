package hfdb.dao;

import java.sql.ResultSet;

import javax.servlet.jsp.jstl.sql.Result;
import javax.servlet.jsp.jstl.sql.ResultSupport;

import hfdb.entity.Manage;
import hfdb.entity.UserInfo;

/**
 * 用户的方法类，继承自BasicDao
 * @version 1.0
 * @date 14-5-4
 * @author lgs
 */

public class ManageDao extends BasicDao{ //继承BasicDao
	
	private ResultSet rs=null; //结果集
	private Result result=null;
	private String sql=""; //定义sql的变量
	private Object[] values=null; //定义对象
	private Manage manage=null;
	
	public Manage Login(String Name, String passWord) {

		sql = "SELECT * FROM manage WHERE manageName=? AND managePwd=?"; // sql语句
		values = new Object[] { Name, passWord };
		ResultSet rs = read(sql, values);
		result = ResultSupport.toResult(rs);
		resultToManageBean(result);
		return manage;
	}
	
	private void resultToManageBean(Result result) {
		if (result.getRowCount() > 0) {
			manage = new Manage(Integer.parseInt(result.getRows()[0].get(
					"manageId").toString()), result.getRows()[0].get("manageName")
					.toString(), result.getRows()[0].get("managePwd").toString());

		}
	}
}
