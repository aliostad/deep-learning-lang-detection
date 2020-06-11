package org.THU_SFA.SFEDB.dao;

import java.util.List;

import org.THU_SFA.SFEDB.constant.AppConstant;
import org.THU_SFA.SFEDB.model.ManageUserModel;
import org.hibernate.Query;
import org.springframework.stereotype.Repository;

@Repository
public class ManageUserDao extends BaseHibernateDao {
	@SuppressWarnings("unchecked")
	public ManageUserModel getManageUserById(int id) {
		ManageUserModel m = null;
		String hql = "from " + AppConstant.MODEL_MANAGE_USER + " where "
				+ AppConstant.TABLE_MANAGE_USER_ID + " = " + id;
		Query q = this.getSession().createQuery(hql);
		List<ManageUserModel> list = q.list();
		if (list.size() > 0)
			m = (ManageUserModel) list.get(0);
		return m;
	}
	
	@SuppressWarnings("unchecked")
	public List<ManageUserModel> getManageUserAll() {
		String hql = "from " + AppConstant.MODEL_MANAGE_USER;
		Query q = this.getSession().createQuery(hql);
		List<ManageUserModel> list = q.list();
		return list;
	}

	@SuppressWarnings("unchecked")
	public ManageUserModel getManageUserByUsername(String username) {
		ManageUserModel m = null;
		String hql = "from " + AppConstant.MODEL_MANAGE_USER + " where "
				+ AppConstant.TABLE_MANAGE_USER_USERNAME + " = '" + username
				+ "'";
		Query q = this.getSession().createQuery(hql);
		List<ManageUserModel> list = q.list();
		if (list.size() > 0)
			m = (ManageUserModel) list.get(0);
		return m;
	}

	@SuppressWarnings("unchecked")
	public List<ManageUserModel> getManageUserByAuthority(int au) {
		String hql = "from " + AppConstant.MODEL_MANAGE_USER + " where "
				+ AppConstant.TABLE_MANAGE_USER_AUTHORITY + " = " + au;
		Query q = this.getSession().createQuery(hql);
		List<ManageUserModel> list = q.list();
		return list;
	}
}
