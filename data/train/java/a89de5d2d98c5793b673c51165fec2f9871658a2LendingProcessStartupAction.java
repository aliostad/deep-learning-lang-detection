package de.nak.librarymgmt.actions;

import java.util.List;

import com.opensymphony.xwork2.ActionSupport;

import de.nak.librarymgmt.model.LendingProcess;
import de.nak.librarymgmt.service.LendingProcessService;

public class LendingProcessStartupAction extends ActionSupport {

	private static final long serialVersionUID = 1L;

	private List<LendingProcess> lendingProcesses;
	private LendingProcessService lendingProcessService;
	private Long paramLendingProcess;
	private LendingProcess lendingProcessBean;

	public String execute() throws Exception {

		lendingProcesses = lendingProcessService.listLendingProcesses();

		if (!(paramLendingProcess == null)) {

			setLendingProcessBean(lendingProcessService
					.findLendingProcessById(paramLendingProcess));
		}

		System.out.println("Startup LendingProcess Ende");
		return "lendingProcessSuccess";

	}

	public Long getParamLendingProcess() {
		return paramLendingProcess;
	}

	public void setParamLendingProcess(Long paramLendingProcess) {
		this.paramLendingProcess = paramLendingProcess;
	}

	public LendingProcessService getLendingProcessService() {
		return lendingProcessService;
	}

	public void setLendingProcessService(
			LendingProcessService lendingProcessService) {
		this.lendingProcessService = lendingProcessService;
	}

	public LendingProcess getLendingProcessBean() {
		return lendingProcessBean;
	}

	public void setLendingProcessBean(LendingProcess lendingProcessBean) {
		this.lendingProcessBean = lendingProcessBean;
	}

	public List<LendingProcess> getLendingProcesses() {
		return lendingProcesses;
	}

	public void setLendingProcesses(List<LendingProcess> lendingProcesses) {
		this.lendingProcesses = lendingProcesses;
	}

}
