package legendary.service;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.transaction.annotation.Transactional;

import com.alibaba.fastjson.JSON;

import legendary.dao.UserManageDao;
import legendary.entity.LEmployee;

public class ManageUser {

	public ManageUser() {
		// TODO Auto-generated constructor stub
	}

	private UserManageDao userManageDao = null;

	public UserManageDao getUserManageDao() {
		return userManageDao;
	}

	@Resource(name = "userManageDao")
	public void setUserManageDao(UserManageDao userManageDao) {
		this.userManageDao = userManageDao;
	}

	// public String viewUser() {
	public List<LEmployee> viewUser() {
		System.out.println("service");
		List<LEmployee> list = userManageDao.viewAllUser();
		String jsonString = null;
		if (list.size() > 0) {
			jsonString = JSON.toJSONString(list, true);
		}

		return list;
	}

	@Transactional
	public LEmployee addUser(LEmployee lEmployee) {
		userManageDao.addUser(lEmployee);
		return null;
	}
}
