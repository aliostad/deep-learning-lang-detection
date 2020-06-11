package com.hy.bills;

import android.app.Application;

import com.hy.bills.db.SQLiteHelper;
import com.hy.bills.service.AccountBookService;
import com.hy.bills.service.BillService;
import com.hy.bills.service.CategoryService;
import com.hy.bills.service.DataBaseBackupService;
import com.hy.bills.service.StatisticsService;
import com.hy.bills.service.UserService;

public class MainApplication extends Application {
	private DataBaseBackupService dataBaseBackupService;
	private UserService userService;
	private AccountBookService accountBookService;
	private CategoryService categoryService;
	private BillService billService;
	private StatisticsService statisticsService;

	@Override
	public void onCreate() {
		super.onCreate();
		// !!!Must initialize database before initialize services which use database
		initDB();
		initVariables();
	}

	private void initVariables() {
		dataBaseBackupService = new DataBaseBackupService(this);
		userService = new UserService();
		accountBookService = new AccountBookService();
		categoryService = new CategoryService();
		billService = new BillService();
		statisticsService = new StatisticsService(this, userService, billService);
	}

	private void initDB() {
		SQLiteHelper.setContext(this);
	}

	public DataBaseBackupService getDataBaseBackupService() {
		return dataBaseBackupService;
	}

	public UserService getUserService() {
		return userService;
	}

	public AccountBookService getAccountBookService() {
		return accountBookService;
	}
	
	public CategoryService getCategoryService() {
		return categoryService;
	}
	
	public BillService getBillService() {
		return billService;
	}
	
	public StatisticsService getStatisticsService() {
		return statisticsService;
	}
}
