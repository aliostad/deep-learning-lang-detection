package com.spark.util.thread;

import java.util.concurrent.TimeUnit;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;


/**
 * @author pst
 */
public abstract class OneTimeTask implements Runnable {

	protected Logger logger = LoggerFactory.getLogger(getClass());
	protected ManageScheduler manageScheduler;

	public abstract long getDelay();
	
	public abstract TimeUnit getTimeUnit();

	public void setManageScheduler(ManageScheduler manageScheduler) {
		this.manageScheduler = manageScheduler;
	}
	
	public void addTask() {
		this.manageScheduler.addTask(this);
	}
	
}
