package com.shrj.rfid.admin.action;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import net.sourceforge.stripes.action.DefaultHandler;
import net.sourceforge.stripes.action.RedirectResolution;
import net.sourceforge.stripes.action.Resolution;
import net.sourceforge.stripes.action.UrlBinding;
import net.sourceforge.stripes.integration.spring.SpringBean;

import org.apache.commons.lang.StringUtils;

import com.shrj.rfid.admin.model.ManageChannel;
import com.shrj.rfid.admin.model.ManageNode;
import com.shrj.rfid.admin.model.ManageUser;
import com.shrj.rfid.admin.service.ManagerService;

/**
 * User: chjp
 * Date: 11-10-8
 * Time: 上午11:18
 */
@UrlBinding("/admin/manager_user.do")
public class ManagerUserAction extends BaseAdminAction {
    @SpringBean
    private ManagerService managerService;
    private List<ManageUser> manageUsers;
    private ManageUser manageUser;
    private String[] nodes;
    private long manage_id;
    private String password;
    private String username;
    private List<ManageChannel> channels;
    private Map<ManageChannel, List<ManageNode>> menus;

    @DefaultHandler
    public Resolution manager_list() {
        manageUsers = managerService.getManageUsers();
        return getResolution("admin/manager_list");
    }

    public Resolution manager_form() {
        loadMenus();
        if (manage_id > 0) {
            manageUser = managerService.getManageUser(manage_id);
            username = manageUser.getUsername();

            nodes = StringUtils.split(manageUser.getNodes(), ",");
        }
        return getResolution("admin/manager_form");
    }

    private void loadMenus(){
    	channels = managerService.getManageChannels();
    	menus = new HashMap<ManageChannel, List<ManageNode>>();
    	if(channels != null){
    		for(ManageChannel mc : channels){
    			menus.put(mc, managerService.getManageNodes(mc.getId()));
    		}
    	}
    }
    
    public Resolution close() {
        manageUser = managerService.getManageUser(manage_id);
        manageUser.setStatus(-1);
        managerService.saveManageUser(manageUser);
        return new RedirectResolution(getClass());
    }

    public Resolution open() {
        manageUser = managerService.getManageUser(manage_id);
        manageUser.setStatus(0);
        managerService.saveManageUser(manageUser);
        return new RedirectResolution(getClass());
    }

    public Resolution save_manager() {
        if (manage_id > 0) {
            manageUser = managerService.getManageUser(manage_id);
            if (StringUtils.isNotBlank(password)) {
                manageUser.setPassword(password);
            }
        } else {
            manageUser = new ManageUser();
            manageUser.setUsername(username);
            manageUser.setPassword(password);
        }
        manageUser.setNodes(StringUtils.join(nodes, ","));
        managerService.saveManageUser(manageUser);
        return new RedirectResolution(DashboardAction.class).addParameter("suc");
    }

    public List<ManageUser> getManageUsers() {
        return manageUsers;
    }

    public ManageUser getManageUser() {
        return manageUser;
    }

    public void setManageUser(ManageUser manageUser) {
        this.manageUser = manageUser;
    }

    public void setManagerService(ManagerService managerService) {
        this.managerService = managerService;
    }

    public String[] getNodes() {
        return nodes;
    }

    public void setNodes(String[] nodes) {
        this.nodes = nodes;
    }

    public long getManage_id() {
        return manage_id;
    }

    public void setManage_id(long manage_id) {
        this.manage_id = manage_id;
    }


    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public List<ManageChannel> getChannels() {
        return channels;
    }

	public Map<ManageChannel, List<ManageNode>> getMenus() {
		return menus;
	}
}
