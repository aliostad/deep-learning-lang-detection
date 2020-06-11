package dist;

import service.ICountryService;
import service.ICupService;
import service.IMessageService;
import service.IRaceService;
import service.IRefereeService;
import service.IResultService;
import service.ISportsmanSevice;
import service.IUserService;
import service.ServiceFactory;

public class DistServiceFactory extends ServiceFactory {

	@Override
	public ICountryService getCountryService() {
		return new DistCountryService();
	}

	@Override
	public ISportsmanSevice getSportsmanService() {
		return new DistSportsmanService();
	}

	@Override
	public IResultService getResultService() {
		return new DistResultService();
	}

	@Override
	public IRaceService getRaceService() {
		return new DistRaceService();
	}

	@Override
	public ICupService getCupService() {
		return new DistCupService();
	}

	@Override
	public IRefereeService getRefereeService() {
		return new DistRefereeService();
	}

	@Override
	public IMessageService getMessageService() {
		return new DistMessageService();
	}

	@Override
	public IUserService getUserService() {
		return new DistUserService();
	}

}
