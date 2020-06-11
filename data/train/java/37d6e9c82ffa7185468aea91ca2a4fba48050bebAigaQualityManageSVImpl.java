package com.asiainfo.aiga.qualityManage.service.impl;

import org.hibernate.criterion.DetachedCriteria;

import com.asiainfo.aiga.qualityManage.bo.AigaQualityManage;
import com.asiainfo.aiga.qualityManage.dao.IAigaQualityManageDAO;
import com.asiainfo.aiga.qualityManage.service.IAigaQualityManageSV;

public class AigaQualityManageSVImpl implements IAigaQualityManageSV {

	private IAigaQualityManageDAO aigaQualityManageDAO;
	
	public void setAigaQualityManageDAO(IAigaQualityManageDAO aigaQualityManageDAO) {
		this.aigaQualityManageDAO = aigaQualityManageDAO;
	}

	@Override
	public AigaQualityManage[] getAllQM() throws Exception {
		// TODO Auto-generated method stub
		DetachedCriteria criteria = DetachedCriteria.forClass(AigaQualityManage.class);
		return aigaQualityManageDAO.getQM(criteria);
	}

}
