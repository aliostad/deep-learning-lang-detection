package com.wt.hea.webbuilder.service.impl;

import java.io.Serializable;
import java.util.List;
import java.util.Map;

import com.wt.hea.webbuilder.model.SiteManage;
import com.wt.hea.webbuilder.service.SiteManageService;

/**
 * 
 * <pre>
 * 业务名:
 * 功能说明: 
 * 编写日期:	2011-9-20
 * 作者:	Mazhaohui
 * 
 * 历史记录
 * 1、修改日期：
 *    修改人：
 *    修改内容：
 * </pre>
 */
public class SiteManageServiceImpl extends BaseService implements SiteManageService
{

	/**
	 * @param e
	 *            e
	 */
	public void delete(SiteManage e)
	{
		this.siteManageDao.delete(e);
	}

	/**
	 * @param id
	 *            id
	 */
	public void deleteById(Serializable id)
	{
		this.siteManageDao.deleteById(id);
	}

	/**
	 * @param id
	 *            id
	 * @return SiteManage
	 */
	public SiteManage findById(Serializable id)
	{
		return this.siteManageDao.findById(id);
	}

	/**
	 * @return List<SiteManage>
	 */
	public List<SiteManage> findAll()
	{
		return this.siteManageDao.findAll();
	}

	/**
	 * @param property
	 *            property
	 * @param isAsc
	 *            isAsc
	 * @return List<SiteManage>
	 */
	public List<SiteManage> findAll(String property, Boolean isAsc)
	{
		return this.siteManageDao.findAll(property, isAsc);
	}

	/**
	 * @param property
	 *            property
	 * @param value
	 *            value
	 * @return List<SiteManage>
	 */
	public List<SiteManage> findByProperty(String property, Object value)
	{
		return this.siteManageDao.findByProperty(property, value);
	}

	/**
	 * @param e
	 *            e
	 */
	public void save(SiteManage e)
	{
		this.siteManageDao.save(e);
	}

	/**
	 * @param e
	 *            e
	 * @return SiteManage
	 */
	public SiteManage update(SiteManage e)
	{
		return this.siteManageDao.update(e);
	}

	/**
	 * @param map
	 *            map
	 * @return List<SiteManage>
	 */
	public List<SiteManage> findByProperty(Map<String, Object> map)
	{
		return this.siteManageDao.findByProperty(map);
	}
}
