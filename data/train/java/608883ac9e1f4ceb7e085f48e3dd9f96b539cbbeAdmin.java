package actors;

import algo.Person;
import controller.ConCommonTaskAM;
import creator.CreManageBudget;
import creator.CreManagePerson;
import creator.CreManageAccount;

public class Admin extends Person implements ConCommonTaskAM {

	private CreManageBudget creManageBudget;

	private CreManagePerson creManagePerson;

	private CreManageAccount creManageAccount;

	public void manageaccount() {

	}


	/**
	 * @see controller.ConCommonTaskAM#managebudget()
	 */
	public void managebudget() {

	}


	/**
	 * @see controller.ConCommonTaskAM#manageperson()
	 */
	public void manageperson() {

	}

}
