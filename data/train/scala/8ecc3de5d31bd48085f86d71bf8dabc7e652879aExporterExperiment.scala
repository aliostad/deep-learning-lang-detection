package it.polimi.genomics.scidb.test.experiment

import it.polimi.genomics.core.ParsingType
import it.polimi.genomics.scidb.repository.GmqlSciRepositoryManager

/**
  * Created by Cattani Simone on 02/06/16.
  * Email: simone.cattani@mail.polimi.it
  *
  */
object ExporterExperiment
{
  def main(args: Array[String]): Unit =
  {
    val repository = new GmqlSciRepositoryManager

    /*repository.exportation(
      repository.fetch("EXP_01_REF3K").get,
      "/Users/cattanisimone/Dropbox/projects/services/GenData2020/analysis/experiments/dump"
    )

    repository.exportation(
      repository.fetch("EXP_01_REF70K").get,
      "/Users/cattanisimone/Dropbox/projects/services/GenData2020/analysis/experiments/dump"
    )

    repository.exportation(repository.fetch("EXP_01_EXP1H_1H").get, "/Users/cattanisimone/Dropbox/projects/services/GenData2020/analysis/experiments/dump")
    repository.exportation(repository.fetch("EXP_01_EXP1H_2H").get, "/Users/cattanisimone/Dropbox/projects/services/GenData2020/analysis/experiments/dump")
    repository.exportation(repository.fetch("EXP_01_EXP1H_5H").get, "/Users/cattanisimone/Dropbox/projects/services/GenData2020/analysis/experiments/dump")
    repository.exportation(repository.fetch("EXP_01_EXP1H_1K").get, "/Users/cattanisimone/Dropbox/projects/services/GenData2020/analysis/experiments/dump")
    repository.exportation(repository.fetch("EXP_01_EXP1H_2K").get, "/Users/cattanisimone/Dropbox/projects/services/GenData2020/analysis/experiments/dump")
    repository.exportation(repository.fetch("EXP_01_EXP1H_5K").get, "/Users/cattanisimone/Dropbox/projects/services/GenData2020/analysis/experiments/dump")
    repository.exportation(repository.fetch("EXP_01_EXP1H_10K").get, "/Users/cattanisimone/Dropbox/projects/services/GenData2020/analysis/experiments/dump")
    repository.exportation(repository.fetch("EXP_01_EXP1H_20K").get, "/Users/cattanisimone/Dropbox/projects/services/GenData2020/analysis/experiments/dump")
    repository.exportation(repository.fetch("EXP_01_EXP1H_50K").get, "/Users/cattanisimone/Dropbox/projects/services/GenData2020/analysis/experiments/dump")
     */
    repository.exportation(repository.fetch("EXP_01_EXP70K_1H").get, "/Users/cattanisimone/Dropbox/projects/services/GenData2020/analysis/experiments/dump")
    repository.exportation(repository.fetch("EXP_01_EXP70K_2H").get, "/Users/cattanisimone/Dropbox/projects/services/GenData2020/analysis/experiments/dump")
    repository.exportation(repository.fetch("EXP_01_EXP70K_5H").get, "/Users/cattanisimone/Dropbox/projects/services/GenData2020/analysis/experiments/dump")
    repository.exportation(repository.fetch("EXP_01_EXP70K_1K").get, "/Users/cattanisimone/Dropbox/projects/services/GenData2020/analysis/experiments/dump")
    repository.exportation(repository.fetch("EXP_01_EXP70K_2K").get, "/Users/cattanisimone/Dropbox/projects/services/GenData2020/analysis/experiments/dump")
    repository.exportation(repository.fetch("EXP_01_EXP70K_5K").get, "/Users/cattanisimone/Dropbox/projects/services/GenData2020/analysis/experiments/dump")
    repository.exportation(repository.fetch("EXP_01_EXP70K_10K").get, "/Users/cattanisimone/Dropbox/projects/services/GenData2020/analysis/experiments/dump")
    repository.exportation(repository.fetch("EXP_01_EXP70K_20K").get, "/Users/cattanisimone/Dropbox/projects/services/GenData2020/analysis/experiments/dump")
    repository.exportation(repository.fetch("EXP_01_EXP70K_50K").get, "/Users/cattanisimone/Dropbox/projects/services/GenData2020/analysis/experiments/dump")

  }
}
