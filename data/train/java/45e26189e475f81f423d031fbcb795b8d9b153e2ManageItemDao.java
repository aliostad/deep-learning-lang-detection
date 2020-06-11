package com.cyou.video.mobile.server.cms.dao.security;

import java.util.List;

import com.cyou.video.mobile.server.cms.model.security.ManageItem;

/**
 * CMS管理项持久化接口
 * @author jyz
 */
public interface ManageItemDao {

  /**
   * 创建管理项
   * @param manageItem 管理项
   * @return 管理项id
   * @throws Exception
   */
  public int createManageItem(ManageItem manageItem) throws Exception;

  /**
   * 获取管理项
   * @param id 管理项id
   * @return 管理项
   * @throws Exception
   */
  public ManageItem getManageItemById(int id) throws Exception;

  /**
   * 获取管理项
   * @param name 管理项名称
   * @return 管理项
   * @throws Exception
   */
  public ManageItem getManageItem(String name) throws Exception;

  /**
   * 更新管理项
   * @param manageItem 管理项
   * @throws Exception
   */
  public void updateManageItem(ManageItem manageItem) throws Exception;

  /**
   * 删除管理项
   * @param id 管理项id
   * @throws Exception
   */
  public void deleteManageItem(int id) throws Exception;

  /**
   * 获取管理项列表
   * @return 管理项列表
   * @throws Exception
   */
  public List<ManageItem> listManageItem() throws Exception;

  /**
   * 更新管理项排序
   * @param id 管理项id
   * @param order 管理项顺序
   * @throws Exception
   */
  public void updateManageItemOrder(int id, int order) throws Exception;
}
