package com.boe.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.boe.dao.LotManageDao;
import com.boe.entity.LotManage;
import com.boe.service.LotManageService;

@Service
@Transactional
public class LotManageServiceImpl implements LotManageService {
	
	@Autowired
	private LotManageDao lotManageDao;
	
	@Override
	public boolean save(LotManage lotManage) {
		return this.lotManageDao.save(lotManage);
	}

	@Override
	public LotManage load(LotManage lotManage) {
		return this.lotManageDao.load(lotManage);
	}

	@Override
	public boolean delete(LotManage lotManage) {
		return this.lotManageDao.delete(lotManage);
	}

	@Override
	public boolean update(LotManage lotManage) {
		return this.lotManageDao.update(lotManage);
	}

	@Override
	public int deleteBatch(String idStr) {
		return this.lotManageDao.deleteBatch(idStr);
	}

	@Override
	public List<LotManage> getAllList() {
		return this.lotManageDao.getAllList();
	}

	@Override
	public List<LotManage> getListByProductId(String productId) {
		return this.lotManageDao.getListByProductId(productId);
	}

	@Override
	public boolean isUnique(LotManage lotManage) {
		return this.lotManageDao.isUnique(lotManage);
	}

}
