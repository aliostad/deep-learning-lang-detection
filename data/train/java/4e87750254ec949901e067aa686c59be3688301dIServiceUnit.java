package core.unitofwork;

import core.services.IAccountService;
import core.services.ICoordinateService;
import core.services.IAttemptWordService;
import core.services.IDatabaseService;
import core.services.IKeyboardService;
import core.services.ILogicService;
import core.services.ISecurityService;
import core.services.IStoredSprocService;
import core.services.ITestLanguageService;
import core.services.ITestService;
import core.services.ITestWordCaseService;
import core.services.IUserTestConectionService;

public interface IServiceUnit {
	public IAccountService AccountAuthService();
	public ISecurityService SecurityService();
	public IKeyboardService KeyboardService();
	public IAttemptWordService GetAttemptWordService();
	public ITestService GetTestService();
	public ICoordinateService GetCoordinateService();
	public ITestLanguageService GetTestLanguageService();
	public ITestWordCaseService GetTestWordCaseService();
	public IUserTestConectionService UserTestConectionService();
	public ILogicService LogicService();
	public IStoredSprocService storedSprocService();
	public IDatabaseService DatabaseService();
}