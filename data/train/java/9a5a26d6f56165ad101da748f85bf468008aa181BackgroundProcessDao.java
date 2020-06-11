package com.bsu.sed.dao;

import com.bsu.sed.dao.generic.GenericDao;
import com.bsu.sed.model.BackgroundProcessKey;
import com.bsu.sed.model.persistent.BackgroundProcess;

/**
 * @author gbondarchuk
 */
public interface BackgroundProcessDao extends GenericDao<BackgroundProcess, Long> {

    void disableProcess(BackgroundProcessKey key);

    void enableProcess(BackgroundProcessKey key);

    void rescheduleProcess(BackgroundProcessKey key, String cron);

    boolean isDisabled(BackgroundProcessKey backgroundProcessKey);
}
