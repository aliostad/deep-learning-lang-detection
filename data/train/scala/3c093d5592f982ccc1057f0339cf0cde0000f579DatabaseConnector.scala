package sample

/**
 * simple  trait to
 * manage connections ot the database,
 * this is here so that my samples
 * can make use of it, whther they be from anazon or my own system
 * @author Jack Davey
 * @version 3rd August 2015
 */
trait DatabaseConnector
{
  /**
   * @return a value from the underlying database where the name is
   *         "dad"
   */
     def read():Int

  /**
   * writes a value to the record whose name is
   * "dad in the database
   * @param age the new age
   */
  def write(age:Int)

}

