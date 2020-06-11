package com.topsun.posclient.repository.service.impl;

import java.util.List;

import com.topsun.posclient.common.LoggerUtil;
import com.topsun.posclient.common.POSException;
import com.topsun.posclient.common.service.impl.BaseServiceImpl;
import com.topsun.posclient.datamodel.AdjustRepositoryInfo;
import com.topsun.posclient.datamodel.dto.AdjustRepositoryDTO;
import com.topsun.posclient.repository.RepositoryActivator;
import com.topsun.posclient.repository.dao.AdjustRepositoryDao;
import com.topsun.posclient.repository.service.IAdjustRepositoryService;

/**
 * 调仓接口实现
 * 
 * @author Dong
 * 
 */
public class AdjustRepositoryServiceImpl extends BaseServiceImpl implements
		IAdjustRepositoryService {

	/**
	 * 
	 */
	AdjustRepositoryDao adjustRepositoryDao = new AdjustRepositoryDao();

	/*
	 * (non-Javadoc)
	 * 
	 * @see com.topsun.posclient.repository.service.IAdjustRepositoryService#
	 * saveAdjustRepositoryInfo
	 * (com.topsun.posclient.repository.dto.AdjustRepositoryDTO)
	 */
	public void saveAdjustRepositoryInfo(AdjustRepositoryDTO adjustRepositoryDTO)
			throws POSException {
		try {
			adjustRepositoryDao.saveAdjustRepository(adjustRepositoryDTO);
		} catch (Exception e) {
			e.printStackTrace();
			LoggerUtil.logError(RepositoryActivator.PLUGIN_ID, e);
			throw new POSException("调仓出错！");
		}
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see com.topsun.posclient.repository.service.IAdjustRepositoryService#
	 * queryAdjustShopList(com.topsun.posclient.datamodel.AdjustShopInfo)
	 */
	public List<AdjustRepositoryInfo> queryAdjustShopList(
			AdjustRepositoryInfo adjustRepositoryInfo) throws POSException {
		List<AdjustRepositoryInfo> adjustRepositoryList = null;
		try {
			adjustRepositoryList = adjustRepositoryDao.queryAdjustRepository(adjustRepositoryInfo);
		} catch (Exception e) {
			LoggerUtil.logError(RepositoryActivator.PLUGIN_ID, e);
			throw new POSException("查询失败");
		}
		return adjustRepositoryList;
	}

}
