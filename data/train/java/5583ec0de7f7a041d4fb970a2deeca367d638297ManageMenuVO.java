/**
 * 
 */
package org.jgenerator.model.vo;

import java.util.List;

import org.jgenerator.model.ManageMenu;

/**
 * @author LIZHITAO
 * 
 */
public class ManageMenuVO {
	private ManageMenu manageMenu;
	private List<ManageMenu> manageMenuList;

	public ManageMenu getManageMenu() {
		return manageMenu;
	}

	public void setManageMenu(ManageMenu manageMenu) {
		this.manageMenu = manageMenu;
	}

	public List<ManageMenu> getManageMenuList() {
		return manageMenuList;
	}

	public void setManageMenuList(List<ManageMenu> manageMenuList) {
		this.manageMenuList = manageMenuList;
	}
}
