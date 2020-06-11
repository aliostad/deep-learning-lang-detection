package com.linkonworks.df.busi.dao;


import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.linkonworks.df.busi.comment.Page;
import com.linkonworks.df.vo.FlupGroup;
import com.linkonworks.df.vo.PremachineManage;

public interface PremachineManageDao extends BaseDao<PremachineManage> {
	//全查
	public List<PremachineManage> getPageGroups(Page page);
	//增加
	public int addBlack(PremachineManage premachineManage);
	//删除
	public int deleteBlack(String id);
	//停用
	public int updatestate(PremachineManage premachineManage);

}
