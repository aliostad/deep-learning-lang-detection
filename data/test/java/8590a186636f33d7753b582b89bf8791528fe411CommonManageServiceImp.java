package com.scework.business.common.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.scework.business.common.dao.CommonManageDAO;
import com.scework.spi.po.common.ParamPO;
import com.system.tool.json.JsonTransUtils;

@Service("commonManageBio")
public class CommonManageServiceImp implements CommonManageService {
	@Autowired
	private CommonManageDAO commonManageDao;

	/**
	 * get commonManageDao
	 * @return  the commonManageDao
	 * @since   V1.0
	 */
	public CommonManageDAO getCommonManageDao() {
		return commonManageDao;
	}

	/**
	 * @param commonManageDao the commonManageDao to set
	 */
	public void setCommonManageDao(CommonManageDAO commonManageDao) {
		this.commonManageDao = commonManageDao;
	}

	@Override
	public String getAllCityList() {
		return String.valueOf(JsonTransUtils.toJSON(commonManageDao.getAllCityList()));
	}

	@Override
	public String getParamList(ParamPO po) {
		// TODO Auto-generated method stub
		return null;
	}
}
