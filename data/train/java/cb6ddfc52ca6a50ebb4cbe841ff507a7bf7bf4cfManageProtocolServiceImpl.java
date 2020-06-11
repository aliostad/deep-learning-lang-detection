package com.sitech.basd.yicloud.service.device;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.sitech.basd.yicloud.dao.device.ManageProtocolDao;
import com.sitech.basd.yicloud.domain.device.ManageProtocolObj;

@Service("manageProtocolService")
public class ManageProtocolServiceImpl implements ManageProtocolService {
	@Autowired
	private ManageProtocolDao manageProtocolDao;

	public int insertByObj(ManageProtocolObj obj) {
		return manageProtocolDao.insertByObj(obj);
	}

	public List queryForList(ManageProtocolObj obj) {
		return manageProtocolDao.queryForList(obj);
	}

	public ManageProtocolObj queryByObj(ManageProtocolObj obj) {
		return manageProtocolDao.queryByObj(obj);

	}

	public int updateByObj(ManageProtocolObj obj) {
		return manageProtocolDao.updateByObj(obj);
	}

	public int deleteByObj(ManageProtocolObj obj) {
		return manageProtocolDao.deleteByObj(obj);
	}
}
