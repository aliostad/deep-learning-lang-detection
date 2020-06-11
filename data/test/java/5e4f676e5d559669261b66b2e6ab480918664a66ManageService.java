package net.codejava.hibernate.service;

import java.util.List;

import net.codejava.hibernate.dao.ManageDao;

public class ManageService {

	private ManageDao manageDao;

	public ManageDao getManageDao() {
		return manageDao;
	}

	public void setManageDao(ManageDao manageDao) {
		this.manageDao = manageDao;
	}

	public void clean() {
		getManageDao().clean();
	}

	public void add(Object daoObject) {
		getManageDao().save(daoObject);
	}

	public List<?> fetchAll(Class<?> tClass) {
		return getManageDao().selectAll(tClass);
	}

}
