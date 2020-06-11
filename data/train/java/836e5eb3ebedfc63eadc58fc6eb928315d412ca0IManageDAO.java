package project.digit.core.model.basic.Dao;

import java.util.List;

import project.digit.core.model.basic.Manage;
import project.digit.core.model.basic.ManageId;

public interface IManageDAO {
	
	public void save(Manage transientInstance);
	
	public void delete(Manage persistentInstance);
	
	public Manage findById(ManageId id);
	
	@SuppressWarnings("rawtypes")
	public List findByExample(Manage instance);
	
	@SuppressWarnings("rawtypes")
	public List findByProperty(String propertyName, Object value);
	
	@SuppressWarnings("rawtypes")
	public List findAll();
	
	public Manage merge(Manage detachedInstance);
	
	public void attachDirty(Manage instance);
	
	public void attachClean(Manage instance);
}
