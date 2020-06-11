package controller

import loaders.WorkbookLoader
import service.WebService._

/**
  * Created by mesfinmebrate on 05/09/2016.
  */
object Main extends App {

  WorkbookLoader.loadEpochs.foreach(loadItem)
  WorkbookLoader.loadYears.foreach(loadItem)
  WorkbookLoader.loadBacklogItems.foreach(loadItem)
  WorkbookLoader.loadThemes.foreach(loadItem)
  WorkbookLoader.loadGoals.foreach(loadItem)
  WorkbookLoader.loadThreads.foreach(loadItem)
  WorkbookLoader.loadWeaves.foreach(loadItem)
  WorkbookLoader.loadLaserDonuts.foreach(loadItem)
  WorkbookLoader.loadPortions.foreach(loadItem)
  WorkbookLoader.loadToDos.foreach(loadItem)
  WorkbookLoader.loadHobbies.foreach(loadItem)
  WorkbookLoader.loadFinancialTracking.foreach(loadItem)
  WorkbookLoader.loadReceipts.foreach(loadItem)
  close
}