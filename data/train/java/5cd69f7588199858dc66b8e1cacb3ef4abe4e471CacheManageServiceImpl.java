package com.xwtech.uomp.base.service.memcache.impl;

import com.xwtech.uomp.base.dao.automated.CacheManageMapper;
import com.xwtech.uomp.base.pojo.memcache.CacheManageBean;
import com.xwtech.uomp.base.pojo.memcache.CacheServiceManageBean;
import com.xwtech.uomp.base.service.memcache.ICacheManageService;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

/**
 * @author huangfeilong
 * @ClassName: CacheManageServiceImpl
 * @Description: TODO(这里用一句话描述这个类的作用)
 * @date Mar 6, 2013 3:33:22 PM
 */
@Service("cacheManageService")
public class CacheManageServiceImpl implements ICacheManageService {
    protected static final Logger log = Logger.getLogger(CacheManageServiceImpl.class);

    @Autowired
    CacheManageMapper cacheManageMapper;

    /*
     * <p>Title: queryCacheManageInfoList</p>
     * <p>Description: 查询所有缓存设置信息</p>
     * @param cacheManageBean
     * @return
     * @see com.xwtech.uomp.base.service.ICacheManageService#queryCacheManageInfoList(com.xwtech.uomp.base.pojo.memcache.CacheManageBean)
     */
    public List<CacheManageBean> queryCacheManageInfoList(CacheManageBean cacheManageBean) {
        return cacheManageMapper.queryCacheManageInfoList(cacheManageBean);
    }

    /*
     * <p>Title: queryCacheManageInfoById</p>
     * <p>Description: 根据id查询缓存设置信息</p>
     * @param memKey
     * @return
     * @see com.xwtech.uomp.base.service.ICacheManageService#queryCacheManageInfoById(java.lang.String)
     */
    public CacheManageBean queryCacheManageInfoById(String memKey) {
        CacheManageBean cacheManageBean = null;

        List<CacheManageBean> cacheManageinfo = cacheManageMapper.queryCacheManageInfoById(memKey);
        if (cacheManageinfo != null && cacheManageinfo.size() > 0) {
            cacheManageBean = cacheManageinfo.get(0);
        }

        return cacheManageBean;
    }

    /*
     * <p>Title: addCacheManageInfo</p>
     * <p>Description: 添加缓存设置信息</p>
     * @param cacheManageBean
     * @see com.xwtech.uomp.base.service.ICacheManageService#addCacheManageInfo(com.xwtech.uomp.base.pojo.memcache.CacheManageBean)
     */
    public void addCacheManageInfo(CacheManageBean cacheManageBean) {
        cacheManageMapper.addCacheManageInfo(cacheManageBean);
    }

    /*
     * <p>Title: modCacheManageInfo</p>
     * <p>Description: 修改缓存设置信息</p>
     * @param cacheManageBean
     * @see com.xwtech.uomp.base.service.ICacheManageService#modCacheManageInfo(com.xwtech.uomp.base.pojo.memcache.CacheManageBean)
     */
    public void modCacheManageInfo(CacheManageBean cacheManageBean) {
        cacheManageMapper.modCacheManageInfo(cacheManageBean);
    }

    /*
     * <p>Title: delCacheManageInfo</p>
     * <p>Description: 删除缓存设置信息</p>
     * @param memKey
     * @see com.xwtech.uomp.base.service.ICacheManageService#delCacheManageInfo(java.lang.String)
     */
    public void delCacheManageInfo(String memKey) {
        cacheManageMapper.delCacheManageInfo(memKey);
    }

    /*
     * <p>Title: queryCacheService</p>
     * <p>Description: 清除缓存设置信息</p>
     * @param map
     * @return
     * @see com.xwtech.uomp.base.service.ICacheManageService#queryCacheService(java.util.Map)
     */
    public List<CacheServiceManageBean> queryCacheService(Map<String, Object> map) {
        return cacheManageMapper.queryCacheService(map);
    }
}
