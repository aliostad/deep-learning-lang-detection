package com.qumaiyao.pictureManage.service;

import java.util.List;
import java.util.Map;

import com.qumaiyao.Pagination;
import com.qumaiyao.pictureManage.entity.PictureManage;

/**
 * 图片管理 业务层
 * 
 * @author an hao
 *
 * 2014-12-25
 */
public interface PictureManageService {

    /**
     * 插入一条数据，并返回该条数据的主键
     * @param pictureManage
     * @return
     */
    public int insertAndGetPictureId(PictureManage pictureManage);
    
    /**
     * 获取促销图片（即 类型为 2））信息
     * 信息 ：data， 与关键字有关
     * @return
     */
    public List<Object> getPictureManageByType(Long cityId);

    /**
     * 获取轮播图片（即 类型为 1））信息
     * @return
     */
    public List<Object> getNextPictureManageByType(Long cityId);
    
    /**
     * 根据 PictureManage 的id，更新 PictureManage 对象（图片地址字段不会更新）
     * @param pictureManage
     * @return
     */
    public Map<String, Object> updatePictureManage(PictureManage pictureManage);
    
    /**
     * 获取图片列表
     * @param pictureManage
     * @param pagination
     * @return
     */
    public Map<String, Object> listPagePictureManage(PictureManage pictureManage, Pagination pagination);
    
    /**
     * 批量 修改状态
     * @param state 状态（0：使用； 1：停用）
     * @param pictureIds  所要修改的图片 id数组
     * @return
     */
    public int updatePictureManageBatch(int state, String pictureIds);
    
    /**
     * 查询 PictureManage对象
     * @param pictureManage
     * @return
     */
    public PictureManage selectPictureManage(PictureManage pictureManage);
}
