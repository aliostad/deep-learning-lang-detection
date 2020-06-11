package com.qumaiyao.pictureManage.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.qumaiyao.MybatisMapper;
import com.qumaiyao.Pagination;
import com.qumaiyao.pictureManage.entity.PictureManage;

/**
 * 图片管理  持久层
 * 
 * @author an hao
 *
 * 2014-12-25
 */
public interface PictureManageDao extends MybatisMapper{

    /**
     * 插入一条数据，并返回该条数据的主键
     * @param pictureManage
     * @return
     */
    public int insertAndGetPictureId(PictureManage pictureManage);
    
    /**
     * 获取某种类型的图片信息
     * @return
     */
    public List<PictureManage> getPictureManageByType(@Param("type")Long type, @Param("cityId")Long cityId);
    
    /**
     * 根据 PictureManage 的id，更新 PictureManage 对象（图片地址字段不会更新）
     * @param pictureManage
     * @return
     */
    public int updatePictureManage(PictureManage pictureManage);
    
    /**
     * 获取图片列表
     * @param pictureManage
     * @param pagination
     * @return
     */
    public List<PictureManage> listPagePictureManage(@Param(value = "pictureManage")PictureManage pictureManage, 
                                                     @Param(value = "pagination") Pagination pagination);
    
    /**
     * 批量 修改状态
     * @param state 状态（0：使用； 1：停用）
     * @param pictureIds  所要修改的图片 id数组
     * @return
     */
    public int updatePictureManageBatch(@Param(value = "state")int state, @Param(value = "pictureIds")String[] pictureIds);
    
    /**
     * 查询 PictureManage对象
     * @param pictureManage
     * @return
     */
    public PictureManage selectPictureManage(PictureManage pictureManage);
}
