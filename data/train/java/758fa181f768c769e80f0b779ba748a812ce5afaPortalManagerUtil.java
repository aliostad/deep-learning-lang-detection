/**
 * Copyright (c) 2000-2010 Liferay, Inc. All rights reserved.
 *
 * This library is free software; you can redistribute it and/or modify it under
 * the terms of the GNU Lesser General Public License as published by the Free
 * Software Foundation; either version 2.1 of the License, or (at your option)
 * any later version.
 *
 * This library is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 * FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more
 * details.
 */

package com.liferay.portal.kernel.management;

import com.liferay.portal.kernel.util.MethodHandler;
import com.liferay.portal.model.ClusterGroup;

import java.lang.reflect.Method;

/**
 * @author Shuyang Zhou
 */
public class PortalManagerUtil {

	public static MethodHandler createManageActionMethodHandler(
		ManageAction manageAction) {

		return new MethodHandler(_manageMethod, manageAction);
	}

	public static void manage(
			ClusterGroup clusterGroup, ManageAction manageAction)
		throws ManageActionException {

		ManageAction action = new ClusterManageActionWrapper(
			clusterGroup, manageAction);

		_portalManager.manage(action);
	}

	public static void manage(ManageAction manageAction)
		throws ManageActionException {

		_portalManager.manage(manageAction);
	}

	public void setPortalManager(PortalManager portalManager) {
		_portalManager = portalManager;
	}

	private static Method _manageMethod;
	private static PortalManager _portalManager;

	static {
		try {
			_manageMethod = PortalManagerUtil.class.getDeclaredMethod(
				"manage", ManageAction.class);
		}
		catch (Exception e) {
			throw new ExceptionInInitializerError(e);
		}
	}

}