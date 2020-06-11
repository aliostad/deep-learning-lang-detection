package com.apachecms.cmsx.auth.provider;

/**
 * 类SessionManageProviderFactory.java的实现描述：session管理实例工厂类
 *  
 */
public class SessionManageProviderFactory {

    /**
     * 获取cn_user的session管理类
     * 
     * @return
     */
    public static SessionManageProvider getCnUserProvider() {
        return CnUserManageProvider.getInstance();
    }

    /**
     * 获取cn_tmp的session管理类
     * 
     * @return
     */
    public static SessionManageProvider getCnTmpProvider() {
        return CnTmpManageProvider.getInstance();
    }
}
