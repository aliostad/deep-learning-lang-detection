package com.boe.dao;

import java.util.List;

import com.boe.entity.ProcessFlow;

public interface ProcessFlowDao {

	public abstract boolean save(ProcessFlow processFlow);
	
	public abstract ProcessFlow load(ProcessFlow processFlow);
	
	public abstract boolean delete(ProcessFlow processFlow);
	
	public abstract boolean update(ProcessFlow processFlow);
	
	public abstract int deleteBatch(String idStr);
	
	public abstract List<ProcessFlow> getAllList();
	
	public abstract List<ProcessFlow> getListByProductId(String productId);
	
	public abstract boolean isUnique(ProcessFlow processFlow);
	
	public abstract boolean saveBatch(List<ProcessFlow> list);
}
