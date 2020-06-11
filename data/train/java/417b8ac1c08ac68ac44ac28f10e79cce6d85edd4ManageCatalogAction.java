package cn.com.ufgov.hainan.manage.action;

import java.util.Calendar;
import java.util.List;

import org.apache.struts2.json.annotations.JSON;

import cn.com.ufgov.hainan.framework.action.InitializeListener;
import cn.com.ufgov.hainan.framework.action.ModuleAction;
import cn.com.ufgov.hainan.framework.business.ResultType;
import cn.com.ufgov.hainan.manage.module.ManageCatalog;
import cn.com.ufgov.hainan.manage.service.ManageCatalogService;

/**
 * 分类活动类
 */
public class ManageCatalogAction extends ModuleAction {

	/**
	 * 分类服务
	 */
	private ManageCatalogService manageCatalogService;
	/**
	 * 分类集合
	 */
	private List<ManageCatalog> manageCatalogs;
	/**
	 * 分类
	 */
	private ManageCatalog manageCatalog;

	@JSON(serialize = false, deserialize = false)
	public ManageCatalogService getManageCatalogService() {
		return manageCatalogService;
	}

	public void setManageCatalogService(ManageCatalogService manageCatalogService) {
		this.manageCatalogService = manageCatalogService;
	}

	public List<ManageCatalog> getManageCatalogs() {
		return manageCatalogs;
	}

	public void setManageCatalogs(List<ManageCatalog> manageCatalogs) {
		this.manageCatalogs = manageCatalogs;
	}

	public ManageCatalog getManageCatalog() {
		return manageCatalog;
	}

	public void setManageCatalog(ManageCatalog manageCatalog) {
		this.manageCatalog = manageCatalog;
	}

	@Override
	public void prepare() throws Exception {
	}

	public String execute() throws Exception {
		String result = ModuleAction.SUCCESS;

		return result;
	}

	public String executeQueryDataGrid() throws Exception {
		String result = ModuleAction.JSON;

		this.manageCatalogs = this.manageCatalogService.queryDataGrid(this.paging, this.manageCatalog);

		this.dojoDataGrid.setIdentifier("uuid");
		this.dojoDataGrid.setItems(this.manageCatalogs);

		return result;
	}

	public String executeInsert() throws Exception {
		String result = ModuleAction.JSON;

		ResultType resultType = ResultType.NONE;

		if (this.manageCatalog != null) {
			String userId = (String) this.strutsSession.get(InitializeListener.SESSION_USER_ID);
			Calendar now = Calendar.getInstance();

			this.manageCatalog.setUuid(null);
			this.manageCatalog.setInsertUserId(userId);
			this.manageCatalog.setInsertTime(now);
			this.manageCatalog.setUpdateUserId(userId);
			this.manageCatalog.setUpdateTime(now);

			resultType = this.manageCatalogService.insert(this.manageCatalog);
		}

		this.processMessage(resultType);

		return result;
	}

	public String executeUpdate() throws Exception {
		String result = ModuleAction.JSON;

		ResultType resultType = ResultType.NONE;

		if ((this.manageCatalog != null) && (this.manageCatalog.getUuid() != null)) {
			String userId = (String) this.strutsSession.get(InitializeListener.SESSION_USER_ID);
			Calendar now = Calendar.getInstance();

			ManageCatalog originalManageCatalog = this.manageCatalogService.select(this.manageCatalog.getUuid());

			if (originalManageCatalog != null) {
				this.manageCatalog.setInsertUserId(originalManageCatalog.getInsertUserId());
				this.manageCatalog.setInsertTime(originalManageCatalog.getInsertTime());
				this.manageCatalog.setUpdateUserId(userId);
				this.manageCatalog.setUpdateTime(now);

				resultType = this.manageCatalogService.update(this.manageCatalog);
			}
		}

		this.processMessage(resultType);

		return result;
	}

	public String executeDelete() throws Exception {
		String result = ModuleAction.JSON;

		ResultType resultType = ResultType.NONE;

		if (this.manageCatalog != null) {
			resultType = this.manageCatalogService.delete(this.manageCatalog.getUuid());
		}

		this.processMessage(resultType);

		return result;
	}
}
