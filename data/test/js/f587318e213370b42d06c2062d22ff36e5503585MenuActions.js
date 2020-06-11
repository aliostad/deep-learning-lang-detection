import alt from '../alt';

class AccountCloseActions {

  // Company dropdown
  updateCompanies(companies) {
    this.dispatch(companies);
  }

  companiesFailed(errorMessage) {
    this.dispatch(errorMessage);
  }

  updateCompanyValue(company) {
    this.dispatch(company);
  }

  // Account dropdown
  updateAccounts(accounts) {
    this.dispatch(accounts);
  }

  accountsFailed(errorMessage) {
    this.dispatch(errorMessage);
  }

  updateAccountValue(account) {
    this.dispatch(account);
  }

}

export default alt.createActions(AccountCloseActions);
