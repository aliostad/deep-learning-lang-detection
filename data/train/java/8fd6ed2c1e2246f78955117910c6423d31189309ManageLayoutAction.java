package cn.com.ufgov.hainan.manage.action;

import java.util.List;
import cn.com.ufgov.hainan.framework.action.InitializeListener;
import cn.com.ufgov.hainan.framework.action.ModuleAction;
import cn.com.ufgov.hainan.manage.module.ManageCatalog;
import cn.com.ufgov.hainan.manage.module.ManageMenu;
import cn.com.ufgov.hainan.manage.service.ManageLayoutService;
import org.apache.struts2.json.annotations.JSON;

public class ManageLayoutAction extends ModuleAction {

	private ManageLayoutService manageLayoutService;
	private List<ManageCatalog> manageCatalogs;
	private List<ManageMenu> manageMenus;
	private String catalogId;

	@JSON(serialize = false, deserialize = false)
	public ManageLayoutService getManageLayoutService() {
		return manageLayoutService;
	}

	public void setManageLayoutService(ManageLayoutService manageLayoutService) {
		this.manageLayoutService = manageLayoutService;
	}

	public List<ManageCatalog> getManageCatalogs() {
		return manageCatalogs;
	}

	public void setManageCatalogs(List<ManageCatalog> manageCatalogs) {
		this.manageCatalogs = manageCatalogs;
	}

	public List<ManageMenu> getManageMenus() {
		return manageMenus;
	}

	public void setManageMenus(List<ManageMenu> manageMenus) {
		this.manageMenus = manageMenus;
	}

	public String getCatalogId() {
		return catalogId;
	}

	public void setCatalogId(String catalogId) {
		this.catalogId = catalogId;
	}

	@Override
	public void prepare() throws Exception {
	}

	public String execute() throws Exception {
		String result = ModuleAction.SUCCESS;

		return result;
	}

	public String executeQueryCatalogs() throws Exception {
		String result = ModuleAction.JSON;

		Object sessionUserId = this.strutsSession.get(InitializeListener.SESSION_USER_ID);
		if (sessionUserId != null) {
			if (sessionUserId instanceof String) {
				String userId = (String) sessionUserId;

				this.manageCatalogs = this.manageLayoutService.queryManageCatalogs(userId);
			}
		}

		return result;
	}

	public String executeQueryMenus() throws Exception {
		String result = ModuleAction.JSON;

		Object sessionUserId = this.strutsSession.get(InitializeListener.SESSION_USER_ID);
		if (sessionUserId != null) {
			if (sessionUserId instanceof String) {
				String userId = (String) sessionUserId;
				if (this.catalogId != null) {
					if (!this.catalogId.isEmpty()) {
						this.manageMenus = this.manageLayoutService.queryManageMenus(userId, this.catalogId);
					}
				}
			}
		}

		return result;
	}
}
