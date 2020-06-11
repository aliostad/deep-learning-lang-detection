/**
 * Copyright 2013 The original author or authors
 */
package com.github.popupz.popups.portlet.admin.controller

import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.portlet.bind.annotation.RenderMapping
import org.springframework.web.portlet.ModelAndView
import javax.portlet.{RenderResponse, RenderRequest}
import com.github.popupz.popups.service.PopupLocalService
import com.liferay.portal.kernel.dao.search.{SearchContainer, SearchEntry, ResultRow}
import scala.collection.JavaConversions._
import com.liferay.portal.util.PortalUtil.{getHttpServletRequest, getHttpServletResponse}
import com.github.popupz.popups.model.Popup
import com.liferay.portal.kernel.util.FastDateFormatFactoryUtil
import com.liferay.portal.theme.ThemeDisplay

@RequestMapping(Array("VIEW"))
class PopupListController (popupLocalService: PopupLocalService) {

  @RenderMapping
  def view(renderRequest: RenderRequest, renderResponse: RenderResponse, themeDisplay: ThemeDisplay) = {

    val httpRequest = getHttpServletRequest(renderRequest)
    val httpResponse = getHttpServletResponse(renderResponse)
    val servletContext = httpRequest.getSession.getServletContext

    val iteratorUrl = renderResponse.createRenderURL()

    val searchContainer = new SearchContainer[Popup](renderRequest, iteratorUrl,
      Seq("title", "create-date", "author", ""), "no-popup-was-found")

    val popups = popupLocalService.getGroupPopups(themeDisplay.getScopeGroupId, searchContainer.getStart, searchContainer.getEnd)
    val popupCount = popupLocalService.getGroupPopupsCount(themeDisplay.getScopeGroupId)

    searchContainer.setResults(popups)
    searchContainer.setTotal(popupCount)

    popups.zipWithIndex foreach (item => {
      val (message, index) = item
      val row = new ResultRow(message, message.getPopupId, index)
      row.addText(message.getTitle)

      val dateFormat = FastDateFormatFactoryUtil.getDateTime(themeDisplay.getLocale, themeDisplay.getTimeZone)
      row.addText(dateFormat.format(message.getCreateDate))
      row.addText(message.getUserName)

      row.addJSP(SearchEntry.DEFAULT_ALIGN, SearchEntry.DEFAULT_VALIGN,
        "/WEB-INF/jsp/admin/popup-list-actions.jsp", servletContext, httpRequest, httpResponse)

      searchContainer.getResultRows.add(row)
    })

    val canManagePopups = themeDisplay.getPermissionChecker.hasPermission(themeDisplay.getScopeGroupId,
      "com.github.popupz.popups.admin", themeDisplay.getScopeGroupId, "MANAGE_POPUPS")

    new ModelAndView("popup-list")
      .addObject("searchContainer", searchContainer)
      .addObject("canManagePopups", canManagePopups)

  }
}
