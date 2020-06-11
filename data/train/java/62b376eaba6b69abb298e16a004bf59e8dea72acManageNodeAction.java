package com.shrj.rfid.admin.action;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import net.sourceforge.stripes.action.DefaultHandler;
import net.sourceforge.stripes.action.RedirectResolution;
import net.sourceforge.stripes.action.Resolution;
import net.sourceforge.stripes.action.UrlBinding;
import net.sourceforge.stripes.integration.spring.SpringBean;

import com.shrj.rfid.admin.model.ManageChannel;
import com.shrj.rfid.admin.model.ManageNode;
import com.shrj.rfid.admin.service.ManagerService;

/**
 * User: chjp
 * Date: 11-10-20
 * Time: 上午11:00
 */
@UrlBinding("/admin/manage_node.do")
public class ManageNodeAction extends BaseAdminAction{
    @SpringBean
    private ManagerService managerService;
    private ManageNode manageNode;
    private long id;
    private Map<ManageNode, ManageChannel> nodes;
    private List<ManageChannel> channels;
    @DefaultHandler
    public Resolution list(){
    	nodes = new HashMap<ManageNode, ManageChannel>();
        List<ManageNode> mNodes=managerService.getManageNodes();
        if(mNodes != null){
        	for(ManageNode mn : mNodes){
        		nodes.put(mn, managerService.getManageChannel(mn.getCid()));
        	}
        }
        return getResolution("admin/manageNodeList");
    }

    public Resolution form(){
        if(id>0){
            manageNode=managerService.getManageNode(id);
        }
        channels = managerService.getManageChannels();
        return getResolution("admin/manageNodeForm");
    }

    public Resolution submit(){
        managerService.saveManageNode(manageNode);
        return new RedirectResolution(getClass());
    }

    public ManageNode getManageNode() {
        return manageNode;
    }

    public void setManageNode(ManageNode manageNode) {
        this.manageNode = manageNode;
    }

    public void setManagerService(ManagerService managerService) {
        this.managerService = managerService;
    }

    public void setId(long id) {
        this.id = id;
    }

	public Map<ManageNode, ManageChannel> getNodes() {
		return nodes;
	}

	public List<ManageChannel> getChannels() {
		return channels;
	}
}
