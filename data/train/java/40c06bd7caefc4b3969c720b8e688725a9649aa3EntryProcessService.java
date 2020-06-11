package com.zh.web.service;

import java.util.List;
import com.zh.core.model.Pager;
import com.zh.web.model.bean.EntryProcess;

public interface EntryProcessService {

	/**
	 * 查询信息
	 * @param 
	 * @return
	 */
	public EntryProcess query(EntryProcess entryProcess);
	
	/**
	 * 修改
	 * @param 
	 */
	public void update(EntryProcess entryProcess);
	
	/**
	 * 查询列表
	 * @param 
	 * @return
	 */
	public List<EntryProcess> queryList(EntryProcess entryProcess);
	
	/**
	 * 查询列表，带分页
	 * @param 
	 * @return
	 */
	public List<EntryProcess> queryList(EntryProcess entryProcess , Pager page);

	/**
	 * 查询列表，带分页
	 * @param 
	 * @return
	 */
	public List<EntryProcess> queryListByPermission(EntryProcess entryProcess , Pager page);
	
	/**
	 * 查询数量
	 * @param 
	 * @return
	 */
	public Integer count(EntryProcess entryProcess);

	/**
	 * 查询数量
	 * @param 
	 * @return
	 */
	public Integer countByPermission(EntryProcess entryProcess);
	
	/**
	 * 删除
	 * @param 
	 */
	public void delete(EntryProcess entryProcess);
	
	/**
	 * 新增
	 * @param 
	 */
	public void insert(EntryProcess entryProcess);
}
