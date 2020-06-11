package domain.stubs;

import domain.interfaces.IAddObservationsHandler;
import domain.interfaces.ICreateCategoryHandler;
import domain.interfaces.ICreateIndicatorHandler;
import domain.interfaces.ICreateUnitHandler;
import domain.interfaces.IDCO;
import domain.interfaces.ILoginHandler;
import domain.interfaces.INewUserHandler;
import domain.interfaces.IObtainCategoriesHandler;
import domain.interfaces.IObtainIndicatorsHandler;

/**
 * An implementation of the main class of the domain.
 * It executes the start up use case and provides the
 * handlers application use case handlers
 * 
 * @author fmartins
 *
 */
public class DCO implements IDCO {

	private CreateIndicatorHandler createIndicatorHandler;
	private ILoginHandler loginHandler;
	private IObtainCategoriesHandler obtainCategoriesHandler;
	private IObtainIndicatorsHandler obtainIndicatorsHandler;
	private ICreateCategoryHandler createCategoryHandler;
	private INewUserHandler newUserHandler;
	private IAddObservationsHandler addObservationsHandler;
	private ICreateUnitHandler createUnitHandler;

	public DCO() {
		createIndicatorHandler = new CreateIndicatorHandler(); 
		loginHandler = new LoginHandlerStub();
		obtainCategoriesHandler = new ObtainCategoriesHandlerStub();
		obtainIndicatorsHandler = new ObtainIndicatorsHandler();
		createCategoryHandler = new CreateCategoryHandler();
		newUserHandler = new NewUserHandlerStub();
		addObservationsHandler = new AddObservationsHandler();
		createUnitHandler = new CreateUnitHandler();
	}
	
	@Override
	public ICreateIndicatorHandler getCreateIndicatorHandler() {
		return createIndicatorHandler;
	}

	@Override
	public IAddObservationsHandler getAddObservationsHandler() {
		return addObservationsHandler;
	}

	@Override
	public ILoginHandler getLoginHandler() {
		return loginHandler;
	}

	@Override
	public IObtainCategoriesHandler getObtainCategoriesHandler() {
		return obtainCategoriesHandler;
	}

	@Override
	public IObtainIndicatorsHandler getObtainIndicatorsHandler() {
		return obtainIndicatorsHandler;
	}

	@Override
	public ICreateCategoryHandler getCreateCategoryHandler() {
		return createCategoryHandler;
	}

	@Override
	public INewUserHandler getNewUserHandler() {
		return newUserHandler;
	}

	@Override
	public ICreateUnitHandler getCreateUnitHandler() {
		return createUnitHandler;
	}
}

