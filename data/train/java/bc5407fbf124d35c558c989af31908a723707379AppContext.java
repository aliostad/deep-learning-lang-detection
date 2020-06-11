package service;

public class AppContext {
	
	private MaterialService mtrlService;
	private AuMaterialService auMaterialService;	
	private WindowService windowService;
	
	public AppContext() {
		mtrlService = new MaterialService();
		auMaterialService = new AuMaterialService();
		windowService = new WindowService();
	}

	public MaterialService getMtrlService() {
		return mtrlService;
	}

	public void setMtrlService(MaterialService mtrlService) {
		this.mtrlService = mtrlService;
	}

	public AuMaterialService getAuMaterialService() {
		return auMaterialService;
	}

	public void setAuMaterialService(AuMaterialService auMaterialService) {
		this.auMaterialService = auMaterialService;
	}

	public WindowService getWindowService() {
		return windowService;
	}

	public void setWindowService(WindowService windowService) {
		this.windowService = windowService;
	}
	
	

}
