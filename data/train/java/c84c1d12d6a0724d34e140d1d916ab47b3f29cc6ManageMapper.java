package com.luyna.dao;

import java.util.List;

import com.luyna.pojo.Manage;

public interface ManageMapper {
    int deleteByPrimaryKey(Integer manageid);

    int insert(Manage record);

    int insertSelective(Manage record);

    Manage selectByPrimaryKey(Integer manageid);

    int updateByPrimaryKeySelective(Manage record);

    int updateByPrimaryKey(Manage record);
    /**
     * 根据管理员名字找出管理员
     * @param managename
     * @return
     */
    public Manage selectByManageName(String managename);
    
    public List selectAllManage();
    /**
     * 修改密码
     * @param manage
     * @return
     */
    public int updateByManageName(Manage manage);
}