package pl.jaca.cluster.distribution

/**
 * @author Jaca777
 *         Created 2015-09-13 at 14
 */

/**
 * Represents load of cluster member.
 */
abstract class Load extends Comparable[Load] { //TODO Automate
  def >(load: Load): Boolean = compareTo(load) > 0

  def <(load: Load): Boolean = compareTo(load) < 0

  def ==(load: Load): Boolean = compareTo(load) == 0

  def compareTo(load: Load): Int

  /**
   * Increases a load by the given load. There aren't any type restrictions.
   * @param load
   */
  def increase(load: Load)
}

/**
 * Name might be misleading.
 * Represents load of cluster member. Differs from Load in compareTo method. When compareTo method is called,
 * PrivilegedLoad is allowed to call compareTo method of argument, but only if argument is not a subtype of PrivilegedLoad.
 */
private[distribution] abstract class PrivilegedLoad extends Load
