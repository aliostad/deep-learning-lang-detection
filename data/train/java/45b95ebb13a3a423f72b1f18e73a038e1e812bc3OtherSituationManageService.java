/**
 * 
 */
package com.tianque.serviceList.service;

import com.tianque.core.vo.PageInfo;
import com.tianque.serviceList.domain.OtherSituationManage;

/**
 * @作者:彭乐
 * @功能: 
 * @时间:2015-11-27 上午10:55:54
 * @邮箱:pengle@hztianque.com
 */
public interface OtherSituationManageService {
	/**
	 * 保存
	 */
	public OtherSituationManage addOtherSituationManage(OtherSituationManage info);

	/**
	 * 查询列表
	 */
	public PageInfo<OtherSituationManage> getOtherSituationManageListByQuery(OtherSituationManage otherSituationManage,
			Integer page, Integer rows, String sidx, String sord);

	/**
	 * 更新信息
	 * 
	 * @param companyBaseInfo
	 * @return
	 * @throws Exception
	 */
	public OtherSituationManage updateOtherSituationManage(OtherSituationManage otherSituationManage);

	/**
	 * 批量删除信息
	 * 
	 * @param ids
	 */
	public void deleteOtherSituationManageByIds(String ids);

	/**
	 * 获取主表信息
	 * 
	 * @param id
	 * @return
	 */
	public OtherSituationManage getOtherSituationManageById(Long id);
	/**
	 * 签收
	 */
	public OtherSituationManage signOtherSituationManage(OtherSituationManage otherSituationManage);
	/**
	 * 回复
	 */
	public OtherSituationManage replyOtherSituationManage(OtherSituationManage otherSituationManage);
/**
 * 手机新增
 * @param info
 * @param attachFileNames
 * @return
 */
	public OtherSituationManage addOtherSituationManage(OtherSituationManage info,String[] attachFileNames);
}
