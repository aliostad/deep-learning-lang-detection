package com.openaf.browser.gui

import com.openaf.browser.gui.pages.{ManageCachesPage, ManageCachesPageFactory}
import com.openaf.browser.gui.components.ManageCachesPageComponentFactory
import com.openaf.browser.gui.api.{BrowserActionButton, BrowserContext, OpenAFApplication}

object BrowserApplication extends OpenAFApplication {
  override def utilButtons(context:BrowserContext) = List(BrowserActionButton("Manage Caches", ManageCachesPageFactory))
  override def componentFactoryMap = Map(ManageCachesPage.getClass.getName -> ManageCachesPageComponentFactory)
}
