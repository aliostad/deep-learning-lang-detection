/*
 * Copyright (c) 2009-2014. 上海诺诺镑客 All rights reserved.
 * @(#) DictCmdContext.java 2014-10-27 16:41
 */

package com.nonobank.user.domain.ctx;

import com.nonobank.user.domain.repository.dict.BankRepository;
import com.nonobank.user.domain.repository.dict.CollegeRepository;
import com.nonobank.user.domain.repository.dict.CommonDictRepository;
import com.nonobank.user.domain.repository.dict.LocationRepository;

/**
 * {@code Dict} 字典数据上下文对象。
 *
 * @author fuchun
 * @version $Id$
 * @since 2.0
 */
public final class DictCmdContext {

    private static final DictCmdContext CONTEXT = new DictCmdContext();

    public static DictCmdContext getContext() {
        return CONTEXT;
    }

    public static BankRepository bankRepository() {
        return CONTEXT.bankRepository;
    }

    public static CommonDictRepository commonDictRepository() {
        return CONTEXT.commonDictRepository;
    }

    public static CollegeRepository collegeRepository() {
        return CONTEXT.collegeRepository;
    }

    public static LocationRepository locationRepository() {
        return CONTEXT.locationRepository;
    }

    private CommonDictRepository commonDictRepository;
    private CollegeRepository collegeRepository;
    private LocationRepository locationRepository;
    private BankRepository bankRepository;

    private DictCmdContext() {}

    public void setBankRepository(BankRepository bankRepository) {
        this.bankRepository = bankRepository;
    }

    public void setCommonDictRepository(CommonDictRepository commonDictRepository) {
        this.commonDictRepository = commonDictRepository;
    }

    public void setCollegeRepository(CollegeRepository collegeRepository) {
        this.collegeRepository = collegeRepository;
    }

    public void setLocationRepository(LocationRepository locationRepository) {
        this.locationRepository = locationRepository;
    }
}
