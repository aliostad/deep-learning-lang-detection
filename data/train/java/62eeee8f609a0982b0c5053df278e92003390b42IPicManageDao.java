/**
 * 
 */
package com.fenghuang.dao;

import com.fenghuang.entiey.PicManage;
import com.fenghuang.util.Pagination;

/**
 * @author 鲍国浩
 * 
 * 版本 ： 1.0
 * 
 * 日期 ：2013-9-2
 *
 * 描述 ：
 *
 *
 */
public interface IPicManageDao {
	
	
	public boolean insertPicManageDao(PicManage picManage);
	
	public Pagination<PicManage> getPicManagePagination(int currentPage,
			int numPerPage,String searchName);
	public boolean deletePicManageDao(PicManage picManage)throws Exception;
	public boolean updatePicManageDao(PicManage picManage)throws Exception;
	

}
