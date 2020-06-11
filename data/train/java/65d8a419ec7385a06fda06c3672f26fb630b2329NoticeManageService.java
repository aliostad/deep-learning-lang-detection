package com.its.modules.app.service;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.its.common.persistence.Page;
import com.its.common.service.CrudService;
import com.its.modules.app.dao.NoticeManageDao;
import com.its.modules.app.entity.NoticeManage;

/**
 * 公告管理Service
 * 
 * @author like
 * @version 2017-08-03
 */
@Service
@Transactional(readOnly = true)
public class NoticeManageService extends CrudService<NoticeManageDao, NoticeManage> {

	public NoticeManage get(String id) {
		return super.get(id);
	}

	public List<NoticeManage> findList(NoticeManage noticeManage) {
		return super.findList(noticeManage);
	}

	public Page<NoticeManage> findPage(Page<NoticeManage> page, NoticeManage noticeManage) {
		return super.findPage(page, noticeManage);
	}

	@Transactional(readOnly = false)
	public void save(NoticeManage noticeManage) {
		super.save(noticeManage);
	}

	@Transactional(readOnly = false)
	public void delete(NoticeManage noticeManage) {
		super.delete(noticeManage);
	}

	/**
	 * 获取最新一条公告
	 * 
	 * @param villageInfoId
	 *            楼盘ID
	 * @return
	 */
	public NoticeManage getLatestNotice(String villageInfoId) {
		return dao.getLatestNotice(villageInfoId);
	}

	/**
	 * 公告列表
	 * 
	 * @param villageInfoId
	 * @return
	 */
	public List<NoticeManage> getNoticeList(String villageInfoId, int pageIndex, int numPerPage) {
		return dao.getNoticeList(villageInfoId, pageIndex * numPerPage, numPerPage);
	}
}