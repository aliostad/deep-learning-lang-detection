package com.shrj.rfid.admin.service;

import java.util.List;

import org.springframework.transaction.annotation.Transactional;

import com.shrj.rfid.admin.dao.ManageChannelDAO;
import com.shrj.rfid.admin.dao.ManageNodeDAO;
import com.shrj.rfid.admin.dao.ManageUserDAO;
import com.shrj.rfid.admin.model.ManageChannel;
import com.shrj.rfid.admin.model.ManageNode;
import com.shrj.rfid.admin.model.ManageUser;

/**
 * User: chjp
 * Date: 11-10-11
 * Time: 下午4:10
 */
public class ManagerService {
    private ManageUserDAO manageUserDAO;
    private ManageNodeDAO manageNodeDAO;
    private ManageChannelDAO manageChannelDAO;

    public void setManageUserDAO(ManageUserDAO manageUserDAO) {
        this.manageUserDAO = manageUserDAO;
    }

    public void setManageNodeDAO(ManageNodeDAO manageNodeDAO) {
        this.manageNodeDAO = manageNodeDAO;
    }

    public void setManageChannelDAO(ManageChannelDAO manageChannelDAO) {
        this.manageChannelDAO = manageChannelDAO;
    }


    public ManageUser getManageUser(String username, String password) {
        return manageUserDAO.getManageUser(username, password);
    }

    public List<ManageChannel> getManageChannels() {
        return manageChannelDAO.getManageChannels();
    }

    public List<ManageUser> getManageUsers() {
        return manageUserDAO.getManageUsers();
    }

    public ManageUser getManageUser(long manage_id) {
        return manageUserDAO.get(manage_id);
    }

    @Transactional
    public void saveManageUser(ManageUser manageUser) {
        manageUserDAO.saveOrUpdate(manageUser);
    }

    public List<ManageNode> getManageNodes() {
        return manageNodeDAO.getManageNodes();
    }

    public List<ManageNode> getManageNodes(long cid) {
        return manageNodeDAO.getManageNodes(cid);
    }

    public ManageChannel getManageChannel(long cid) {
        return manageChannelDAO.get(cid);
    }

    @Transactional
    public void saveManageChannel(ManageChannel channel) {
        manageChannelDAO.saveOrUpdate(channel);
    }

    @Transactional
    public void saveManageNode(ManageNode manageNode) {
        manageNodeDAO.saveOrUpdate(manageNode);
    }

    public ManageNode getManageNode(long id) {
        return manageNodeDAO.get(id);
    }
}
