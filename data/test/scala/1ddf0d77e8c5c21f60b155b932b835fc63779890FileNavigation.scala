package it.alesc.filerenamer.navigation

import java.io.File

import it.alesc.filerenamer.prefixmanager.PrefixManager
import it.alesc.filerenamer.util.Utils

abstract class FileNavigation {
  def manageDirectory(dir: File, level: Int, skipDirsWithNoPrefix: Boolean): Unit = {
    Console.println(Utils.computeIndent(level) + "Directory: " + dir.getName)
    val filesList = dir.listFiles()

    val (directories, files) = filesList partition (x => x.isDirectory)
    directories foreach (manageDirectory(_, level + 1, skipDirsWithNoPrefix))
    if (PrefixManager.mapContains(dir.getName) ||
      (PrefixManager.searchPrefixFromFiles(dir) match {
        case Some(_) => true
        case None    => false
      }) || !skipDirsWithNoPrefix) {
      files foreach (manageFile(_, level + 1))
    }
  }

  def manageDirectory(dir: File, level: Int): Unit = manageDirectory(dir, level, false)
  def executeNavigation(file: File, skipDirsWithNoPrefix: Option[Boolean]): Unit
  def manageFile(file: File, level: Int): Unit
}