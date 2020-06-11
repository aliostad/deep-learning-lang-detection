package com.zhjy.businessgmp.action.struts;

import java.util.List;

import org.hi.SpringContextHolder;
import org.hi.framework.paging.PageInfo;
import org.hi.framework.web.PageInfoUtil;
import org.hi.framework.web.struts.BaseAction;

import com.zhjy.businessgmp.action.VideoManagePageInfo;
import com.zhjy.businessgmp.model.VideoManage;
import com.zhjy.businessgmp.service.VideoManageManager;

public class VideoManageAction extends BaseAction{
	private VideoManage videoManage;
	private VideoManagePageInfo pageInfo;
	private List<VideoManage> videoManages;
	private String orderIndexs;
	
	
	/**
	 * 保存视频管理
	 */
	public String saveVideoManage() throws Exception {
		VideoManageManager videoManageMgr = (VideoManageManager)SpringContextHolder.getBean(VideoManage.class);
		if(super.perExecute(videoManage)!= null) return returnCommand();
		videoManageMgr.saveVideoManage(videoManage);
		super.postExecute(videoManage);
		return returnCommand();
	}
	
	
	/**
	 * 删除视频管理
	 */
	public String removeVideoManage() throws Exception {
		VideoManageManager videoManageMgr = (VideoManageManager)SpringContextHolder.getBean(VideoManage.class);
		videoManageMgr.removeVideoManageById(videoManage.getId());
		return returnCommand();
	}
	
	/**
	 * 删除指定的某些视频管理
	 */
	public String removeAllVideoManage() throws Exception {
		VideoManageManager videoManageMgr = (VideoManageManager)SpringContextHolder.getBean(VideoManage.class);
		if (orderIndexs != null && orderIndexs.length()> 0 )
		{
			String[] ids= orderIndexs.split(",");
			for( int i=0; i<ids.length; i++)
			{
				if (ids[i].length()>0)
				{
				videoManageMgr.removeVideoManageById(ids[i]);
				}
			}
		}
		
		return returnCommand();
	}
	
	/**
	 *新增/修改/查看视频管理
	 */
	public String viewVideoManage() throws Exception {
		VideoManageManager videoManageMgr = (VideoManageManager)SpringContextHolder.getBean(VideoManage.class);
		videoManage = videoManageMgr.getVideoManageById(videoManage.getId());
		return returnCommand();
	}
	
	/**
	 * 视频管理列表
	 */
	public String videoManageList() throws Exception {
		VideoManageManager videoManageMgr = (VideoManageManager)SpringContextHolder.getBean(VideoManage.class);
		pageInfo = pageInfo == null ? new VideoManagePageInfo() : pageInfo;
		PageInfo sarchPageInfo = PageInfoUtil.populate(pageInfo, this);
		
		videoManages = videoManageMgr.getSecurityVideoManageList(sarchPageInfo);
		
		return returnCommand();	
	}
	
	
	
	
	public VideoManage getVideoManage() {
		return videoManage;
	}

	public void setVideoManage(VideoManage videoManage) {
		this.videoManage = videoManage;
	}
	
	public List<VideoManage> getVideoManages() {
		return videoManages;
	}

	public void setVideoManages(List<VideoManage> videoManages) {
		this.videoManages = videoManages;
	}

	public VideoManagePageInfo getPageInfo() {
		return pageInfo;
	}

	public void setPageInfo(VideoManagePageInfo pageInfo) {
		this.pageInfo = pageInfo;
	}	
	
	public String getOrderIndexs() {
		return orderIndexs;
	}

	public void setOrderIndexs(String orderIndexs) {
		this.orderIndexs = orderIndexs;
	}
	
}
