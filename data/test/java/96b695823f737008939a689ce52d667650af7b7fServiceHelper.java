package com.tienn.util;

import com.tienn.service.system.menu.MenuService;
import com.tienn.service.system.role.RoleService;
import com.tienn.service.system.user.UserService;


/**
 * @author Administrator
 *         获取Spring容器中的service bean
 */
public final class ServiceHelper {

    public static Object getService(String serviceName) {
        //WebApplicationContextUtils.
        return Const.WEB_APP_CONTEXT.getBean(serviceName);
    }

    public static UserService getUserService() {
        return (UserService) getService("userService");
    }

    public static RoleService getRoleService() {
        return (RoleService) getService("roleService");
    }

    public static MenuService getMenuService() {
        return (MenuService) getService("menuService");
    }
}
