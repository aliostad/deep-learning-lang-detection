/**
 * Copyright (c) 2000-2013 Liferay, Inc. All rights reserved.
 *
 * The contents of this file are subject to the terms of the Liferay Enterprise
 * Subscription License ("License"). You may not use this file except in
 * compliance with the License. You can obtain a copy of the License by
 * contacting Liferay, Inc. See the License for the specific language governing
 * permissions and limitations under the License, including but not limited to
 * distribution rights of the Software.
 *
 *
 *
 */

package com.liferay.portal.workflow.kaleo.forms.service.impl;

import com.liferay.portal.kernel.exception.PortalException;
import com.liferay.portal.kernel.exception.SystemException;
import com.liferay.portal.workflow.kaleo.forms.model.KaleoProcessLink;
import com.liferay.portal.workflow.kaleo.forms.service.base.KaleoProcessLinkLocalServiceBaseImpl;

import java.util.List;

/**
 * @author Marcellus Tavares
 */
public class KaleoProcessLinkLocalServiceImpl
	extends KaleoProcessLinkLocalServiceBaseImpl {

	public KaleoProcessLink addKaleoProcessLink(
			long kaleoProcessId, String workflowTaskName, long ddmTemplateId)
		throws SystemException {

		long kaleoProcessLinkId = counterLocalService.increment();

		KaleoProcessLink kaleoProcessLink = kaleoProcessLinkPersistence.create(
			kaleoProcessLinkId);

		kaleoProcessLink.setKaleoProcessId(kaleoProcessId);
		kaleoProcessLink.setWorkflowTaskName(workflowTaskName);
		kaleoProcessLink.setDDMTemplateId(ddmTemplateId);

		kaleoProcessLinkPersistence.update(kaleoProcessLink);

		return kaleoProcessLink;
	}

	public void deleteKaleoProcessLinks(long kaleoProcessId)
		throws SystemException {

		List<KaleoProcessLink> kaleoProcessLinks =
			kaleoProcessLinkPersistence.findByKaleoProcessId(kaleoProcessId);

		for (KaleoProcessLink kaleoProcessLink : kaleoProcessLinks) {
			deleteKaleoProcessLink(kaleoProcessLink);
		}
	}

	public KaleoProcessLink fetchKaleoProcessLink(
			long kaleoProcessId, String workflowTaskName)
		throws SystemException {

		return kaleoProcessLinkPersistence.fetchByKPI_WTN(
			kaleoProcessId, workflowTaskName);
	}

	public List<KaleoProcessLink> getKaleoProcessLinks(long kaleoProcessId)
		throws SystemException {

		return kaleoProcessLinkPersistence.findByKaleoProcessId(kaleoProcessId);
	}

	public KaleoProcessLink updateKaleoProcessLink(
			long kaleoProcessLinkId, long kaleoProcessId)
		throws PortalException, SystemException {

		KaleoProcessLink kaleoProcessLink =
			kaleoProcessLinkPersistence.findByPrimaryKey(kaleoProcessLinkId);

		kaleoProcessLink.setKaleoProcessId(kaleoProcessId);

		kaleoProcessLinkPersistence.update(kaleoProcessLink);

		return kaleoProcessLink;
	}

	public KaleoProcessLink updateKaleoProcessLink(
			long kaleoProcessLinkId, long kaleoProcessId,
			String workflowTaskName, long ddmTemplateId)
		throws PortalException, SystemException {

		KaleoProcessLink kaleoProcessLink =
			kaleoProcessLinkPersistence.findByPrimaryKey(kaleoProcessLinkId);

		kaleoProcessLink.setKaleoProcessId(kaleoProcessId);
		kaleoProcessLink.setWorkflowTaskName(workflowTaskName);
		kaleoProcessLink.setDDMTemplateId(ddmTemplateId);

		kaleoProcessLinkPersistence.update(kaleoProcessLink);

		return kaleoProcessLink;
	}

	public KaleoProcessLink updateKaleoProcessLink(
			long kaleoProcessId, String workflowTaskName, long ddmTemplateId)
		throws SystemException {

		KaleoProcessLink kaleoProcessLink =
			kaleoProcessLinkPersistence.fetchByKPI_WTN(
				kaleoProcessId, workflowTaskName);

		if (kaleoProcessLink == null) {
			return addKaleoProcessLink(
				kaleoProcessId, workflowTaskName, ddmTemplateId);
		}

		kaleoProcessLink.setDDMTemplateId(ddmTemplateId);

		kaleoProcessLinkPersistence.update(kaleoProcessLink);

		return kaleoProcessLink;
	}

}