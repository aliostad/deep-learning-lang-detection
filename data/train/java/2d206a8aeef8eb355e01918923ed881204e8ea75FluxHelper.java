/**
 * FluxHelper.java.
 * User: fengch  Date: 2004-6-23
 *
 * Copyright (c) 2000-2004.Huaxia Dadi Distance Learning Services Co.,Ltd.
 * All rights reserved.
 */
package com.ulearning.ulms.admin.fluxManage.helper;

import com.ulearning.ulms.admin.fluxManage.dao.FluxManageDAO;
import com.ulearning.ulms.admin.fluxManage.dao.FluxManageDAOFactory;
import com.ulearning.ulms.admin.fluxManage.exceptions.FluxManageSysException;
import com.ulearning.ulms.admin.fluxManage.model.FluxModel;


public class FluxHelper
{
        private static FluxManageDAO fluxManageDAO;

        static
        {
                fluxManageDAO = FluxManageDAOFactory.getDAO();
        }

        /**
         * ²åÈëÁ÷Á¿¿ØÖÆ¼ÇÂ¼.<br>
         *
         * @param fm
         * @throws FluxManageSysException
         */
        public static void fluxControl(FluxModel fm) throws FluxManageSysException
        {
                fluxManageDAO.insert(fm);
        }
}
