package com.mbank.service;

import java.sql.Date;
import java.util.Calendar;
import java.util.List;

import com.mbank.model.Accounts;
import com.mbank.model.Activity;
import com.mbank.model.ClientType;
import com.mbank.model.Clients;
import com.mbank.model.Deposits;
import com.mbank.model.Properties;
import com.mbank.repository.AccountRepository;
import com.mbank.repository.ClientRepository;
import com.mbank.repository.DepositsRepository;
import com.mbank.repository.PropertiesRepository;

public class CloseDeposite implements Runnable   {
	
    private boolean finalized = false;
    private DepositsRepository depositsRepository;
    private ClientRepository clientRepository;
    private AccountRepository accountRepository;
    private PropertiesRepository propertiesRepository;
    
    
    
	public void run() {
		
	}
    
	
}
