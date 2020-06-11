package ru.eltech.csa.siths.service.base;

import ru.eltech.csa.siths.repository.AccountRepository;

public abstract class AbstractAccountService {
	
	AccountRepository accountRepository;

	public AbstractAccountService(AccountRepository accountRepository) {
		this.accountRepository = accountRepository;
	}

	public AbstractAccountService() {
		
	}

	public AccountRepository getAccountRepository() {
		return this.accountRepository;
	}

	public void setAccountRepository(AccountRepository accountRepository) {
		this.accountRepository = accountRepository;
	}

}