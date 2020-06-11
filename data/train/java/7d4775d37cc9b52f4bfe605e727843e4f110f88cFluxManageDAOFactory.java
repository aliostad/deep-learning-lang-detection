/**
 * FluxManageDAOFactory.java.
 * User: fengch  Date: 2004-6-23
 *
 * Copyright (c) 2000-2004.Huaxia Dadi Distance Learning Services Co.,Ltd.
 * All rights reserved.
 */
package com.ulearning.ulms.admin.fluxManage.dao;

import com.ulearning.ulms.admin.fluxManage.exceptions.FluxManageSysException;


public class FluxManageDAOFactory
{
        /**
         * This method instantiates a particular subclass implementing
         * the DAO methods based on the information obtained from the
         * deployment descriptor
         */
        public static FluxManageDAO getDAO()
        {
                FluxManageDAO dao = new FluxManageDAOImpl();

                return dao;
        }
}
