package com.zh.web.service;

import java.util.List;
import com.zh.core.model.Pager;
import com.zh.web.model.bean.TechnologicalProcess;

/**
 * 招聘人员信息接口
 * @author taozhaoping 26078
 * @author mail taozhaoping@gmail.com
 */
public interface TechnologicalProcessService {

	/**
	 * 查询信息
	 * @param 
	 * @return
	 */
	public TechnologicalProcess query(TechnologicalProcess technologicalProcess);
	
	/**
	 * 修改
	 * @param 
	 */
	public void update(TechnologicalProcess technologicalProcess);
	
	/**
	 * 查询列表
	 * @param 
	 * @return
	 */
	public List<TechnologicalProcess> queryList(TechnologicalProcess technologicalProcess);
	
	/**
	 * 查询列表，带分页
	 * @param 
	 * @return
	 */
	public List<TechnologicalProcess> queryList(TechnologicalProcess technologicalProcess , Pager page);
	
	/**
	 * 查询数量
	 * @param 
	 * @return
	 */
	public Integer count(TechnologicalProcess technologicalProcess);
	
	/**
	 * 查询列表，带分页
	 * @param 
	 * @return
	 */
	public List<TechnologicalProcess> queryListByPermission(TechnologicalProcess technologicalProcess , Pager page);
	
	/**
	 * 查询数量
	 * @param 
	 * @return
	 */
	public Integer countByPermission(TechnologicalProcess technologicalProcess);
	
	/**
	 * 删除
	 * @param 
	 */
	public void delete(TechnologicalProcess technologicalProcess);
	
	/**
	 * 新增
	 * @param 
	 */
	public void insert(TechnologicalProcess technologicalProcess);
}
