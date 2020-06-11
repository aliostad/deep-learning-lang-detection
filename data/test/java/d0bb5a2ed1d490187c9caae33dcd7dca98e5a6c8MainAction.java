package com.womai.shop.web.action.manage.main;

import com.womai.shop.services.oscache.ManageCache;

/**
 * Created by weiweichen on 2014/9/30.
 */
public class MainAction {

    private ManageCache manageCache;

    /**
     * 加载后台首页数据
     * @return
     */
    public String initManageIndex(){
        //店主每次登陆后台都需要加载综合统计数据？！还是说每次都触发加载，但是到底加载不加载具体看系统的加载策略？！
        manageCache.loadOrdersReport();
        return "initManageIndex";
    }

    public ManageCache getManageCache() {
        return manageCache;
    }

    public void setManageCache(ManageCache manageCache) {
        this.manageCache = manageCache;
    }
}
