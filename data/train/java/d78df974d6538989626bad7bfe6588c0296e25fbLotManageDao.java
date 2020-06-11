package com.boe.dao;

import java.util.List;

import com.boe.entity.LotManage;

public interface LotManageDao {

	public abstract boolean save(LotManage lotManage);
	
	public abstract LotManage load(LotManage lotManage);
	
	public abstract boolean delete(LotManage lotManage);
	
	public abstract boolean update(LotManage lotManage);
	
	public abstract int deleteBatch(String idStr);
	
	public abstract List<LotManage> getAllList();
	
	public abstract List<LotManage> getListByProductId(String productId);
	
	public abstract boolean isUnique(LotManage lotManage);
}
