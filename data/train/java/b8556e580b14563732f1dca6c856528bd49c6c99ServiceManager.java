package com.web.service.impl;

import com.web.service.*;
import com.web.soupe.web.Permission;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service("serviceManager")
public class ServiceManager{
	@Autowired
	private RollService rollService;
	@Autowired
	private UserService userService;
    @Autowired
    private RoleService roleService;
    @Autowired
    private UserRoleOrgRelationService userRoleOrgRelationService;
    @Autowired
    private OrganizationService organizationService;
    @Autowired
    private PermissionService permissionService;
	public RollService getRollService() {
		return rollService;
	}
	public void setRollService(RollService rollService) {
		this.rollService = rollService;
	}
	public UserService getUserService() {
		return userService;
	}
	public void setUserService(UserService userService) {
		this.userService = userService;
	}

    public RoleService getRoleService() {
        return roleService;
    }

    public void setRoleService(RoleService roleService) {
        this.roleService = roleService;
    }

    public UserRoleOrgRelationService getUserRoleOrgRelationService() {
        return userRoleOrgRelationService;
    }

    public void setUserRoleOrgRelationService(UserRoleOrgRelationService userRoleOrgRelationService) {
        this.userRoleOrgRelationService = userRoleOrgRelationService;
    }

    public OrganizationService getOrganizationService() {
        return organizationService;
    }

    public void setOrganizationService(OrganizationService organizationService) {
        this.organizationService = organizationService;
    }

    public PermissionService getPermissionService() {
        return permissionService;
    }

    public void setPermissionService(PermissionService permissionService) {
        this.permissionService = permissionService;
    }
}
