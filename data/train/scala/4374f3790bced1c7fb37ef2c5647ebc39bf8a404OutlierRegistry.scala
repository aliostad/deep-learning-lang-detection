package de.unima.dws.oamatching.pipeline.registry

import java.io.File

/**
 * Object to access the rapidminer outlier processes
 * Created by mueller on 31/03/15.
 */
object OutlierRegistry {

  val IMPLEMENTED_OUTLIER_METHODS_BY_NAME = Map(
    "knn" -> "oacode_knn.rmp",
    "rll_m5p" -> "oacode_rll_m5p.rmp",
    "rll_iso" -> "oacode_rll_iso.rmp",
    "cblof_regular_db" -> "oacode_cblof_unweighted_regular_db_scan.rmp",
    "ldcof_regular_x_means" -> "oacode_ldcof_regular_x_means.rmp",
    "ldcof_regular_db_scan" -> "oacode_ldcof_regular_db_scan.rmp",
    "lcdof_x_means" -> "oacode_ldcof_x_means.rmp",
    "lof_regular" -> "oacode_lof_regular.rmp",
    "lof" -> "oacode_lof.rmp",
    "loop" -> "oacode_loop.rmp",
    "cblof_regular_x_means" -> "oacode_cblof_unweighted_regular_x_means.rmp",
    "cblof_x_means" -> "oacode_cblof_unweighted_x_means.rmp",
    "rnn" -> "oacode_rnn.rmp"
  )

  val process_folder = "anomaly_detection"
  val separated_process_folder = process_folder + File.separator + "separated"
  val non_separated_process_folder = process_folder + File.separator + "non_separated"

  val pca_variance_dir = "pre_pro_pca_v"
  val pca_fixed_dir = "pre_pro_pca_f"
  val remove_corr_dir = "pre_pro_remove_corr"

  /**
   * get the correct process
   * @param process_type
   * @param separated
   * @param pre_pro_folder
   * @return
   */
  private def getProcess(process_type: String, separated: Boolean, pre_pro_folder: String): Option[String] = {
    val process = IMPLEMENTED_OUTLIER_METHODS_BY_NAME.get(process_type)

    if (process.isDefined) {
      val process_file = process.get

      val process_string = if (separated) {
        separated_process_folder + File.separator + pre_pro_folder + File.separator + process_file
      } else {
        non_separated_process_folder + File.separator + pre_pro_folder + File.separator + process_file
      }
      Option(process_string)
    } else {
      process
    }
  }

  def getProcessPCAVariant(process_type: String, separated: Boolean):Option[String] = getProcess(process_type,separated,pca_variance_dir)

  def getProcessPCAFixed(process_type: String, separated: Boolean):Option[String] = getProcess(process_type,separated,pca_fixed_dir)

  def getProcessRemoveCorrelated(process_type: String, separated: Boolean):Option[String] = getProcess(process_type,separated,remove_corr_dir)

}