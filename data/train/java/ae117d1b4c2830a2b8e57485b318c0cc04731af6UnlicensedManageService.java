/**
 * 
 */
package com.tianque.serviceList.service;

import com.tianque.core.vo.PageInfo;
import com.tianque.plugin.taskList.domain.HiddenDanger;
import com.tianque.serviceList.domain.UnlicensedManage;

/**
 * @作者:彭乐
 * @功能: 
 * @时间:2015-11-27 上午10:55:54
 * @邮箱:pengle@hztianque.com
 */
public interface UnlicensedManageService {
	/**
	 * 保存
	 */
	public UnlicensedManage addUnlicensedManage(UnlicensedManage info);

	/**
	 * 查询列表
	 */
	public PageInfo<UnlicensedManage> getUnlicensedManageListByQuery(UnlicensedManage unlicensedManage,
			Integer page, Integer rows, String sidx, String sord);

	/**
	 * 更新信息
	 * 
	 * @param companyBaseInfo
	 * @return
	 * @throws Exception
	 */
	public UnlicensedManage updateUnlicensedManage(UnlicensedManage unlicensedManage);

	/**
	 * 批量删除信息
	 * 
	 * @param ids
	 */
	public void deleteUnlicensedManageByIds(String ids);

	/**
	 * 获取主表信息
	 * 
	 * @param id
	 * @return
	 */
	public UnlicensedManage getUnlicensedManageById(Long id);
	/**
	 * 签收
	 */
	public UnlicensedManage signUnlicensedManage(UnlicensedManage unlicensedManage);
	/**
	 * 回复
	 */
	public UnlicensedManage replyUnlicensedManage(UnlicensedManage unlicensedManage);
/**
 * 手机新增
 * @param info
 * @param attachFileNames
 * @return
 */
	public UnlicensedManage addUnlicensedManage(UnlicensedManage info,String[] attachFileNames);
}
