package com.wt.hea.webbuilder.dao;

import java.util.List;
import java.util.Map;

import com.wt.hea.common.dao.EntityDao;
import com.wt.hea.webbuilder.model.SiteManage;

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
public interface SiteManageDao extends EntityDao<SiteManage>
{

	/**
	 * 
	 * 方法说明：
	 * 
	 * @param e
	 *            e
	 */
	public void delete(SiteManage e);

	/**
	 * 
	 * 方法说明：
	 * 
	 * @return List<SiteManage>
	 */
	public List<SiteManage> findAll();

	/**
	 * 
	 * 方法说明：
	 * 
	 * @param property
	 *            property
	 * @param isAsc
	 *            isAsc
	 * @return List<SiteManage>
	 */
	public List<SiteManage> findAll(String property, Boolean isAsc);

	/**
	 * 
	 * 方法说明：
	 * 
	 * @param property
	 *            property
	 * @param value
	 *            value
	 * @return List<SiteManage>
	 */
	public List<SiteManage> findByProperty(String property, Object value);

	/**
	 * @param e
	 *            e
	 * @return SiteManage
	 */
	public SiteManage update(SiteManage e);

	/**
	 * 跟据实体对象多个属性的值，查找对象
	 * 
	 * @param map
	 *            key为实体对象属性名，value为对应的属性值
	 * @return List<SiteManage>
	 */
	public List<SiteManage> findByProperty(Map<String, Object> map);
}
