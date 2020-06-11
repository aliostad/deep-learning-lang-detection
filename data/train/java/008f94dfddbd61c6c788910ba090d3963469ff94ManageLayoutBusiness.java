package cn.com.ufgov.hainan.manage.business;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import cn.com.ufgov.hainan.framework.module.ActionConfiguration;
import cn.com.ufgov.hainan.framework.utility.Action;
import cn.com.ufgov.hainan.manage.module.ManageCatalog;
import cn.com.ufgov.hainan.manage.module.ManageLink;
import cn.com.ufgov.hainan.manage.module.ManageMenu;
import cn.com.ufgov.hainan.manage.module.ManageUser;
import cn.com.ufgov.hainan.manage.service.ManageCatalogService;
import cn.com.ufgov.hainan.manage.service.ManageLayoutService;
import cn.com.ufgov.hainan.manage.service.ManageMenuService;
import cn.com.ufgov.hainan.manage.service.ManageUserService;

public class ManageLayoutBusiness implements ManageLayoutService {
	private static final String DEVELOP_CATALOG_ID = "developCatalogId";
	private static final String DEVELOP_CATALOG_NAME = "Develop";
	private static final String DEVELOP_MENU_ID_PREFIX = "developMenu";
	private static final String DEVELOP_LINK_ID_PREFIX = "developLink";

	private ManageUserService manageUserService;
	private ManageCatalogService manageCatalogService;
	private ManageMenuService manageMenuService;

	public ManageUserService getManageUserService() {
		return manageUserService;
	}

	public void setManageUserService(ManageUserService manageUserService) {
		this.manageUserService = manageUserService;
	}

	public ManageCatalogService getManageCatalogService() {
		return manageCatalogService;
	}

	public void setManageCatalogService(ManageCatalogService manageCatalogService) {
		this.manageCatalogService = manageCatalogService;
	}

	public ManageMenuService getManageMenuService() {
		return manageMenuService;
	}

	public void setManageMenuService(ManageMenuService manageMenuService) {
		this.manageMenuService = manageMenuService;
	}

	@Override
	public List<ManageCatalog> queryManageCatalogs(String userId) {
		List<ManageCatalog> results = new ArrayList<ManageCatalog>();

		ManageUser manageUser = this.manageUserService.select(userId);
		if (manageUser != null) {
			List<ManageCatalog> manageCatalogs = null;

			if (manageUser.getPrerogative()) {
				manageCatalogs = this.manageCatalogService.select();

				ManageCatalog developManageCatalog = new ManageCatalog();

				developManageCatalog.setUuid(ManageLayoutBusiness.DEVELOP_CATALOG_ID);
				developManageCatalog.setName(ManageLayoutBusiness.DEVELOP_CATALOG_NAME);
				developManageCatalog.setSerial(0L);

				results.add(developManageCatalog);
			} else {
				manageCatalogs = this.manageCatalogService.selectByUserId(userId);
			}
			if (manageCatalogs != null) {
				results.addAll(manageCatalogs);
			}
		}

		return results;
	}

	private List<ManageMenu> queryDevelopManageMenus() {
		List<ManageMenu> results = new ArrayList<ManageMenu>();

		List<ActionConfiguration> actionConfigurations = Action.getActionConfigurations();
		if (actionConfigurations != null) {
			for (ActionConfiguration actionConfiguration : actionConfigurations) {
				boolean hasMenu = false;
				ManageMenu manageMenu = new ManageMenu();
				String namespace = actionConfiguration.getNamespace();

				for (ManageMenu currentManageMenu : results) {
					if (namespace.equals(currentManageMenu.getName())) {
						manageMenu = currentManageMenu;
						hasMenu = true;
						break;
					}
				}

				if (!hasMenu) {
					String menuId = String.format("%s_%d", ManageLayoutBusiness.DEVELOP_MENU_ID_PREFIX, results.size());
					String menuName = namespace;

					manageMenu.setUuid(menuId);
					manageMenu.setName(menuName);
					manageMenu.setManageLinks(new HashSet<ManageLink>());

					results.add(manageMenu);
				}

				List<String> executes = actionConfiguration.getExecutes();
				if (executes != null) {
					Set<ManageLink> manageLinks = manageMenu.getManageLinks();
					for (String execute : executes) {
						ManageLink manageLink = new ManageLink();

						String linkId = String.format("%s_%d", ManageLayoutBusiness.DEVELOP_LINK_ID_PREFIX, manageLinks.size());
						String linkName = String.format("%s!%s.action", actionConfiguration.getName(), execute);
						String linkUrl = String.format("%s/%s!%s.action", namespace, actionConfiguration.getName(), execute);

						manageLink.setUuid(linkId);
						manageLink.setName(linkName);
						manageLink.setUrl(linkUrl);

						manageLinks.add(manageLink);
					}
				}
			}
		}

		return results;
	}

	@Override
	public List<ManageMenu> queryManageMenus(String userId, String catalogId) {
		List<ManageMenu> results = new ArrayList<ManageMenu>();

		ManageUser manageUser = this.manageUserService.select(userId);
		if (manageUser != null) {

			if (manageUser.getPrerogative()) {
				if (ManageLayoutBusiness.DEVELOP_CATALOG_ID.equals(catalogId)) {
					List<ManageMenu> developManageMenus = this.queryDevelopManageMenus();
					if (developManageMenus != null) {
						results.addAll(developManageMenus);
					}
				}
			}
		}

		return results;
	}

}
