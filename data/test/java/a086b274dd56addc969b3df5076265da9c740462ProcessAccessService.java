package com.maven.flow.service;

import com.maven.flow.hibernate.dao.TblProcessAccess;
import com.maven.flow.hibernate.dao.TblProcessAccessDAO;

public class ProcessAccessService {

	private TblProcessAccessDAO processAccessDAO=new TblProcessAccessDAO();
	
	public void deleteAllProcessByAppId(Integer appId) 
	{
		processAccessDAO.deleteAllProcessByAppId(appId);
	}
	public void save(TblProcessAccess processAccess) 
	{
		processAccessDAO.attachDirty(processAccess);
	}
	public  static void main(String[] args)
	{
		ProcessAccessService s=new ProcessAccessService();
		s.deleteAllProcessByAppId(new Integer(30));
		
	}
}
