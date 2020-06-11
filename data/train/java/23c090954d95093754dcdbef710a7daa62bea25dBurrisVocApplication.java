package services;

import com.transoft.cfa.*;

public class BurrisVocApplication extends ApplicationProxy
{
	// default constructor
	public BurrisVocApplication() {}
	
	public LUTConfigService getLUTConfigService() throws Exception {
		LUTConfigService service = new LUTConfigService();
		register(service);
		return service;
	}
	
	public LUTSignOnService getLUTSignOnService() throws Exception {
		LUTSignOnService service = new LUTSignOnService();
		register(service);
		return service;
	}
	
	public LUTRgWkPermService getLUTRgWkPermService() throws Exception {
		LUTRgWkPermService service = new LUTRgWkPermService();
		register(service);
		return service;
	}
	
	public LUTPckRegionService getLUTPckRegionService() throws Exception {
		LUTPckRegionService service = new LUTPckRegionService();
		register(service);
		return service;
	}
	
	public LUTRequestWkService getLUTRequestWkService() throws Exception {
		LUTRequestWkService service = new LUTRequestWkService();
		register(service);
		return service;
	}
	
	public LUTGetAssignService getLUTGetAssignService() throws Exception {
		LUTGetAssignService service = new LUTGetAssignService();
		register(service);
		return service;
	}
	
	public LUTGetPicksService getLUTGetPicksService() throws Exception {
		LUTGetPicksService service = new LUTGetPicksService();
		register(service);
		return service;
	}
	
	public LUTGetShRsnService getLUTGetShRsnService() throws Exception {
		LUTGetShRsnService service = new LUTGetShRsnService();
		register(service);
		return service;
	}
	
	public LUTGetCntTpService getLUTGetCntTpService() throws Exception {
		LUTGetCntTpService service = new LUTGetCntTpService();
		register(service);
		return service;
	}
	
	public LUTValidPIDService getLUTValidPIDService() throws Exception {
		LUTValidPIDService service = new LUTValidPIDService();
		register(service);
		return service;
	}
	
	public LUTGetPIDQtyService getLUTGetPIDQtyService() throws Exception {
		LUTGetPIDQtyService service = new LUTGetPIDQtyService();
		register(service);
		return service;
	}
	
	public ODRPickedService getODRPickedService() throws Exception {
		ODRPickedService service = new ODRPickedService();
		register(service);
		return service;
	}
	
	public LUTPickedService getLUTPickedService() throws Exception {
		LUTPickedService service = new LUTPickedService();
		register(service);
		return service;
	}
	
	public LUTValid128Service getLUTValid128Service() throws Exception {
		LUTValid128Service service = new LUTValid128Service();
		register(service);
		return service;
	}
	
	public ODRVarWeightService getODRVarWeightService() throws Exception {
		ODRVarWeightService service = new ODRVarWeightService();
		register(service);
		return service;
	}
	
	public LUTVarWeightService getLUTVarWeightService() throws Exception {
		LUTVarWeightService service = new LUTVarWeightService();
		register(service);
		return service;
	}
	
	public ODRUpdateStsService getODRUpdateStsService() throws Exception {
		ODRUpdateStsService service = new ODRUpdateStsService();
		register(service);
		return service;
	}
	
	public LUTUpdateStsService getLUTUpdateStsService() throws Exception {
		LUTUpdateStsService service = new LUTUpdateStsService();
		register(service);
		return service;
	}
	
	public LUTCkOperStsService getLUTCkOperStsService() throws Exception {
		LUTCkOperStsService service = new LUTCkOperStsService();
		register(service);
		return service;
	}
	
	public LUTPassAssgnService getLUTPassAssgnService() throws Exception {
		LUTPassAssgnService service = new LUTPassAssgnService();
		register(service);
		return service;
	}
	
	public LUTUndoLPickService getLUTUndoLPickService() throws Exception {
		LUTUndoLPickService service = new LUTUndoLPickService();
		register(service);
		return service;
	}
	
	public LUTReviewPckService getLUTReviewPckService() throws Exception {
		LUTReviewPckService service = new LUTReviewPckService();
		register(service);
		return service;
	}
	
	public LUTNewContnrService getLUTNewContnrService() throws Exception {
		LUTNewContnrService service = new LUTNewContnrService();
		register(service);
		return service;
	}
	
	public LUTNewContService getLUTNewContService() throws Exception {
		LUTNewContService service = new LUTNewContService();
		register(service);
		return service;
	}
	
	public LUTGetLocInvService getLUTGetLocInvService() throws Exception {
		LUTGetLocInvService service = new LUTGetLocInvService();
		register(service);
		return service;
	}
	
	public LUTInvestgtdService getLUTInvestgtdService() throws Exception {
		LUTInvestgtdService service = new LUTInvestgtdService();
		register(service);
		return service;
	}
	
	public LUTPrintService getLUTPrintService() throws Exception {
		LUTPrintService service = new LUTPrintService();
		register(service);
		return service;
	}
	
	public LUTCntReviewService getLUTCntReviewService() throws Exception {
		LUTCntReviewService service = new LUTCntReviewService();
		register(service);
		return service;
	}
	
	public LUTStopAssgnService getLUTStopAssgnService() throws Exception {
		LUTStopAssgnService service = new LUTStopAssgnService();
		register(service);
		return service;
	}
	
	public LUTSignOffService getLUTSignOffService() throws Exception {
		LUTSignOffService service = new LUTSignOffService();
		register(service);
		return service;
	}
	
	public LUTCallHelpService getLUTCallHelpService() throws Exception {
		LUTCallHelpService service = new LUTCallHelpService();
		register(service);
		return service;
	}
}
